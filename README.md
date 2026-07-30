# TripSync

> AI-powered business travel planning — generate, compare, and refine trip packages.

**MVP**: India market, business travellers. Enter trip constraints → get 3 AI-generated packages (Cheap/Balanced/Premium) → refine via chat → export to calendar.

## Stack

- **Frontend**: Flutter + Riverpod + GoRouter
- **Backend**: Supabase (Postgres + RLS + Realtime + Edge Functions)
- **Auth**: Firebase Phone OTP → Supabase JWT
- **AI**: Gemini (structured outputs)
- **CI/CD**: GitHub Actions

## Setup

```bash
# Prerequisites: Flutter SDK, Supabase CLI, Firebase CLI

# 1. Get dependencies
cd tripsync
flutter pub get

# 2. Configure Firebase
flutterfire configure --project=tripsync-14241

# 3. Link Supabase
supabase link --project-ref jkndvotawitlmgcoibiu

# 4. Run
flutter run
```

## Environment

Copy `.env.example` to `.env` and fill in secrets.  
The app reads `SUPABASE_URL` and `SUPABASE_ANON_KEY` via `--dart-define-from-file`.

## Project Structure

```
tripsync/
├── lib/
│   ├── app/              # App shell, router, theme
│   ├── core/             # Cross-cutting: errors, network, AI client
│   ├── shared/           # Shared widgets
│   ├── features/         # Feature-first modules
│   │   ├── auth/
│   │   ├── trip_creation/
│   │   ├── packages/
│   │   ├── ai_chat/
│   │   ├── itinerary/
│   │   ├── trip_history/
│   │   └── profile/
│   └── generated/        # Codegen output
├── supabase/             # Migrations, Edge Functions, seed
└── .github/workflows/    # CI
```
