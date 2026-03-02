---
phase: 02-core-live-data
plan: "03"
subsystem: skills/seo-ahrefs-*
tags:
  - ahrefs
  - backlinks
  - keywords
  - competitor-analysis
  - content-gap
  - link-reclamation
  - anchor-analysis
  - domain-rating
dependency_graph:
  requires:
    - 02-01 (MCP degradation patterns and mcp-degradation.md reference file)
    - skills/seo/references/ahrefs-api-reference.md (verified tool names and monetary convention)
    - skills/seo/references/mcp-degradation.md (MCP check pattern and error templates)
  provides:
    - 10 Ahrefs sub-skill SKILL.md files for /seo ahrefs command group
    - Domain overview (DR, backlinks, keywords, traffic value)
    - Backlink profile analysis
    - Organic keyword rankings
    - Organic competitor discovery
    - Content gap analysis with runtime schema discovery
    - Broken backlink reclamation
    - New and lost link monitoring
    - Anchor text health assessment
    - Domain Rating history and trend
    - Top pages traffic distribution
  affects:
    - skills/seo/SKILL.md (orchestrator routes /seo ahrefs to these sub-skills)
    - Phase 3 planning (Ahrefs API unit costs still TBD — tracked as blocker)
tech_stack:
  added: []
  patterns:
    - Self-contained MCP check (ToolSearch +ahrefs before execution)
    - Cents-to-USD monetary conversion (divide by 100, format $X,XXX)
    - Runtime schema discovery for unverified tool parameters
    - Client-side date filtering fallback for tools without native date params
    - Anchor text health thresholds (branded >40%, exact-match <10%, generic <30%)
    - Traffic concentration risk analysis (>30% single page, >70% top-5)
key_files:
  created:
    - skills/seo-ahrefs-overview/SKILL.md
    - skills/seo-ahrefs-backlinks/SKILL.md
    - skills/seo-ahrefs-keywords/SKILL.md
    - skills/seo-ahrefs-competitors/SKILL.md
    - skills/seo-ahrefs-content-gap/SKILL.md
    - skills/seo-ahrefs-broken-links/SKILL.md
    - skills/seo-ahrefs-new-links/SKILL.md
    - skills/seo-ahrefs-anchor-analysis/SKILL.md
    - skills/seo-ahrefs-dr-history/SKILL.md
    - skills/seo-ahrefs-top-pages/SKILL.md
  modified: []
decisions:
  - "content-gap uses dual-approach: runtime ToolSearch schema discovery for keywords-explorer-matching-terms first, cross-reference fallback via site-explorer-organic-keywords if filter param absent"
  - "new-links uses client-side date filtering (last 30 days) since tool may lack native date filter param"
  - "anchor-analysis health thresholds set: branded >40%=healthy, exact-match >10%=over-optimized risk, generic >30%=low-quality signal"
  - "top-pages concentration risk thresholds: >30% single page or >70% top-5 pages triggers warning"
metrics:
  duration: "5min"
  completed_date: "2026-03-02"
  tasks_completed: 2
  files_created: 10
  files_modified: 0
---

# Phase 2 Plan 03: Ahrefs Sub-Skills Summary

All 10 Ahrefs sub-skill SKILL.md files built, providing domain authority, backlink, keyword, and competitor data from Ahrefs MCP via the `/seo ahrefs` command group.

## Tasks Completed

| # | Task | Commit | Files |
|---|------|--------|-------|
| 1 | Create Ahrefs sub-skills: overview, backlinks, keywords, competitors, content-gap | 55e5dc1 | 5 new SKILL.md files |
| 2 | Create Ahrefs sub-skills: broken-links, new-links, anchor-analysis, dr-history, top-pages | ebb2430 | 5 new SKILL.md files |

## What Was Built

Ten self-contained sub-skill files for the `/seo ahrefs` command group, each following the pattern established in Phase 2 Plan 1 (seo-markdown-audit as template):

1. **seo-ahrefs-overview** — Combines `site-explorer-metrics` and `site-explorer-domain-rating` to return Domain Rating (0–100), backlinks, referring domains, organic keywords, monthly traffic, and traffic value (cents → USD conversion)

2. **seo-ahrefs-backlinks** — Calls `site-explorer-all-backlinks`, sorts by source DR descending, with dofollow/nofollow ratio summary

3. **seo-ahrefs-keywords** — Calls `site-explorer-organic-keywords`, sorted by traffic descending, CPC in cents → USD, with top-3 keyword cluster identification

4. **seo-ahrefs-competitors** — Calls `site-explorer-organic-competitors`, sorted by common keywords, with unique strength analysis for top 3 competitors

5. **seo-ahrefs-content-gap** — Dual-approach: runtime ToolSearch schema inspection of `keywords-explorer-matching-terms` first (Approach A), falls back to cross-reference via `site-explorer-organic-keywords` for each competitor (Approach B). Accepts optional `competitors` param; auto-detects via `site-explorer-organic-competitors` if not provided

6. **seo-ahrefs-broken-links** — Calls `site-explorer-broken-backlinks`, sorted by source DR, with per-link reclamation recommendations (redirect vs. outreach)

7. **seo-ahrefs-new-links** — Calls `site-explorer-referring-domains`, applies client-side 30-day date filter (last_seen >= today - 30 days), shows gained and lost domains with net change

8. **seo-ahrefs-anchor-analysis** — Calls `site-explorer-anchors`, calculates % of total, applies three-signal health assessment (branded >40%, exact-match <10%, generic <30%)

9. **seo-ahrefs-dr-history** — Calls `site-explorer-domain-rating-history`, sorted newest first, with trend analysis and significant change flagging (>5 DR points in a month)

10. **seo-ahrefs-top-pages** — Calls `site-explorer-top-pages`, sorted by traffic, with concentration risk analysis (>30% single page, >70% top-5)

## Verification Results

All 10 files passed all checks:

| Check | Result |
|-------|--------|
| Files exist (`ls skills/seo-ahrefs-*/SKILL.md \| wc -l`) | 10/10 |
| YAML validation (validate-yaml.py) | 10/10 PASS |
| References mcp-degradation.md | 10/10 |
| References ahrefs-api-reference.md | 10/10 |
| Monetary convention documented | 4/4 (overview, keywords, content-gap, broken-links) |
| content-gap has ToolSearch schema discovery | Yes — dual approach with runtime inspection |

## Deviations from Plan

None — plan executed exactly as written.

## Self-Check

Checking created files exist:

- `skills/seo-ahrefs-overview/SKILL.md` — created
- `skills/seo-ahrefs-backlinks/SKILL.md` — created
- `skills/seo-ahrefs-keywords/SKILL.md` — created
- `skills/seo-ahrefs-competitors/SKILL.md` — created
- `skills/seo-ahrefs-content-gap/SKILL.md` — created
- `skills/seo-ahrefs-broken-links/SKILL.md` — created
- `skills/seo-ahrefs-new-links/SKILL.md` — created
- `skills/seo-ahrefs-anchor-analysis/SKILL.md` — created
- `skills/seo-ahrefs-dr-history/SKILL.md` — created
- `skills/seo-ahrefs-top-pages/SKILL.md` — created

Checking commits exist:
- `55e5dc1` — Task 1 (overview, backlinks, keywords, competitors, content-gap)
- `ebb2430` — Task 2 (broken-links, new-links, anchor-analysis, dr-history, top-pages)

## Self-Check: PASSED
