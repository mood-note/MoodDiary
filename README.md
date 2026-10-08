# MoodNote v2

실버/화이트 미니멀 디자인 + Supabase 로그인/회원가입 + 계정별 일기 저장 + 선택적 공유 링크 버전입니다.

## 1. Supabase 프로젝트 만들기
Supabase에서 새 프로젝트를 만든 뒤 SQL Editor에 `supabase.sql` 전체를 붙여넣어 실행합니다.

## 2. Auth 설정
Authentication 설정에서 Email 로그인 기능을 사용합니다.
Email Confirmations를 켜두면 회원가입 뒤 이메일 인증을 거쳐야 합니다.

## 3. config.js 설정
Supabase Dashboard의 Connect/API Keys 화면에서 Project URL과 Publishable key를 복사해 `config.js`에 넣습니다.

절대 넣으면 안 되는 것:
- secret key
- service_role key

## 4. GitHub Pages에 올리기
GitHub 저장소에 다음 3개 파일을 올립니다.
- index.html
- config.js
- supabase.sql

`index.html`과 `config.js`가 같은 폴더(보통 저장소 루트)에 있어야 합니다.
SQL 파일은 사이트가 읽는 파일이 아니라 Supabase SQL Editor에서 한 번 실행하기 위한 파일입니다.

## 5. 기능
- 이메일/비밀번호 회원가입 및 로그인
- 로그인 계정별 일기 저장
- 여러 기기에서 같은 계정으로 로그인하면 같은 기록 확인
- 일기 수정/삭제
- 감정 통계
- 선택한 일기만 공유 링크 생성
- 공유를 끄면 해당 링크로 더 이상 볼 수 없음

## 6. 주의
공유를 켠 일기는 링크를 가진 사람이 볼 수 있습니다. 비공개 일기는 계정 소유자만 읽을 수 있도록 RLS 정책이 적용됩니다.

GitHub Pages에는 Supabase Publishable key만 들어가야 하며, secret/service_role key는 절대 업로드하지 마세요.
