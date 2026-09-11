# Growth Mentor — Data Model

## visions
| field | type | notes |
|---|---|---|
| id | uuid pk | |
| user_id | uuid nullable | owner-scoping at lock-down |
| title | text | e.g. "Become a world-class educator by 2035" |
| description | text | longer narrative |
| horizon_years | int | default 10 |
| created_at | timestamptz | |

## goals
| field | type | notes |
|---|---|---|
| id | uuid pk | |
| user_id | uuid nullable | |
| vision_id | uuid → visions | FK |
| title | text | e.g. "Run a half-marathon" |
| pillar | text | health / soft-skills / education / career / finance |
| timeframe | text | short-term / long-term |
| status | text | active / completed / archived (default active) |
| target_10x | text | what 10x looks like for this goal |
| created_at | timestamptz | |

## weekly_scorecards
| field | type | notes |
|---|---|---|
| id | uuid pk | |
| user_id | uuid nullable | |
| week_start | date | ISO Monday date |
| week_label | text | e.g. "2025-W03" |
| overall_score | numeric | avg of entries, computed on save |
| created_at | timestamptz | |

Unique constraint on (week_start, user_id).

## scorecard_entries
| field | type | notes |
|---|---|---|
| id | uuid pk | |
| user_id | uuid nullable | |
| scorecard_id | uuid → weekly_scorecards | FK |
| goal_id | uuid → goals | FK |
| score | int | 1–10, user self-assessment |
| effort | int | 1–10, perceived effort |
| notes | text | free-text reflection |
| ai_summary | text | AI-generated; nullable (next phase) |
| ai_summary_source | text | model/prompt ref |
| ai_summary_confidence | numeric | 0–1 |
| review_status | text | default 'unreviewed' |
| created_at | timestamptz | |

## habits
| field | type | notes |
|---|---|---|
| id | uuid pk | |
| user_id | uuid nullable | |
| goal_id | uuid → goals | FK |
| name | text | e.g. "Read 20 min" |
| frequency | text | daily / weekly xN |
| created_at | timestamptz | |

## RLS
All tables: permissive v1 (read/write open) → lock-down sprint replaces with `auth.uid() = user_id`.