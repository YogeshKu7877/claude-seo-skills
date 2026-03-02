---
phase: 04-enhanced-originals-local-analysis
plan: 01
subsystem: skills/seo-audit, skills/seo-page, skills/seo-technical, skills/seo-content, skills/seo/references
tags: [mcp-overlay, ahrefs, gsc, reference-files, graceful-degradation]
dependency_graph:
  requires: []
  provides:
    - google-seo-guide.md reference for audit category alignment
    - markdown-guide.md reference for markdown-audit rules
    - seo-audit enhanced with Ahrefs DR/backlinks and GSC indexing overlays
    - seo-page enhanced with Ahrefs page authority and GSC search performance overlays
    - seo-technical enhanced with GSC inspect_url indexing status and Ahrefs backlink profile
    - seo-content enhanced with Ahrefs actual keyword rankings and GSC query performance overlays
  affects:
    - skills/seo-audit/SKILL.md
    - skills/seo-page/SKILL.md
    - skills/seo-technical/SKILL.md
    - skills/seo-content/SKILL.md
    - skills/seo/references/google-seo-guide.md
    - skills/seo/references/markdown-guide.md
tech_stack:
  added: []
  patterns:
    - Appended MCP overlay sections — existing static analysis unchanged
    - Conditional MCP data display — "If [MCP] available:" prefix on all overlay sections
    - ToolSearch-based MCP availability check per skill (self-contained pattern)
    - Data Sources footer on all 4 enhanced skills
    - google-seo-guide.md reference loaded in seo-audit Process step 0
key_files:
  created:
    - skills/seo/references/google-seo-guide.md
    - skills/seo/references/markdown-guide.md
  modified:
    - skills/seo-audit/SKILL.md
    - skills/seo-page/SKILL.md
    - skills/seo-technical/SKILL.md
    - skills/seo-content/SKILL.md
decisions:
  - Appended section approach adopted — static output never modified, overlays are additions only
  - All 4 skills follow identical MCP availability check pattern from mcp-degradation.md
  - seo-technical notes "GSC data unavailable" explicitly when GSC MCP is not connected
  - Ahrefs monetary value division reminder (divide by 100) included in each overlay that uses cost/CPC fields
  - google-seo-guide.md reference added to seo-audit Process as step 0 for category-aligned checks
metrics:
  duration: 3min
  completed_date: "2026-03-02"
  tasks_completed: 2
  files_created: 2
  files_modified: 4
---

# Phase 4 Plan 01: Enhanced Originals (audit, page, technical, content) + Reference Files Summary

**One-liner:** Created Google SEO Starter Guide and Markdown Guide reference files, then enhanced the 4 highest-traffic commands (audit, page, technical, content) with conditional Ahrefs and GSC MCP overlay sections following the graceful degradation pattern.

---

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Create Google SEO Starter Guide and Markdown Guide reference files | cd016b9 | skills/seo/references/google-seo-guide.md, skills/seo/references/markdown-guide.md |
| 2 | Enhance seo-audit, seo-page, seo-technical, and seo-content with MCP overlays | 881c59d | skills/seo-audit/SKILL.md, skills/seo-page/SKILL.md, skills/seo-technical/SKILL.md, skills/seo-content/SKILL.md |

---

## What Was Built

### Task 1: Reference Files

**`skills/seo/references/google-seo-guide.md`** (81 lines)
- 5 audit categories aligned to Google's SEO Starter Guide: Discoverability, Content Quality, On-Page Elements, Technical/UX, Links
- 35+ checkable items across categories
- Each item includes the specific Google documentation URL
- Follows same on-demand loading pattern as cwv-thresholds.md and eeat-framework.md

**`skills/seo/references/markdown-guide.md`** (91 lines)
- 7 syntax rules with correct/incorrect code examples
- Covers: heading hash spaces, consistent list delimiters, proper emphasis syntax, blank lines before/after block elements, URL encoding, ordered list numbering, line break handling
- Aligned to https://www.markdownguide.org/basic-syntax/

### Task 2: MCP Overlay Enhancements

All 4 skills received:
1. Updated YAML frontmatter `description` reflecting enhanced capabilities
2. Added `allowed-tools` field including `ToolSearch` (needed for MCP availability checks)
3. `## Live Data Insights (MCP Overlay)` section appended after existing Output section
4. `## Data Sources` footer template appended at end of file

**Skill-specific overlays:**

**seo-audit:**
- Added step 0 in Process: load `seo/references/google-seo-guide.md` for category-aligned checks
- @-reference to `mcp-degradation.md` for MCP availability check pattern
- Ahrefs: `site-explorer-metrics` → Domain Authority Context table (DR, rank, backlinks, referring domains, organic keywords, traffic); annotates health score
- GSC: `get_indexing_status` → Indexing Status section (indexed vs not-indexed counts, top reasons); `get_search_analytics` → Top Performing Pages table (clicks, impressions, CTR, position)

**seo-page:**
- Ahrefs: `site-explorer-metrics` for URL → Page Authority Data table (referring domains, backlinks, organic keywords, traffic)
- GSC: `get_search_analytics` filtered to URL → overall metrics + top 10 keywords table

**seo-technical:**
- GSC: `inspect_url` → Live Indexing Status table (indexed status, crawl date, canonical selection, mobile usability); explicit "GSC data unavailable" note when not connected
- Ahrefs: `site-explorer-backlinks-stats` or `site-explorer-metrics` → Backlink Profile Summary (DR, backlinks, referring domains, dofollow ratio) with crawl-frequency context note

**seo-content:**
- Ahrefs: `site-explorer-organic-keywords` filtered to URL → Actual Keyword Rankings table (top 10: keyword, position, volume, traffic, traffic %)
- GSC: `get_search_analytics` filtered to URL → Search Query Performance (overall metrics + top queries table)

---

## Must-Haves Verified

| Requirement | Status |
|-------------|--------|
| /seo audit includes Ahrefs DR, backlinks, organic keywords | DONE |
| /seo audit includes GSC indexing coverage and top pages | DONE |
| /seo technical includes GSC indexing status with "GSC data unavailable" note | DONE |
| /seo technical includes Ahrefs backlink data | DONE |
| /seo content includes Ahrefs keyword rankings for the page | DONE |
| /seo page includes both Ahrefs and GSC data | DONE |
| All 4 skills have ## Data Sources footer | DONE |
| Static analysis unchanged when MCPs unavailable | DONE — overlays are additions only |
| references/google-seo-guide.md exists with 5 categories | DONE |
| references/markdown-guide.md exists with syntax rules | DONE |

---

## Deviations from Plan

None — plan executed exactly as written.

---

## Self-Check

**Files created:**
- skills/seo/references/google-seo-guide.md — FOUND
- skills/seo/references/markdown-guide.md — FOUND
- skills/seo-audit/SKILL.md (modified) — FOUND with Live Data Insights
- skills/seo-page/SKILL.md (modified) — FOUND with Live Data Insights
- skills/seo-technical/SKILL.md (modified) — FOUND with Live Data Insights
- skills/seo-content/SKILL.md (modified) — FOUND with Live Data Insights

**Commits:**
- cd016b9 — feat(04-01): create reference files
- 881c59d — feat(04-01): enhance 4 skills with MCP overlays

## Self-Check: PASSED
