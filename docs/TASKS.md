# Growth Mentor — Tasks & Sprints

## Sprint 1 — Foundation + Core Engine (v1 functional)
**Goal:** Vision + goals + weekly scorecard working end-to-end, viewable without login.
- [ ] Set up Next.js + Supabase + Tailwind; run migration SQL.
- [ ] `lib/data/` — typed queries for visions, goals, weekly_scorecards, scorecard_entries.
- [ ] Vision page: create, edit, display one vision.
- [ ] Goals page: create, edit, archive goals (pillar, timeframe, target_10x).
- [ ] Scorecard page: generate current week, score each active goal (1–10 + notes), save.
- [ ] Dashboard: latest overall score, pillar breakdown, trend (last 8 weeks).
- [ ] Seed demo data (1 vision, 5 goals, 3 weeks of scorecards).
- [ ] Sidebar nav (desktop) / hamburger (mobile); loading + empty + error states.
- **Definition of Done:** User creates a vision, adds 3 goals, opens this week's scorecard, scores all 3, saves, and sees the trend update — no login required.

## Sprint 2 — Habits + Polish
**Goal:** Add habit tracking and smooth out the core loop.
- [ ] Habits table + CRUD; link habits to goals.
- [ ] Daily check-in toggle on habit cards.
- [ ] Goal detail view with 4-week avg score + habit streak.
- [ ] Scorecard history page (browse past weeks).
- [ ] Error/empty states for all surfaces.
- **DoD:** User adds a habit to a goal, checks it in, and sees the streak on the goal detail page.

## Sprint 3 — AI Summaries + Goal Suggestions
**Goal:** Add intelligence on top of the working core.
- [ ] `lib/ai/` — scorecard summarizer (2-sentence weekly reflection with value/source/confidence/review_status).
- [ ] Goal suggestion from vision text → approval gate before creation.
- [ ] AI summary shown on scorecard, editable, review_status tracked.
- **DoD:** User saves a scorecard, AI generates a summary, user can edit it and mark reviewed.

## Sprint 4 — Lock It Down
**Goal:** Auth + per-user isolation + audit.
- [ ] Supabase Auth (email/password + magic link).
- [ ] Replace permissive RLS with `auth.uid() = user_id` on all tables.
- [ ] Audit log table + logging on goal/scorecard/vision mutations.
- [ ] Onboarding flow for new users (create first vision + first goals).
- **DoD:** Two logged-in users cannot see each other's data; every mutation is audited.

## Gantt
```
Sprint 1: Foundation + Core Engine  ████████
Sprint 2: Habits + Polish            ████████
Sprint 3: AI Summaries               ████████
Sprint 4: Lock It Down               ████████
```