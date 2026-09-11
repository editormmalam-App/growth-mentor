-- Growth Mentor schema (v1, demo-first)
create extension if not exists pgcrypto;

create table if not exists visions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  title text not null,
  description text,
  horizon_years int default 10,
  created_at timestamptz not null default now()
);
alter table visions enable row level security;
drop policy if exists "visions_v1_read" on visions;
create policy "visions_v1_read" on visions for select using (true);
drop policy if exists "visions_v1_write" on visions;
create policy "visions_v1_write" on visions for all using (true) with check (true);

create table if not exists goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  vision_id uuid references visions(id) on delete cascade,
  title text not null,
  pillar text not null check (pillar in ('health','soft-skills','education','career','finance')),
  timeframe text not null check (timeframe in ('short-term','long-term')),
  status text not null default 'active' check (status in ('active','completed','archived')),
  target_10x text,
  created_at timestamptz not null default now()
);
alter table goals enable row level security;
drop policy if exists "goals_v1_read" on goals;
create policy "goals_v1_read" on goals for select using (true);
drop policy if exists "goals_v1_write" on goals;
create policy "goals_v1_write" on goals for all using (true) with check (true);

create table if not exists weekly_scorecards (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  week_start date not null,
  week_label text not null,
  overall_score numeric,
  created_at timestamptz not null default now(),
  unique (week_start, user_id)
);
alter table weekly_scorecards enable row level security;
drop policy if exists "weekly_scorecards_v1_read" on weekly_scorecards;
create policy "weekly_scorecards_v1_read" on weekly_scorecards for select using (true);
drop policy if exists "weekly_scorecards_v1_write" on weekly_scorecards;
create policy "weekly_scorecards_v1_write" on weekly_scorecards for all using (true) with check (true);

create table if not exists scorecard_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  scorecard_id uuid references weekly_scorecards(id) on delete cascade,
  goal_id uuid references goals(id) on delete cascade,
  score int check (score >= 1 and score <= 10),
  effort int check (effort >= 1 and effort <= 10),
  notes text,
  ai_summary text,
  ai_summary_source text,
  ai_summary_confidence numeric,
  review_status text default 'unreviewed',
  created_at timestamptz not null default now()
);
alter table scorecard_entries enable row level security;
drop policy if exists "scorecard_entries_v1_read" on scorecard_entries;
create policy "scorecard_entries_v1_read" on scorecard_entries for select using (true);
drop policy if exists "scorecard_entries_v1_write" on scorecard_entries;
create policy "scorecard_entries_v1_write" on scorecard_entries for all using (true) with check (true);

create table if not exists habits (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  goal_id uuid references goals(id) on delete cascade,
  name text not null,
  frequency text,
  created_at timestamptz not null default now()
);
alter table habits enable row level security;
drop policy if exists "habits_v1_read" on habits;
create policy "habits_v1_read" on habits for select using (true);
drop policy if exists "habits_v1_write" on habits;
create policy "habits_v1_write" on habits for all using (true) with check (true);

-- Seed demo data
insert into visions (id, title, description, horizon_years)
values ('a1111111-1111-1111-1111-111111111111', 'Become a world-class educator and speaker by 2035', 'Build a thriving education business, speak on global stages, and achieve peak physical and mental health.', 10)
on conflict do nothing;

insert into goals (id, vision_id, title, pillar, timeframe, status, target_10x)
values
  ('b1111111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'Run a half-marathon', 'health', 'short-term', 'active', 'Complete an ultramarathon within 3 years'),
  ('b2222222-2222-2222-2222-222222222222', 'a1111111-1111-1111-1111-111111111111', 'Master public speaking', 'soft-skills', 'long-term', 'active', 'Keynote at a 10,000-person conference'),
  ('b3333333-3333-3333-3333-333333333333', 'a1111111-1111-1111-1111-111111111111', 'Finish advanced machine learning course', 'education', 'short-term', 'active', 'Publish a cited research paper'),
  ('b4444444-4444-4444-4444-444444444444', 'a1111111-1111-1111-1111-111111111111', 'Grow education business to $1M ARR', 'career', 'long-term', 'active', 'Build a $10M education platform'),
  ('b5555555-5555-5555-5555-555555555555', 'a1111111-1111-1111-1111-111111111111', 'Save 6 months of expenses', 'finance', 'short-term', 'completed', 'Build a 5-year investment portfolio')
on conflict do nothing;

insert into weekly_scorecards (id, user_id, week_start, week_label, overall_score)
values
  ('c1111111-1111-1111-1111-111111111111', null, '2025-01-13', '2025-W03', 7.0),
  ('c2222222-2222-2222-2222-222222222222', null, '2025-01-20', '2025-W04', 7.75),
  ('c3333333-3333-3333-3333-333333333333', null, '2025-01-27', '2025-W05', 8.0)
on conflict do nothing;

insert into scorecard_entries (scorecard_id, goal_id, score, effort, notes)
values
  ('c1111111-1111-1111-1111-111111111111', 'b1111111-1111-1111-1111-111111111111', 7, 6, 'Ran 3x this week, knee felt stiff'),
  ('c1111111-1111-1111-1111-111111111111', 'b2222222-2222-2222-2222-222222222222', 6, 7, 'Practiced once, need more reps'),
  ('c1111111-1111-1111-1111-111111111111', 'b3333333-3333-3333-3333-333333333333', 8, 8, 'Completed 4 modules, on track'),
  ('c2222222-2222-2222-2222-222222222222', 'b1111111-1111-1111-1111-111111111111', 8, 7, 'Ran 4x, knee much better'),
  ('c2222222-2222-2222-2222-222222222222', 'b2222222-2222-2222-2222-222222222222', 7, 8, 'Did a 15-min talk at meetup'),
  ('c2222222-2222-2222-2222-222222222222', 'b3333333-3333-3333-3333-333333333333', 8, 7, 'Finished module 5 and 6'),
  ('c3333333-3333-3333-3333-333333333333', 'b1111111-1111-1111-1111-111111111111', 9, 8, 'Ran 10k under 50 min!'),
  ('c3333333-3333-3333-3333-333333333333', 'b2222222-2222-2222-2222-222222222222', 7, 7, 'Recorded a practice video'),
  ('c3333333-3333-3333-3333-333333333333', 'b3333333-3333-3333-3333-333333333333', 8, 6, 'Started capstone project')
on conflict do nothing;

insert into habits (goal_id, name, frequency)
values
  ('b1111111-1111-1111-1111-111111111111', 'Run 30 minutes', 'daily'),
  ('b2222222-2222-2222-2222-222222222222', 'Practice speaking 15 min', 'daily'),
  ('b3333333-3333-3333-3333-333333333333', 'Study course 45 min', 'daily')
on conflict do nothing;