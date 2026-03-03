---
phase: 03-cross-mcp-differentiating
plan: 02
subsystem: skills
tags: [brand-radar, report, ahrefs, file-persistence, schema-discovery, write-tool]
dependency_graph:
  requires:
    - skills/seo/references/mcp-degradation.md
    - skills/seo/references/ahrefs-api-reference.md
    - skills/seo/references/gsc-api-reference.md
  provides:
    - skills/seo-brand-radar/SKILL.md
    - skills/seo-report/SKILL.md
  affects:
    - skills/seo/SKILL.md (routing table — brand-radar, report entries already listed as Phase 3)
tech_stack:
  added: []
  patterns:
    - Runtime ToolSearch schema discovery before Brand Radar API calls (unverified schema)
    - Write tool for file-persisted report output (first use in project)
    - Non-fatal GSC degradation in seo-report (continues with Ahrefs-only when GSC absent)
    - Adaptive output tables built from actual API response fields (not hardcoded)
key_files:
  created:
    - skills/seo-brand-radar/SKILL.md
    - skills/seo-report/SKILL.md
  modified: []
decisions:
  - "seo-brand-radar uses runtime ToolSearch schema discovery — Brand Radar API parameter names unverified at authoring time"
  - "seo-report adds Write to allowed-tools — first sub-skill in project with file persistence"
  - "seo-report GSC is optional (non-fatal) — all report types anchor on Ahrefs data, GSC enriches but does not block"
  - "Brand Radar hard-stops with no fabrication if Ahrefs unavailable — no fallback exists for brand monitoring data"
metrics:
  duration: 2min
  completed_date: "2026-03-02"
  tasks_completed: 2
  tasks_total: 2
  files_created: 2
  files_modified: 0
requirements_completed: [CROSS-03, CROSS-05]
---

# Phase 3 Plan 02: Brand Radar and Report Generator Summary

**One-liner:** Brand monitoring via Ahrefs Brand Radar with runtime schema discovery, plus file-persisted multi-type report generator using Write tool.

## What Was Built

### Task 1: seo-brand-radar/SKILL.md

Brand Radar sub-skill for monitoring AI search brand visibility. Key design decisions:

- **Runtime schema discovery (CRITICAL):** Brand Radar API parameter names and response fields were unverified at authoring time (STATE.md blocker). The skill uses ToolSearch with query `brand-radar` as Step 1 to discover the actual parameter name (`target`, `brand`, `query`, etc.) before any API calls. This prevents broken calls from hardcoded assumptions.
- **No fallback, hard stop:** Brand Radar is Ahrefs-exclusive. If Ahrefs MCP is unavailable, the skill stops immediately with a clear error. It never estimates or fabricates brand monitoring data.
- **Adaptive output tables:** Output format explicitly instructs Claude to build tables from actual API response fields, not from statically defined column names.
- **Primary differentiator — AI responses:** Step 4 calls `brand-radar-ai-responses` which shows how the brand appears in ChatGPT, Perplexity, and other AI search responses. This is the unique value of Brand Radar vs traditional monitoring.
- **Graceful per-tool error handling:** If non-primary tools fail (SOV, cited domains), the skill logs SKIPPED and continues. Only the primary `brand-radar-mentions-overview` call triggers a full stop.

### Task 2: seo-report/SKILL.md

Report generation sub-skill with four report types and file persistence. Key design decisions:

- **Write tool (first in project):** This is the first sub-skill to use the Write tool. Reports are saved to disk, not printed to terminal. Terminal output is confirmation only: `Report saved to: {absolute_path}`.
- **Filename convention:** `seo-report-YYYY-MM-DD-domain-type.md` generated via Bash in Step 0.
- **4 report types with distinct data gathering:**
  - `monthly` — Ahrefs overview + keywords + DR history + optional GSC month-over-month
  - `weekly` — Optional GSC drops + opportunities + Ahrefs new referring domains
  - `audit` — Ahrefs overview + backlinks + broken links + anchor analysis + top pages
  - `competitor` — Dual-domain Ahrefs comparison + organic competitors + content gap + anchor analysis
- **AI executive summary:** Before assembling the report, the skill generates a 3-5 sentence analytical narrative (not a raw data dump) identifying the most important finding and suggesting a priority action.
- **GSC is optional (non-fatal):** When `site` is provided but GSC MCP is unavailable, execution continues with Ahrefs-only data. A clear note is added to the report.
- **Monetary conversion:** All Ahrefs cost/value fields are in cents — divide by 100 and format as `$X,XXX` before including in the report.

## Deviations from Plan

None — plan executed exactly as written.

## Success Criteria Verification

- [x] seo-brand-radar/SKILL.md uses runtime schema discovery for unverified Brand Radar API
- [x] seo-brand-radar has no fallback — clear error when Ahrefs unavailable, never fabricates data
- [x] seo-report/SKILL.md saves reports to disk via Write tool (first file-persisted output)
- [x] Report includes AI-generated executive summary narrative
- [x] Report prints absolute file path after saving
- [x] All 4 report types (monthly, weekly, audit, competitor) have defined data gathering steps

## Commits

- `99ed44e` — feat(03-02): create seo-brand-radar/SKILL.md with runtime schema discovery
- `8060131` — feat(03-02): create seo-report/SKILL.md with file persistence and 4 report types

## Self-Check: PASSED

- FOUND: skills/seo-brand-radar/SKILL.md
- FOUND: skills/seo-report/SKILL.md
- FOUND: .planning/phases/03-cross-mcp-differentiating/03-02-SUMMARY.md
- FOUND: commit 99ed44e
- FOUND: commit 8060131
