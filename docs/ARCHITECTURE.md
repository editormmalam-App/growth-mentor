# Growth Mentor — Architecture

## Stack
Next.js (App Router) + Supabase (Postgres + RLS) + Vercel. Tailwind for UI.

## Build sequence
- **Now (v1):** Vision CRUD, goal CRUD, weekly scorecard create/score/save, trend chart. Viewable without login (seeded demo data).
- **Next:** Habit tracking + daily check-ins; AI-assisted scorecard summaries and goal suggestions.
- **Later:** Auth + per-user isolation; agentic nudges; streaks; multi-student cohorts.

## Key user flow (weekly scorecard)
1. User opens app → sees dashboard with current week's scorecard (or empty state).
2. Clicks "Open this week" → sees list of active goals with a 1–10 slider and notes field per goal.
3. Scores each goal, adds a note → clicks Save.
4. Scorecard persists; trend chart updates; pillar breakdown recalculates.
5. User can mark goals complete or archive stale ones.

## Responsive shell
Persistent left sidebar on desktop (Vision, Goals, Scorecards, Habits); collapses to hamburger menu on mobile. Current section highlighted.

## Layers (build order)
1. **Data layer** (`lib/data/`) — all Supabase reads/writes; typed query helpers.
2. **App logic** (`lib/actions/`) — scorecard generation, score computation, trend aggregation.
3. **AI layer** (`lib/ai/`) — scorecard summarization, goal suggestions (next phase).

## Why core works without AI
The scorecard is pure arithmetic: average of goal scores, per-pillar breakdown, week-over-week delta. AI is additive (summaries, nudges), never blocking.

## Repo structure
```
src/
  app/                    # routes (Vision, Goals, Scorecards, Habits)
  components/             # shared UI
  lib/
    data/                 # all DB queries (visions, goals, scorecards, habits)
    actions/              # server actions (generate scorecard, save scores)
    ai/                   # AI summarization (stubbed in v1)
    types.ts
  __tests__/              # tests beside each module
```

## Module map
| Module | Owns | Data | Build order |
|---|---|---|---|
| vision | vision CRUD | visions | 1 |
| goals | goal CRUD + archiving | goals | 2 |
| scorecards | weekly scorecard generation, scoring, trend | weekly_scorecards, scorecard_entries | 3 |
| habits | habit CRUD + check-ins (next) | habits | 4 |
| ai | scorecard summaries, goal suggestions (next) | — | 5 |