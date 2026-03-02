---
phase: 02-core-live-data
plan: 01
subsystem: seo-skills
tags: [seo, gsc, google-search-console, markdown-audit, routing, skill-files]

# Dependency graph
requires:
  - phase: 01-foundation
    provides: seo/SKILL.md routing table, GSC API reference stub, YAML validation toolchain
provides:
  - Corrected GSC routing table with 9 commands matching REQUIREMENTS.md names
  - Verified GSC MCP tool names in gsc-api-reference.md (zero TBD placeholders)
  - seo-markdown-audit/SKILL.md — self-contained no-MCP sub-skill with 10 check categories
affects:
  - 02-02-PLAN (GSC sub-skills depend on corrected routing table)
  - 02-03-PLAN (Ahrefs sub-skills use same routing pattern)
  - All Phase 2 GSC sub-skill builds

# Tech tracking
tech-stack:
  added: []
  patterns:
    - Sub-skill SKILL.md pattern: frontmatter (name, description, allowed-tools) + Inputs + Execution + Output Format sections
    - Routing table uses alphabetical ordering within command groups
    - Sub-skill directories named with full path (seo-gsc-brand-vs-nonbrand) but internal directory stays unchanged (seo-gsc-indexing) when only user-facing name changes

key-files:
  created:
    - skills/seo-markdown-audit/SKILL.md
  modified:
    - skills/seo/SKILL.md
    - skills/seo/references/gsc-api-reference.md

key-decisions:
  - "gsc-indexing directory name kept as seo-gsc-indexing, only user-facing command renamed to gsc-index-issues — avoids filesystem migration while matching REQUIREMENTS.md"
  - "CTR display rule documented in gsc-api-reference.md: always multiply decimal by 100 for display (API returns 0.0523, show 5.23%)"
  - "seo-markdown-audit established as pattern for all Phase 2 sub-skills: frontmatter + Inputs + Execution + Output Format"

patterns-established:
  - "Phase 2 sub-skill pattern: YAML frontmatter with name/description/allowed-tools, then Inputs, Execution (numbered checks), Output Format sections"
  - "GSC tool discovery at runtime via ToolSearch (prefix varies by MCP registration alias) — never hardcode the full MCP tool name prefix"

requirements-completed: [LOCAL-01]

# Metrics
duration: 3min
completed: 2026-03-02
---

# Phase 2 Plan 01: Routing Fix, Verified GSC Tool Names, and Markdown Audit Sub-Skill Summary

**GSC routing table corrected to 9 REQUIREMENTS.md-aligned commands, gsc-api-reference.md populated with verified tool names from TypeScript source, and seo-markdown-audit/SKILL.md created as the first Phase 2 no-MCP sub-skill.**

## Performance

- **Duration:** 3 min
- **Started:** 2026-03-02T07:16:04Z
- **Completed:** 2026-03-02T07:19:25Z
- **Tasks:** 3
- **Files modified:** 3

## Accomplishments
- Removed gsc-pages, gsc-queries, gsc-sitemaps from all routing sections in seo/SKILL.md; added gsc-brand-vs-nonbrand, gsc-content-decay, gsc-new-keywords; renamed gsc-indexing display to gsc-index-issues
- Replaced all TBD placeholder tool names in gsc-api-reference.md with verified names read from GSC-MCP/src/index.ts source (9 sub-commands mapped)
- Created skills/seo-markdown-audit/SKILL.md with 10 SEO check categories, zero MCP dependency, establishing sub-skill file pattern for all Phase 2 builds

## Task Commits

Each task was committed atomically:

1. **Task 1: Fix routing table discrepancy in seo/SKILL.md** - `0d52bef` (feat)
2. **Task 2: Update gsc-api-reference.md with verified tool names** - `380e0df` (feat)
3. **Task 3: Create seo-markdown-audit sub-skill** - `4c6d61e` (feat)

## Files Created/Modified
- `skills/seo/SKILL.md` — GSC routing updated: 4 sections (Quick Reference, Level 2 routing, Routing Table, Sub-Skills list) all updated consistently
- `skills/seo/references/gsc-api-reference.md` — TBD placeholders replaced with verified tool names; property format marked VERIFIED; CTR display rule added; Additional GSC Tools section added
- `skills/seo-markdown-audit/SKILL.md` — New sub-skill: 10 check categories (H1, meta description, heading hierarchy, keyword placement, content length, readability, links, images, frontmatter, technical)

## Decisions Made
- `gsc-indexing` directory name kept as-is, only user-facing command name changed to `gsc-index-issues` — avoids filesystem churn while aligning with REQUIREMENTS.md
- CTR display rule added to gsc-api-reference.md (multiply decimal by 100) as this affects all 9 GSC sub-commands
- seo-markdown-audit/SKILL.md frontmatter kept concise with `allowed-tools: [Read, Bash, Glob]` — no MCP tools needed

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- Routing table is now aligned with REQUIREMENTS.md — Phase 2 GSC sub-skill builds can proceed using the corrected command names
- gsc-api-reference.md has verified tool names — first GSC sub-skill (likely gsc-overview) can use `query_search_analytics` and `get_top_pages` with confidence
- seo-markdown-audit pattern is established — future sub-skills follow: frontmatter + Inputs + Execution + Output Format
- Remaining blocker: GSC MCP registered alias unknown — sub-skills must use ToolSearch at runtime to discover prefix

## Self-Check: PASSED

- skills/seo/SKILL.md: FOUND
- skills/seo/references/gsc-api-reference.md: FOUND
- skills/seo-markdown-audit/SKILL.md: FOUND
- .planning/phases/02-core-live-data/02-01-SUMMARY.md: FOUND
- Commit 0d52bef: FOUND
- Commit 380e0df: FOUND
- Commit 4c6d61e: FOUND

---
*Phase: 02-core-live-data*
*Completed: 2026-03-02*
