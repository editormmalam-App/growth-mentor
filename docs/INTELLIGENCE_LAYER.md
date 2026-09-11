# Growth Mentor — Intelligence Layer

## Messy inputs (next phase)
- Free-text goal descriptions → structured pillar + timeframe.
- Weekly notes → sentiment + effort tags.
- Raw habit check-ins → streak computation.

## Auto-structure schema (example)
```json
{
  "goal_title": "Run a half-marathon",
  "pillar": "health",
  "timeframe": "short-term",
  "inferred_10x": "Complete an ultramarathon within 3 years",
  "confidence": 0.82,
  "source": "goal-suggestion-v1",
  "review_status": "unreviewed"
}
```

## Events to track
- scorecard_saved — week_label, overall_score, entry_count
- goal_created / goal_completed / goal_archived
- habit_checked_in (next)

## Scoring rules (v1 — rule-based, no AI)
- **Overall weekly score** = arithmetic mean of all active-goal entry scores.
- **Pillar score** = mean of entries in that pillar.
- **Trend** = week-over-week delta of overall_score (↑ / → / ↓).
- **Goal health** = avg of last 4 weeks' scores; < 5 → flag "needs attention".

## What gets ranked
- Goals by current 4-week avg score (surface weakest first).
- Pillars by consistency (lowest variance first — areas needing stability).

## v1 vs later
- **v1:** Pure rule-based scoring + trend. No AI calls.
- **Next:** AI scorecard summary ("You're strongest in health, weakest in education — focus on X this week"). AI goal-suggestion from vision text.