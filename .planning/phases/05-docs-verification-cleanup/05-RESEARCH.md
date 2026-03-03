# Phase 5: Documentation & Verification Cleanup - Research

**Researched:** 2026-03-03
**Domain:** Documentation process / GSD verification artifacts / YAML frontmatter
**Confidence:** HIGH

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| GSC-01 | `/seo gsc overview <site>` — Dashboard showing clicks, impressions, CTR, average position | 9 GSC sub-skills exist and are deployed; need 02-VERIFICATION.md + REQUIREMENTS.md checkbox |
| GSC-02 | `/seo gsc drops <site>` — Pages/keywords that lost traffic (28-day comparison) | Same as GSC-01 — verification gap only |
| GSC-03 | `/seo gsc opportunities <site>` — High impressions + low CTR keywords | Same as GSC-01 — verification gap only |
| GSC-04 | `/seo gsc cannibalization <site>` — Multiple pages ranking for same keyword | Same as GSC-01 — verification gap only |
| GSC-05 | `/seo gsc index-issues <site>` — Pages not indexed with reasons | Same as GSC-01 — verification gap only |
| GSC-06 | `/seo gsc compare <site>` — Period-over-period comparison | Same as GSC-01 — verification gap only |
| GSC-07 | `/seo gsc brand-vs-nonbrand <site>` — Brand traffic split analysis | Same as GSC-01 — verification gap only |
| GSC-08 | `/seo gsc content-decay <site>` — Pages losing rankings over 90 days | Same as GSC-01 — verification gap only |
| GSC-09 | `/seo gsc new-keywords <site>` — Keywords you started ranking for recently | Same as GSC-01 — verification gap only |
| AHRF-01 | `/seo ahrefs overview <domain>` — DR, backlinks, organic keywords, traffic | 10 Ahrefs sub-skills exist; need 02-VERIFICATION.md + REQUIREMENTS.md checkbox |
| AHRF-02 | `/seo ahrefs backlinks <domain>` — Top backlinks with DR, anchor text | Same as AHRF-01 — verification gap only |
| AHRF-03 | `/seo ahrefs keywords <domain>` — Top organic keywords | Same as AHRF-01 — verification gap only |
| AHRF-04 | `/seo ahrefs competitors <domain>` — Organic competitors | Same as AHRF-01 — verification gap only |
| AHRF-05 | `/seo ahrefs content-gap <domain>` — Keywords competitors rank for | Same as AHRF-01 — verification gap only |
| AHRF-06 | `/seo ahrefs broken-links <domain>` — Broken backlinks for link reclamation | Same as AHRF-01 — verification gap only |
| AHRF-07 | `/seo ahrefs new-links <domain>` — Recently acquired/lost backlinks | Same as AHRF-01 — verification gap only |
| AHRF-08 | `/seo ahrefs anchor-analysis <domain>` — Anchor text distribution | Same as AHRF-01 — verification gap only |
| AHRF-09 | `/seo ahrefs dr-history <domain>` — Domain rating trend | Same as AHRF-01 — verification gap only |
| AHRF-10 | `/seo ahrefs top-pages <domain>` — Best performing pages by traffic | Same as AHRF-01 — verification gap only |
| LOCAL-01 | `/seo markdown-audit <path>` — Audit markdown files for SEO | Exists and deployed; need 02-VERIFICATION.md + REQUIREMENTS.md checkbox |
| CROSS-01 | `/seo serp <keyword>` — Live SERP analysis | Passed in 03-VERIFICATION.md; need SUMMARY frontmatter update for 03-01 |
| CROSS-02 | `/seo content-brief <keyword>` — AI content brief from SERP | Passed in 03-VERIFICATION.md; need SUMMARY frontmatter update for 03-01 |
| CROSS-03 | `/seo brand-radar <brand>` — Ahrefs Brand Radar monitoring | Passed in 03-VERIFICATION.md; need SUMMARY frontmatter update for 03-02 |
| CROSS-05 | `/seo report <type> <domain>` — Automated SEO report generation | Passed in 03-VERIFICATION.md; need SUMMARY frontmatter update for 03-02 |
| ORIG-01 | `/seo audit <url>` — Full website audit with Ahrefs/GSC overlays | Passed in 04-VERIFICATION.md; need SUMMARY frontmatter update for 04-01 |
| ORIG-02 | `/seo page <url>` — Deep single-page analysis with overlays | Passed in 04-VERIFICATION.md; need SUMMARY frontmatter update for 04-01 |
| ORIG-03 | `/seo technical <url>` — Technical SEO with GSC/Ahrefs overlays | Passed in 04-VERIFICATION.md; need SUMMARY frontmatter update for 04-01 |
| ORIG-04 | `/seo content <url>` — E-E-A-T analysis with Ahrefs/GSC overlays | Passed in 04-VERIFICATION.md; need SUMMARY frontmatter update for 04-01 |
</phase_requirements>

---

## Summary

Phase 5 is a pure documentation cleanup phase — all 48 requirements are fully implemented and deployed. The implementation is complete across all 4 prior phases. The gaps are exclusively documentation/process artifacts: one missing VERIFICATION.md for Phase 2, several SUMMARY frontmatter fields left empty, and two minor tech debt items in skill files.

The audit found two categories of gaps: (1) 20 requirements in Phase 2 were never formally verified because no `02-VERIFICATION.md` was created when Phase 2 completed — the implementation is solid but the verification artifact is absent; (2) 8 requirements across Phases 3 and 4 passed their respective VERIFICATION.md checks but were not recorded in the `requirements_completed` frontmatter field of their corresponding SUMMARY.md files. Both gaps are purely documentary — no implementation work is needed.

Three tech debt items also need resolution: `seo-internal-links/SKILL.md` references ToolSearch in its body (line 82) but ToolSearch is not listed in the `allowed-tools` frontmatter, `REQUIREMENTS.md` has 28 requirements still marked `[ ]` (should be `[x]` since they are all implemented and Phase 5 closes the verification), and `seo/SKILL.md` already shows "42 sub-skills" everywhere — the "27 sub-skills" item from the audit is already resolved and does NOT need action.

**Primary recommendation:** Create `02-VERIFICATION.md` for Phase 2 by running the gsd-verifier against the 20 Phase 2 skill files, then do targeted YAML frontmatter edits on 4 SUMMARY files and 1 SKILL.md file, and finally update REQUIREMENTS.md checkboxes.

---

## Standard Stack

### Core — No External Libraries Needed

This phase works entirely with files already present in the project. No new libraries, no new tools, no new MCP connections.

| Tool | Purpose | Why It Applies |
|------|---------|---------------|
| Read | Read existing SKILL.md, SUMMARY.md files | Verify content before updating frontmatter |
| Write / Edit | Update YAML frontmatter in SUMMARY files, SKILL.md | Targeted single-field edits |
| Bash | Run validate-yaml.py and smoke-test.sh after changes | Confirm edits do not break YAML validity |
| gsd-verifier pattern | Structure for 02-VERIFICATION.md | Phase 1, 3, 4 have verified VERIFICATION.md templates |

### Verification Document Template

All existing VERIFICATION.md files follow this exact structure (HIGH confidence — derived from 01-VERIFICATION.md, 03-VERIFICATION.md, 04-VERIFICATION.md):

```yaml
---
phase: 02-core-live-data
verified: 2026-03-03T00:00:00Z
status: passed
score: 5/5 must-haves verified
gaps: []
human_verification:
  - test: "..."
    expected: "..."
    why_human: "..."
---
```

Body sections in order:
1. `## Goal Achievement` — Observable Truths table
2. `## Required Artifacts` — File existence + content checks table
3. `## Key Link Verification` — Wiring table
4. `## Requirements Coverage` — Per-requirement SATISFIED/PARTIAL table
5. `## Anti-Patterns Found` — Any issues (or "None")
6. `## Deployment Verification` — Deployed skill directories
7. `## Human Verification Required` — Live MCP tests
8. `## Summary`

### SUMMARY Frontmatter Pattern

All SUMMARY.md files use this frontmatter field (HIGH confidence — derived from 02-02-SUMMARY.md and 02-04-SUMMARY.md which correctly populated it):

```yaml
requirements-completed: [GSC-01, GSC-02, ...]
```

Note: The field uses `requirements-completed` (hyphenated) in Phase 2 files and `requirements_completed` (underscored) in Phase 3/4 files. **Use the style already established in each specific SUMMARY file** — do not normalize across phases.

---

## Architecture Patterns

### What Exists vs What Is Missing

```
.planning/phases/
├── 01-foundation/
│   ├── 01-VERIFICATION.md    ← EXISTS, passed 7/7
│   ├── 01-01-SUMMARY.md      ← complete
│   └── 01-02-SUMMARY.md      ← complete
├── 02-core-live-data/
│   ├── 02-RESEARCH.md        ← exists
│   ├── 02-01-SUMMARY.md      ← requirements-completed: [LOCAL-01] ✓
│   ├── 02-02-SUMMARY.md      ← requirements-completed: [GSC-01..09] ✓
│   ├── 02-03-SUMMARY.md      ← requirements-completed: [] ← EMPTY, needs AHRF-01..10
│   ├── 02-04-SUMMARY.md      ← requirements-completed: [GSC-01..09, AHRF-01..10, LOCAL-01] ✓
│   └── 02-VERIFICATION.md    ← MISSING ← must be created
├── 03-cross-mcp-differentiating/
│   ├── 03-VERIFICATION.md    ← EXISTS, passed 5/5
│   ├── 03-01-SUMMARY.md      ← requirements_completed: [] ← needs CROSS-01, CROSS-02
│   ├── 03-02-SUMMARY.md      ← requirements_completed: [] ← needs CROSS-03, CROSS-05
│   └── 03-03-SUMMARY.md      ← complete (CROSS-04 is listed)
├── 04-enhanced-originals-local-analysis/
│   ├── 04-VERIFICATION.md    ← EXISTS, passed 17/17
│   ├── 04-01-SUMMARY.md      ← requirements_completed: [] ← needs ORIG-01..04
│   ├── 04-02-SUMMARY.md      ← complete
│   └── 04-03-SUMMARY.md      ← complete
└── 05-docs-verification-cleanup/
    └── (this phase)
```

### Skill File Tech Debt

```
skills/
├── seo/SKILL.md              ← already says "42 sub-skills" everywhere — NO ACTION NEEDED
└── seo-internal-links/SKILL.md
    ├── allowed-tools: [Read, Bash, Glob, WebFetch]  ← ToolSearch MISSING from this list
    └── line 82: "If Ahrefs available (ToolSearch '+ahrefs'):"  ← body references ToolSearch
```

### Pattern 1: Creating 02-VERIFICATION.md

**What:** Write a new VERIFICATION.md for Phase 2 following the exact same structure as `01-VERIFICATION.md`, `03-VERIFICATION.md`, and `04-VERIFICATION.md`. All evidence comes from static file inspection (skill files exist, line counts, grep for key patterns).

**Key content for Phase 2 verification:**

Phase 2 goal was: "Users can query real GSC performance data and live Ahrefs data through 19 commands, and can audit markdown files locally."

Observable truths to verify (from 02-02-PLAN.md and 02-03-PLAN.md `must_haves`):
1. All 9 GSC sub-skill SKILL.md files exist and are substantive
2. All 10 Ahrefs sub-skill SKILL.md files exist and are substantive
3. `seo-markdown-audit/SKILL.md` exists (LOCAL-01)
4. All 20 reference `mcp-degradation.md` (self-contained MCP check pattern)
5. Ahrefs monetary convention is documented in each relevant sub-skill

Human verification items (live MCP session required — cannot be statically verified):
- Run `/seo gsc overview <site>` with GSC MCP connected
- Run `/seo ahrefs overview <domain>` with Ahrefs MCP connected

**Pattern:**
```markdown
---
phase: 02-core-live-data
verified: 2026-03-03T00:00:00Z
status: passed
score: 5/5 must-haves verified
gaps: []
human_verification:
  - test: "Run /seo gsc overview sc-domain:example.com with GSC MCP connected"
    expected: "Returns clicks, impressions, CTR, average position from live GSC data for last 28 days"
    why_human: "Cannot verify live GSC API response without an active MCP session"
  - test: "Run /seo ahrefs overview example.com with Ahrefs MCP connected"
    expected: "Returns DR (0-100), backlink count, referring domains, organic keywords, traffic value in USD (not cents)"
    why_human: "Cannot verify live Ahrefs API response without an active MCP session"
---
```

### Pattern 2: SUMMARY Frontmatter Update

**What:** Edit the `requirements-completed` (Phase 2) or `requirements_completed` (Phase 3/4) YAML field in the frontmatter of 4 SUMMARY files.

**Exact edits required:**

| File | Current Value | Correct Value |
|------|--------------|---------------|
| `02-03-SUMMARY.md` | `requirements-completed: []` | `requirements-completed: [AHRF-01, AHRF-02, AHRF-03, AHRF-04, AHRF-05, AHRF-06, AHRF-07, AHRF-08, AHRF-09, AHRF-10]` |
| `03-01-SUMMARY.md` | No field present | Add `requirements_completed: [CROSS-01, CROSS-02]` |
| `03-02-SUMMARY.md` | No field present | Add `requirements_completed: [CROSS-03, CROSS-05]` |
| `04-01-SUMMARY.md` | No field present (empty `[]`) | Add/update `requirements_completed: [ORIG-01, ORIG-02, ORIG-03, ORIG-04]` |

**Important:** Read each file first to check the exact current field name (hyphen vs underscore) before editing.

### Pattern 3: seo-internal-links ToolSearch Fix

**What:** Add `ToolSearch` to the `allowed-tools` list in `skills/seo-internal-links/SKILL.md` frontmatter.

**Current frontmatter:**
```yaml
allowed-tools:
  - Read
  - Bash
  - Glob
  - WebFetch
```

**Required frontmatter:**
```yaml
allowed-tools:
  - Read
  - Bash
  - Glob
  - WebFetch
  - ToolSearch
```

**Why:** The skill body at line 82 says `"If Ahrefs available (ToolSearch '+ahrefs'):"` — Claude Code needs ToolSearch in allowed-tools to be able to execute this step. Without it, the Ahrefs enrichment path is silently skipped or errors.

### Pattern 4: REQUIREMENTS.md Checkbox Update

**What:** Change all 28 `[ ]` entries to `[x]` in REQUIREMENTS.md.

**Scope:** The 28 requirements confirmed implemented across Phases 2, 3, and 4 need their checkboxes flipped. These are ORIG-01..04, GSC-01..09, AHRF-01..10, LOCAL-01, CROSS-01, CROSS-02, CROSS-03, CROSS-05.

**Note on REQUIREMENTS.md last-updated comment:** The file footer says "Last updated: 2026-03-03 — 28 partial requirements reset to Pending for Phase 5 gap closure". This note should be updated to reflect Phase 5 completion.

### Anti-Patterns to Avoid

- **Do not re-implement anything.** Phase 5 is documentation only. If a check reveals an implementation gap, treat it as a blocker and surface it — do not add new skill code.
- **Do not normalize frontmatter field names across phases.** Phase 2 uses `requirements-completed` (hyphen), Phases 3/4 use `requirements_completed` (underscore). Preserve the convention already in each file.
- **Do not mark "27 sub-skills" as a tech debt action item.** `seo/SKILL.md` already says "42 sub-skills" in all 4 locations — the audit identified this as stale but it was resolved during Phase 4. No action needed.
- **Do not confuse tech debt item "ROADMAP.md Phase 4 checkboxes"** — the ROADMAP.md already shows all Phase 4 plans as `[x]`. This tech debt item was also already resolved. No action needed.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Verifying 20 Phase 2 skill files | Custom verification scripts | Direct file inspection: ls, wc -l, grep | VERIFICATION.md is a prose document, not an automated test runner |
| Counting requirements | Manual counting | Check existing SUMMARY files for `requirements-completed` fields | The data is already recorded in 02-02-SUMMARY.md, 02-04-SUMMARY.md |
| Writing the 02-VERIFICATION.md structure | Novel format | Copy 03-VERIFICATION.md structure exactly | Three matching VERIFICATION.md files exist as templates |

**Key insight:** This is an editorial task, not an engineering task. The implementation already exists and passed informal review. The work is creating the formal verification artifact.

---

## Common Pitfalls

### Pitfall 1: Treating the Audit's "27 sub-skills" Finding as Still Open

**What goes wrong:** Planner creates a task to update "27 sub-skills" to "42" in seo/SKILL.md.
**Why it happens:** The v1.0-MILESTONE-AUDIT.md listed this as tech debt, but the file was fixed during Phase 4. Grep confirms `seo/SKILL.md` already says "42 sub-skills" in all locations (lines 4, 5, 26, 27).
**How to avoid:** Run `grep "27 sub-skills" skills/seo/SKILL.md` to confirm zero matches before treating as open.
**Warning signs:** Any plan task that says "update sub-skills count from 27 to 42."

### Pitfall 2: Mixing Up SUMMARY Field Name Conventions

**What goes wrong:** Editing `03-01-SUMMARY.md` to use `requirements-completed` (hyphen) when that file uses `requirements_completed` (underscore).
**Why it happens:** Phase 2 SUMMARY files use hyphen convention, Phase 3/4 files use underscore. Both conventions are present in the project.
**How to avoid:** Read the existing frontmatter of each SUMMARY file before editing to confirm which convention it uses.
**Warning signs:** YAML validation errors after editing a SUMMARY file.

### Pitfall 3: Creating a 02-VERIFICATION.md That Is Too Thin

**What goes wrong:** Creating a minimal VERIFICATION.md that only checks existence of files, not content.
**Why it happens:** Time pressure; mistaking "documentation gap" for "just add a stub."
**How to avoid:** Follow the full 03-VERIFICATION.md structure: Observable Truths (substantive checks with grep evidence), Required Artifacts (file existence + line counts), Key Link Verification (wiring checks), Requirements Coverage (per-REQ-ID evidence), Human Verification items (live MCP calls that can't be static-verified).
**Warning signs:** A 02-VERIFICATION.md shorter than 80 lines or one that lacks the `## Requirements Coverage` section.

### Pitfall 4: Forgetting to Update REQUIREMENTS.md Checkboxes

**What goes wrong:** 02-VERIFICATION.md is created and SUMMARY files are updated, but REQUIREMENTS.md still shows `[ ]` for all 28 requirements.
**Why it happens:** The audit focused on VERIFICATION.md and SUMMARY.md gaps; REQUIREMENTS.md is a separate file.
**How to avoid:** Treat REQUIREMENTS.md checkbox updates as a required task alongside the other artifacts.
**Warning signs:** `/gsd:audit-milestone` still shows gaps after other fixes are applied.

### Pitfall 5: Adding ToolSearch to the Wrong File

**What goes wrong:** Adding ToolSearch to `seo-markdown-audit/SKILL.md` instead of `seo-internal-links/SKILL.md`.
**Why it happens:** Multiple skill files exist; easy to confuse.
**How to avoid:** The file is `skills/seo-internal-links/SKILL.md`. The body reference is at line 82: `"If Ahrefs available (ToolSearch '+ahrefs'):"`.
**Warning signs:** After the fix, running `grep "ToolSearch" skills/seo-internal-links/SKILL.md` should show 2 occurrences (frontmatter + body).

---

## Code Examples

### Checking the Current State Before Editing

```bash
# Confirm "27 sub-skills" is NOT present (audit already resolved)
grep "27 sub-skills" "/path/to/skills/seo/SKILL.md"
# Expected: no output (zero matches)

# Confirm seo-internal-links ToolSearch gap
grep -n "ToolSearch" "/path/to/skills/seo-internal-links/SKILL.md"
# Expected: line 82 only (body) — NOT in frontmatter allowed-tools

# Confirm 02-VERIFICATION.md is missing
ls /path/to/.planning/phases/02-core-live-data/02-VERIFICATION.md
# Expected: "No such file"

# Confirm 02-03-SUMMARY.md has empty requirements-completed
grep "requirements-completed" "/path/to/.planning/phases/02-core-live-data/02-03-SUMMARY.md"
# Expected: requirements-completed: []
```

### Verifying Phase 2 Skill Files (for 02-VERIFICATION.md)

```bash
# Count all 9 GSC sub-skill files
ls skills/seo-gsc-*/SKILL.md | wc -l
# Expected: 9

# Count all 10 Ahrefs sub-skill files
ls skills/seo-ahrefs-*/SKILL.md | wc -l
# Expected: 10

# Check mcp-degradation reference in all Phase 2 sub-skills
grep -l "mcp-degradation" skills/seo-gsc-*/SKILL.md skills/seo-ahrefs-*/SKILL.md skills/seo-markdown-audit/SKILL.md | wc -l
# Expected: 20

# Check monetary convention in Ahrefs skills that use cost/traffic fields
grep -l "100\|cents\|USD" skills/seo-ahrefs-{overview,keywords,backlinks,content-gap,broken-links}/SKILL.md | wc -l
# Expected: 5 (or at least the overview + keywords files)

# Verify markdown-audit exists (LOCAL-01)
wc -l skills/seo-markdown-audit/SKILL.md
# Expected: 126 lines

# Verify all deployed to ~/.claude/skills/
ls ~/.claude/skills/ | grep "seo-gsc\|seo-ahrefs\|seo-markdown" | wc -l
# Expected: 20
```

### YAML Validation After Edits

```bash
# Run after any frontmatter change
cd /path/to/project
python skills/scripts/validate-yaml.py skills/seo-internal-links/SKILL.md
# Expected: PASS

# Or run full suite
python skills/scripts/validate-yaml.py skills/seo-*/SKILL.md skills/seo/SKILL.md
# Expected: all PASS
```

---

## State of the Art

| Audit Finding | Current Reality | Action |
|---------------|----------------|--------|
| "seo/SKILL.md says '27 sub-skills' in 4 places" | Already fixed — grep shows "42 sub-skills" everywhere | NO ACTION |
| "ROADMAP.md Phase 4 checkboxes unchecked" | Already fixed — all Phase 4 plans show `[x]` | NO ACTION |
| "02-VERIFICATION.md missing" | Still missing — confirmed | CREATE |
| "02-03-SUMMARY.md has empty requirements-completed" | Still empty — confirmed | UPDATE |
| "03-01-SUMMARY.md and 03-02-SUMMARY.md empty requirements_completed" | Still empty — confirmed | UPDATE |
| "04-01-SUMMARY.md empty requirements_completed" | Still empty — confirmed | UPDATE |
| "seo-internal-links ToolSearch not in allowed-tools" | Still missing — confirmed | UPDATE |
| "REQUIREMENTS.md has 28 unchecked [ ]" | Still unchecked — confirmed | UPDATE |

**Effective action count: 4 files to update (SUMMARY frontmatter), 1 file to create (VERIFICATION.md), 1 field to add (ToolSearch), 28 checkboxes to flip (REQUIREMENTS.md)**

---

## Open Questions

1. **02-VERIFICATION.md human verification items — which live tests to include?**
   - What we know: Phases 1, 3, 4 each include 3-5 human verification items requiring live MCP sessions
   - What's unclear: Phase 2 was built in March 2026 — has any human actually run these live? The 02-04-SUMMARY.md says "Human verification of live MCP commands — approved" but this was done inline without a VERIFICATION.md
   - Recommendation: Include standard human verification items for GSC and Ahrefs live data (at least 2 items). Reference the fact that human approval was already obtained in Phase 2 execution (02-04-SUMMARY.md) as evidence.

2. **Should REQUIREMENTS.md traceability table be updated too?**
   - What we know: The traceability table at the bottom of REQUIREMENTS.md still shows "Phase 2 → Phase 5: Pending" for the 28 requirements
   - What's unclear: Whether the milestone auditor reads the traceability table or just the `[x]`/`[ ]` checkboxes
   - Recommendation: Update the traceability table from "Pending" to "Complete" for all 28 requirements, alongside updating the checkboxes. This ensures the audit tool sees consistent data.

3. **Is there a 05-VERIFICATION.md expected for Phase 5 itself?**
   - What we know: All prior phases 1, 3, 4 have a VERIFICATION.md; Phase 2 is the exception being fixed
   - What's unclear: Whether the planner should include a verification step for Phase 5 itself or if this is a "no-verify" documentation phase
   - Recommendation: A minimal 05-VERIFICATION.md should be created to verify that the 5 success criteria are met (02-VERIFICATION.md exists, SUMMARY frontmatter fields populated, 48/48 requirements satisfied, ToolSearch in allowed-tools, no "27 sub-skills" anywhere). This keeps the process consistent.

---

## Execution Order for the Single Plan

Phase 5 warrants a single plan (`05-01-PLAN.md`) with tasks in this order:

**Wave 1 (documentation fixes — no dependencies between tasks):**
1. Create `02-VERIFICATION.md` — verify all 20 Phase 2 skill files, document human verification items
2. Update `02-03-SUMMARY.md` frontmatter — add AHRF-01..10 to requirements-completed
3. Update `03-01-SUMMARY.md`, `03-02-SUMMARY.md` frontmatter — add CROSS-01/02 and CROSS-03/05
4. Update `04-01-SUMMARY.md` frontmatter — add ORIG-01..04

**Wave 2 (depends on Wave 1 completing the verification artifact):**
5. Add ToolSearch to `seo-internal-links/SKILL.md` allowed-tools
6. Update `REQUIREMENTS.md` — flip 28 `[ ]` to `[x]`, update traceability table, update last-updated comment
7. Create `05-VERIFICATION.md` — verify all 5 success criteria are met

---

## Sources

### Primary (HIGH confidence)
- Direct file inspection of `.planning/phases/` directories — confirmed current state of all SUMMARY, PLAN, and VERIFICATION files
- Direct file inspection of `skills/seo-internal-links/SKILL.md` — confirmed ToolSearch missing from allowed-tools
- Direct grep of `skills/seo/SKILL.md` — confirmed "42 sub-skills" is already correct, no "27" in skill count context
- `.planning/v1.0-MILESTONE-AUDIT.md` — primary source for gap inventory

### Secondary (MEDIUM confidence)
- Cross-reference of `03-VERIFICATION.md` and `04-VERIFICATION.md` as templates — structure confirmed, content patterns derived
- `02-02-SUMMARY.md` and `02-04-SUMMARY.md` — confirmed correct `requirements-completed` field population as model

### Tertiary (LOW confidence)
- None — all findings verified directly from file system

---

## Metadata

**Confidence breakdown:**
- Gap inventory: HIGH — directly verified by reading all SUMMARY files and checking file system
- VERIFICATION.md structure: HIGH — derived from 3 existing examples (01, 03, 04)
- Frontmatter field names: HIGH — read directly from affected files
- Audit findings still open vs already closed: HIGH — grep verification done for "27 sub-skills" and ROADMAP checkboxes

**Research date:** 2026-03-03
**Valid until:** This research is based on the current state of the repository at 2026-03-03. Valid indefinitely since it describes a fixed set of documentation gaps with no external dependencies.
