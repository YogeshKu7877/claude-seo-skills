---
phase: 02-core-live-data
plan: 02
subsystem: seo-skills
tags: [gsc, google-search-console, mcp, search-analytics, seo-commands]

# Dependency graph
requires:
  - phase: 02-core-live-data
    provides: "02-01: GSC routing table, gsc-api-reference.md verified tool names, seo-markdown-audit pattern"
provides:
  - "9 GSC sub-skill SKILL.md files enabling all /seo gsc * commands with live data"
  - "seo-gsc-overview: 28-day performance dashboard (clicks, impressions, CTR, position)"
  - "seo-gsc-drops: period comparison with CRITICAL flag for >50% drops"
  - "seo-gsc-opportunities: find_keyword_opportunities with action recommendations"
  - "seo-gsc-cannibalization: query+page grouping to detect multi-page query conflicts"
  - "seo-gsc-indexing: inspect_url capped at 20 calls, prioritizes low-impression pages"
  - "seo-gsc-compare: MoM/YoY/custom period comparison with unicode directional indicators"
  - "seo-gsc-brand-vs-nonbrand: requires user brand term confirmation before API call"
  - "seo-gsc-content-decay: 90-day window, dual-metric filter (clicks AND impressions)"
  - "seo-gsc-new-keywords: filters previousClicks=0 with emerging topic cluster detection"
affects:
  - "02-core-live-data remaining plans (Ahrefs sub-skills follow same pattern)"
  - "Phase 3 (advanced commands can build on these GSC sub-skills)"
  - "seo/SKILL.md orchestrator (routes /seo gsc * to these sub-skills)"

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "GSC sub-skill pattern: MCP check via ToolSearch → date calc via Bash → tool call → structured output"
    - "Rate-limit guard: cap inspect_url at 20 calls per run"
    - "Brand terms confirmation: always prompt user before calling analyze_brand_queries"
    - "True decay filter: require BOTH clicks AND impressions to decline (not just clicks)"
    - "CTR display rule: always multiply API decimal by 100 for user-facing display"

key-files:
  created:
    - skills/seo-gsc-overview/SKILL.md
    - skills/seo-gsc-drops/SKILL.md
    - skills/seo-gsc-opportunities/SKILL.md
    - skills/seo-gsc-cannibalization/SKILL.md
    - skills/seo-gsc-indexing/SKILL.md
    - skills/seo-gsc-compare/SKILL.md
    - skills/seo-gsc-brand-vs-nonbrand/SKILL.md
    - skills/seo-gsc-content-decay/SKILL.md
    - skills/seo-gsc-new-keywords/SKILL.md
  modified: []

key-decisions:
  - "inspect_url capped at 20 calls per run in seo-gsc-indexing — avoids rate-limit hangs on large sites"
  - "brand-vs-nonbrand requires explicit user confirmation of brand terms before any API call — prevents incorrect branded/non-brand classification"
  - "content-decay requires both clicks AND impressions to decline — filters out seasonal drops where impressions hold steady"
  - "new-keywords filters previousClicks=0 specifically — captures truly new click-generating keywords, not just position changes"
  - "All 9 sub-skills are self-contained with their own MCP check — consistent with pattern from 02-01"

patterns-established:
  - "GSC sub-skill structure: frontmatter → @-references → MCP check → Inputs → Date Calculation (Bash) → Execution → Output Format"
  - "All GSC date calculations use Bash date -v-Nd for macOS compatibility and account for 3-day GSC data delay"
  - "ToolSearch query '+google-search-console' used consistently across all 9 sub-skills for MCP discovery"
  - "Output format includes structured markdown tables for all skills, with sorted results and truncated URLs at 60 chars"

requirements-completed: [GSC-01, GSC-02, GSC-03, GSC-04, GSC-05, GSC-06, GSC-07, GSC-08, GSC-09]

# Metrics
duration: 5min
completed: 2026-03-02
---

# Phase 02 Plan 02: GSC Sub-Skills Summary

**9 GSC sub-skill SKILL.md files implementing all /seo gsc commands with live Search Console data via query_search_analytics, compare_performance, find_keyword_opportunities, inspect_url, analyze_brand_queries, and get_top_pages**

## Performance

- **Duration:** 5 min
- **Started:** 2026-03-02T07:22:28Z
- **Completed:** 2026-03-02T07:27:32Z
- **Tasks:** 2
- **Files modified:** 9 created

## Accomplishments

- All 9 GSC sub-skill SKILL.md files created and passing YAML validation
- Each sub-skill is self-contained with MCP check, date calculation, execution steps, and structured output
- All 9 reference both `mcp-degradation.md` and `gsc-api-reference.md` via @-references
- Critical safety guards implemented: 20-call rate limit cap for inspect_url, brand term confirmation for analyze_brand_queries
- Content decay uses dual-metric filter (clicks AND impressions) to eliminate false positives from seasonal variation

## Task Commits

Each task was committed atomically:

1. **Task 1: Create GSC sub-skills — overview, drops, opportunities, cannibalization, index-issues** - `b1335bf` (feat)
2. **Task 2: Create GSC sub-skills — compare, brand-vs-nonbrand, content-decay, new-keywords** - `fd30535` (feat)

**Plan metadata:** (docs commit — see below)

## Files Created/Modified

- `skills/seo-gsc-overview/SKILL.md` - 28-day performance dashboard via query_search_analytics (x2) + get_top_pages
- `skills/seo-gsc-drops/SKILL.md` - Ranking drop detection via compare_performance, CRITICAL flag for >50% drops
- `skills/seo-gsc-opportunities/SKILL.md` - find_keyword_opportunities with position-based action recommendations
- `skills/seo-gsc-cannibalization/SKILL.md` - query+page dimension grouping to detect multi-page keyword conflicts
- `skills/seo-gsc-indexing/SKILL.md` - inspect_url capped at 20 calls, prioritizes low-impression pages
- `skills/seo-gsc-compare/SKILL.md` - MoM/YoY/custom period comparison with unicode directional arrows
- `skills/seo-gsc-brand-vs-nonbrand/SKILL.md` - Brand term confirmation prompt before analyze_brand_queries call
- `skills/seo-gsc-content-decay/SKILL.md` - 90-day window with dual-metric decay filter (clicks AND impressions)
- `skills/seo-gsc-new-keywords/SKILL.md` - previousClicks=0 filter with emerging topic cluster detection

## Decisions Made

- **inspect_url capped at 20 calls**: Rate-limited tool — cap prevents hangs on large sites with hundreds of pages
- **brand-vs-nonbrand requires explicit brand term confirmation**: analyze_brand_queries needs accurate brandTerms array; guessing brand terms would produce incorrect branded/non-brand split
- **content-decay dual-metric filter**: Requiring both clicks AND impressions to decline eliminates seasonal variation false positives (seasonal drops often see impressions hold steady while clicks fall)
- **new-keywords uses previousClicks=0**: Specifically targets truly new click-generating keywords rather than keywords that simply changed positions

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

GSC MCP must be registered at user scope for all 9 sub-skills to function. The sub-skills display a clear error template with setup instructions if GSC MCP is not connected. See plan frontmatter `user_setup` for registration details.

## Next Phase Readiness

- All 9 GSC sub-skills complete — /seo gsc command group fully implemented
- Ahrefs sub-skills (next plan 02-03) can follow the same structural pattern established here
- The self-contained MCP check + date calculation + execution + output format pattern is proven across 9 skills

---
*Phase: 02-core-live-data*
*Completed: 2026-03-02*
