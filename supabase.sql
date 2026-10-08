-- MoodNote database setup
-- Supabase Dashboard > SQL Editor에서 전체를 실행하세요.

create table if not exists public.entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  date date not null,
  mood text not null check (mood in ('happy','calm','normal','sad','angry','anxious')),
  intensity integer not null check (intensity between 1 and 5),
  tags text[] not null default '{}',
  content text not null,
  is_shared boolean not null default false,
  share_token text unique default replace(gen_random_uuid()::text, '-', ''),
  created_at timestamptz not null default now()
);

create index if not exists entries_user_date_idx on public.entries(user_id, date desc);
create index if not exists entries_share_token_idx on public.entries(share_token);

alter table public.entries enable row level security;

drop policy if exists "owners can read their entries" on public.entries;
create policy "owners can read their entries"
on public.entries for select to authenticated
using (auth.uid() = user_id);

drop policy if exists "owners can insert their entries" on public.entries;
create policy "owners can insert their entries"
on public.entries for insert to authenticated
with check (auth.uid() = user_id);

drop policy if exists "owners can update their entries" on public.entries;
create policy "owners can update their entries"
on public.entries for update to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "owners can delete their entries" on public.entries;
create policy "owners can delete their entries"
on public.entries for delete to authenticated
using (auth.uid() = user_id);

-- 처음에는 공유를 끄고 싶다면 기본값 false를 그대로 사용하세요.
-- Supabase Auth에서 Email Confirmations가 켜져 있으면 회원가입 후 이메일 인증이 필요합니다.

-- 공개 공유는 entries 테이블 자체를 anon에게 공개하지 않고,
-- 아래 함수가 share_token으로 필요한 필드만 반환하도록 합니다.
create or replace function public.get_shared_entry(p_token text)
returns table (date date, mood text, intensity integer, tags text[], content text)
language sql
security definer
set search_path = public
as $$
  select e.date, e.mood, e.intensity, e.tags, e.content
  from public.entries e
  where e.share_token = p_token
    and e.is_shared = true
  limit 1;
$$;

revoke all on function public.get_shared_entry(text) from public;
grant execute on function public.get_shared_entry(text) to anon, authenticated;
