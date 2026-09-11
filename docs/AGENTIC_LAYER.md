# Growth Mentor — Agentic Layer

## Draftable actions (auto, low risk)
- Generate weekly scorecard draft from active goals — no approval needed.
- Tag/score goal health (4-week avg) — auto.
- Summarize weekly notes into a 2-sentence reflection — auto (next phase).

## Executable after approval (medium risk)
- Suggest a new goal from vision text → user approves before it's created.
- Mark a goal as "needs attention" and surface on dashboard → user confirms.

## Human-only (high risk)
- Delete a goal or vision — human-only, never auto.
- Archive a vision (the system's top constraint) — human-only.
- Reset all scorecards — human-only.

## Named tools
- `generate_weekly_scorecard` — creates empty scorecard + entries for active goals.
- `save_scorecard_entry` — persists a single goal score.
- `compute_trend` — recalculates week-over-week deltas.
- `suggest_goal` (next) — drafts a goal suggestion; requires user approval.

## Audit-log fields
| field | type |
|---|---|
| id | uuid |
| user_id | uuid nullable |
| action | text |
| target_type | text |
| target_id | uuid |
| payload | jsonb |
| created_at | timestamptz |

## v1 vs later
- **v1:** All actions are direct user actions (no agent). Scorecard generation is a deterministic function.
- **Next:** AI-drafted scorecard summaries + goal suggestions with approval gate.
- **Later:** Agentic weekly nudge ("You haven't scored this week — open your scorecard").