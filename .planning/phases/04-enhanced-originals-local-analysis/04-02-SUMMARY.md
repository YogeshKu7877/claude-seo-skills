---
phase: 04-enhanced-originals-local-analysis
plan: 02
subsystem: skills
tags: [seo-skills, mcp-overlay, ahrefs, gsc, geo, schema, sitemap, markdown-audit, hreflang, programmatic]

# Dependency graph
requires:
  - phase: 04-enhanced-originals-local-analysis
    provides: Phase 04-01 created mcp-degradation.md and reference files used by overlay pattern

provides:
  - "seo-schema with Ahrefs traffic prioritization MCP overlay and ToolSearch allowed-tool"
  - "seo-sitemap with GSC indexing cross-reference MCP overlay and ToolSearch allowed-tool"
  - "seo-geo with Ahrefs Brand Radar AI visibility MCP overlay and ToolSearch allowed-tool"
  - "seo-images frontmatter refreshed with WebP, AVIF, lazy loading, CLS, Core Web Vitals trigger words"
  - "seo-plan frontmatter refreshed with keyword strategy, content calendar, SEO budget trigger words"
  - "seo-programmatic frontmatter refreshed with pSEO, template engine, index bloat trigger words"
  - "seo-competitor-pages frontmatter refreshed with versus page, comparison matrix trigger words"
  - "seo-hreflang frontmatter refreshed with language targeting, locale, multilingual SEO trigger words"
  - "seo-markdown-audit enhanced with check 11 Markdown Syntax Quality (5 rules), X/11 score, @-reference to markdown-guide.md"

affects:
  - 04-enhanced-originals-local-analysis

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Selective MCP overlay: appended Live Data Insights section + Data Sources footer — never modifies existing static analysis"
    - "ToolSearch-before-data: all MCP overlays check availability via ToolSearch before attempting API calls"
    - "Conditional overlay sections: always prefixed with 'If [MCP] available:' for graceful degradation"
    - "Frontmatter trigger word expansion: adds specific use-case terms to improve slash-command discoverability"

key-files:
  created: []
  modified:
    - skills/seo-schema/SKILL.md
    - skills/seo-sitemap/SKILL.md
    - skills/seo-geo/SKILL.md
    - skills/seo-images/SKILL.md
    - skills/seo-plan/SKILL.md
    - skills/seo-programmatic/SKILL.md
    - skills/seo-competitor-pages/SKILL.md
    - skills/seo-hreflang/SKILL.md
    - skills/seo-markdown-audit/SKILL.md

key-decisions:
  - "[04-02]: seo-schema gets Ahrefs overlay only (traffic prioritization) — no GSC overlay needed for schema analysis"
  - "[04-02]: seo-sitemap gets GSC overlay only (indexing cross-reference) — no Ahrefs overlay needed for sitemap analysis"
  - "[04-02]: seo-geo gets Ahrefs Brand Radar overlay specifically — separate ToolSearch query '+ahrefs brand-radar' before falling back to broader '+ahrefs'"
  - "[04-02]: plan, programmatic, hreflang, competitor-pages, images get frontmatter refresh only — no MCP overlays per CONTEXT.md selective overlay decision"
  - "[04-02]: seo-markdown-audit check 11 Markdown Syntax Quality adds 5 rules from Markdown Guide: space after hash, consistent list delimiters, blank lines around headings, blank lines around code blocks, ordered list starting at 1"

patterns-established:
  - "Data Sources footer pattern: every MCP-enhanced skill ends with a ## Data Sources table showing source, status (always/if connected), and data provided"
  - "Brand Radar ToolSearch: use '+ahrefs brand-radar' as the specific query, not just '+ahrefs' — Brand Radar may require separate tier"

requirements-completed:
  - ORIG-05
  - ORIG-06
  - ORIG-07
  - ORIG-08
  - ORIG-09
  - ORIG-10
  - ORIG-11
  - ORIG-12

# Metrics
duration: 3min
completed: 2026-03-02
---

# Phase 4 Plan 02: Enhanced Originals & Selective MCP Overlays Summary

**8 original skills enhanced: schema/sitemap/geo get live MCP data overlays (Ahrefs traffic, GSC indexing, Brand Radar); images/plan/programmatic/competitor-pages/hreflang get trigger word expansion; markdown-audit gains Markdown Syntax Quality check (11 categories total)**

## Performance

- **Duration:** 3 min
- **Started:** 2026-03-02T11:49:55Z
- **Completed:** 2026-03-02T11:52:54Z
- **Tasks:** 2
- **Files modified:** 9

## Accomplishments

- Added `## Live Data Insights (MCP Overlay)` and `## Data Sources` sections to seo-schema (Ahrefs traffic prioritization), seo-sitemap (GSC indexing cross-reference), and seo-geo (Ahrefs Brand Radar AI visibility)
- Refreshed frontmatter descriptions for 5 non-overlay skills (images, plan, programmatic, competitor-pages, hreflang) with expanded trigger words for better slash-command discoverability
- Enhanced seo-markdown-audit with a new check 11 "Markdown Syntax Quality" covering 5 rules from the Markdown Guide, updated score denominator to X/11, added Markdown Syntax table row, and @-reference to markdown-guide.md

## Task Commits

Each task was committed atomically:

1. **Task 1: Add MCP overlays to schema, sitemap, and geo skills** - `27ae405` (feat)
2. **Task 2: Refresh frontmatter for non-overlay skills and enhance markdown-audit** - `eaba554` (feat)

**Plan metadata:** _(docs commit follows)_

## Files Created/Modified

- `skills/seo-schema/SKILL.md` — Added allowed-tools with ToolSearch, updated description to mention Ahrefs traffic prioritization, appended Live Data Insights with Ahrefs overlay, Data Sources footer
- `skills/seo-sitemap/SKILL.md` — Added allowed-tools with ToolSearch, updated description to mention GSC indexing cross-reference, appended Live Data Insights with GSC overlay, Data Sources footer
- `skills/seo-geo/SKILL.md` — Added allowed-tools with ToolSearch, updated description to mention Brand Radar enrichment, appended Live Data Insights with Brand Radar overlay, Data Sources footer
- `skills/seo-images/SKILL.md` — Frontmatter description refreshed with WebP, AVIF, lazy loading, CLS, responsive images, Core Web Vitals images trigger words
- `skills/seo-plan/SKILL.md` — Frontmatter description refreshed with keyword strategy, content calendar, site architecture plan, SEO budget, SEO timeline trigger words
- `skills/seo-programmatic/SKILL.md` — Frontmatter description refreshed with pSEO, template engine, data-driven pages, index bloat, thin content at scale trigger words
- `skills/seo-competitor-pages/SKILL.md` — Frontmatter description refreshed with alternatives page, versus page, comparison matrix, feature comparison trigger words
- `skills/seo-hreflang/SKILL.md` — Frontmatter description refreshed with language targeting, country targeting, x-default, locale, multilingual SEO trigger words
- `skills/seo-markdown-audit/SKILL.md` — Added @-reference to markdown-guide.md, check 11 Markdown Syntax Quality with 5 rules, updated X/11 score, added Markdown Syntax row to output summary table

## Decisions Made

- seo-schema gets Ahrefs overlay only — GSC is not useful for schema analysis (schema is about markup, not search performance)
- seo-sitemap gets GSC overlay only — Ahrefs is not useful for sitemap analysis; GSC indexing status is the most valuable cross-reference
- seo-geo gets Ahrefs Brand Radar specifically via separate ToolSearch query `+ahrefs brand-radar` — Brand Radar is a specific product tier, not all Ahrefs users have it; two-step check (Brand Radar first, broader Ahrefs fallback) is more informative
- plan, programmatic, hreflang, competitor-pages, images get no MCP overlays per CONTEXT.md selective overlay decision — live data does not meaningfully improve these analysis types
- Markdown Syntax Quality check uses Markdown Guide rules (space after hash, consistent list delimiters, blank lines around headings, blank lines around code blocks, ordered list starting at 1) — these are the 5 highest-value syntax rules for document quality

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

- All 8 original skills (ORIG-05 through ORIG-12) are now updated per Phase 4 plan
- Phase 04-01 (reference files) and 04-02 (original skill enhancements) are complete
- Ready for Phase 04-03 (new local analysis commands: log-analysis, ai-content-check, internal-links, migration-check)

---
*Phase: 04-enhanced-originals-local-analysis*
*Completed: 2026-03-02*
