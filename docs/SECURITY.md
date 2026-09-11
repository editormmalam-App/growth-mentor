# Growth Mentor — Security

## Secret handling
- Supabase service key lives only in server environment (Vercel env vars). Never imported in client components.
- Use Supabase anon key + RLS for client reads/writes.
- No secrets in `NEXT_PUBLIC_*` except the anon key.

## Permission model
- **v1 (demo-first):** all tables open (permissive RLS) — app renders for anonymous visitors with seed data.
- **Lock-down sprint:** every table gets `auth.uid() = user_id` policies. A user sees only their own visions, goals, scorecards, entries, habits.
- Agent (next phase) inherits the logged-in user's permissions — never runs with service key for user actions.

## Approved-tools rule
- AI may only call named, whitelisted tools (`generate_weekly_scorecard`, `suggest_goal`). Never raw query execution.
- Every meaningful action (goal created, scorecard saved, goal archived) writes an audit_log row.

## Audit principle
If an action changes data, it's logged. Logs are append-only. User can see their own audit trail.

## Honest scope
- No payments in v1. No PII beyond an email (added at lock-down). If data-loss risk appears (bulk delete, migration), stop and get a human.