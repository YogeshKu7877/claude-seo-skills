---
phase: 01-foundation
plan: 01
subsystem: infra
tags: [bash, python, yaml, venv, pip, mcp, install]

# Dependency graph
requires: []
provides:
  - install.sh: single-command deployment of all SEO skills and agents to ~/.claude/
  - YAML frontmatter validation before deployment (validate-yaml.py)
  - Python venv management at ~/.claude/skills/seo/.venv/
  - MCP scope verification (verify-mcp-scope.sh)
  - Source-controlled copy of all 13 skill directories and 6 agent files
affects:
  - 01-02: references shared install mechanism and skills/ source directory
  - All future phases: all new skills added to skills/ and installed via install.sh

# Tech tracking
tech-stack:
  added:
    - PyYAML>=6.0 (added to requirements.txt for validate-yaml.py)
  patterns:
    - Validate before deploy: install.sh runs validate-yaml.py on all SKILL.md files before copying
    - Prefer venv python: install.sh uses ~/.claude/skills/seo/.venv/bin/python for validation when available
    - Idempotent install: install.sh is safe to run multiple times (cp -R overwrites)
    - Informational exit: verify-mcp-scope.sh always exits 0, MCP status is advisory not blocking

key-files:
  created:
    - install.sh
    - scripts/verify-mcp-scope.sh
    - skills/seo/hooks/validate-yaml.py
    - skills/ (13 skill directories version-controlled)
    - agents/ (6 agent .md files version-controlled)
  modified:
    - skills/seo/requirements.txt (added PyYAML>=6.0)

key-decisions:
  - "Description limit set to 1000 chars (not 500) — existing seo/SKILL.md description is 870 chars and is valid; main orchestrator legitimately needs more text than sub-skills"
  - "install.sh uses venv python for YAML validation when available, with graceful fallback if PyYAML not in system python3"
  - "verify-mcp-scope.sh always exits 0 — MCP registration is informational; blocking install on missing MCP would prevent skill deployment"

patterns-established:
  - "Validate-before-deploy: all SKILL.md frontmatter is validated before any files are copied to ~/.claude/"
  - "Source mirrors target: skills/ and agents/ in repo mirror ~/.claude/skills/ and ~/.claude/agents/ structure exactly"
  - "Venv-for-helpers: all Python execution uses ~/.claude/skills/seo/.venv/ to ensure consistent dependencies"

requirements-completed:
  - FOUND-01
  - FOUND-04

# Metrics
duration: 4min
completed: 2026-03-02
---

# Phase 1 Plan 01: Foundation Install Infrastructure Summary

**Bash install script with pre-deploy YAML validation, Python venv management via pip, and MCP scope verification for 13-skill SEO system**

## Performance

- **Duration:** 4 min
- **Started:** 2026-03-02T06:23:59Z
- **Completed:** 2026-03-02T06:27:51Z
- **Tasks:** 2
- **Files modified:** 47 (41 new skill/agent files + 6 new scripts)

## Accomplishments
- Source-controlled all 13 SEO skill directories and 6 agent files into the repo (skills/, agents/)
- Created install.sh: validates YAML, copies skills/agents to ~/.claude/, sets up venv, checks MCPs
- Created validate-yaml.py: validates name, description, allowed-tools in SKILL.md frontmatter; exits non-zero on failure
- Created verify-mcp-scope.sh: reports GSC and Ahrefs MCP registration status (always exits 0)
- Added PyYAML to requirements.txt; all 4 Python helper scripts confirmed import-clean in venv

## Task Commits

Each task was committed atomically:

1. **Task 1: Create source repo layout and install script** - `d7f04e7` (feat)
2. **Task 2: Create YAML validation script and verify Python helpers** - `8a25967` (feat)

**Plan metadata:** (docs commit — created after this summary)

## Files Created/Modified
- `install.sh` - Main install script: validates YAML, copies skills/agents, sets up venv, verifies MCP
- `scripts/verify-mcp-scope.sh` - MCP scope check: reports GSC and Ahrefs registration status
- `skills/seo/hooks/validate-yaml.py` - YAML frontmatter validator for all SKILL.md files
- `skills/seo/requirements.txt` - Added PyYAML>=6.0
- `skills/` - 13 SEO skill directories (version-controlled source copy)
- `agents/` - 6 SEO agent .md files (version-controlled source copy)

## Decisions Made
- Description character limit raised from 500 to 1000 chars in validate-yaml.py — the existing seo/SKILL.md description is 870 chars and is valid; the orchestrator skill legitimately needs more descriptive text than sub-skills
- install.sh uses venv Python for YAML validation when ~/.claude/skills/seo/.venv/ exists (fallback to system python3 with graceful warning if PyYAML missing)
- verify-mcp-scope.sh always exits 0 — MCP availability is informational; blocking install on missing MCP config would unnecessarily prevent skill deployment

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Raised YAML description limit from 500 to 1000 characters**
- **Found during:** Task 2 verification (running validate-yaml.py against all 13 SKILL.md files)
- **Issue:** validate-yaml.py originally limited description to 500 chars; existing seo/SKILL.md has 870-char description that is valid content, not an error
- **Fix:** Changed limit to 1000 chars in validate-yaml.py
- **Files modified:** skills/seo/hooks/validate-yaml.py
- **Verification:** All 13 SKILL.md files pass validation; seo/SKILL.md now correctly passes
- **Committed in:** 8a25967 (Task 2 commit)

**2. [Rule 3 - Blocking] install.sh falls back gracefully when PyYAML not in system python3**
- **Found during:** Task 1 verification (running install.sh --dry-run)
- **Issue:** System python3 (3.14.3) does not have PyYAML installed; install.sh crashed with ImportError before any file copying
- **Fix:** Added logic to detect and prefer venv python for validation; falls back with warning if PyYAML unavailable
- **Files modified:** install.sh
- **Verification:** install.sh --dry-run completes successfully using venv python
- **Committed in:** d7f04e7 (Task 1 commit)

---

**Total deviations:** 2 auto-fixed (1 bug fix, 1 blocking issue)
**Impact on plan:** Both fixes required for correct operation. No scope creep.

## Issues Encountered
- PyYAML not available in system Python 3.14.3 — install.sh now prefers the venv python which has PyYAML installed via requirements.txt

## User Setup Required
The GSC MCP is not registered at user scope (`~/.claude/mcp.json` does not exist). When Phase 2 GSC commands are built, the user will need to:

1. Create `~/.claude/mcp.json`
2. Register the GSC MCP from `/Users/aash-zsbch1500/Desktop/GSC-MCP`

This is documented in the verify-mcp-scope.sh output and is tracked as a Phase 2 blocker in STATE.md.

## Next Phase Readiness
- Install infrastructure complete — any new skills added to skills/ are deployed via `bash install.sh`
- YAML validation enforces frontmatter consistency across all 13 current and future skill directories
- Python venv with all dependencies ready for helper script execution
- Phase 1 Plan 02 (shared reference files and orchestrator routing) can begin immediately

## Self-Check: PASSED

All files verified present. All commits verified in git log.

- FOUND: install.sh
- FOUND: scripts/verify-mcp-scope.sh
- FOUND: skills/seo/hooks/validate-yaml.py
- FOUND: skills/seo/requirements.txt
- FOUND: skills/ (13 directories)
- FOUND: agents/ (6 files)
- FOUND: .planning/phases/01-foundation/01-01-SUMMARY.md
- FOUND: d7f04e7 (Task 1 commit)
- FOUND: 8a25967 (Task 2 commit)

---
*Phase: 01-foundation*
*Completed: 2026-03-02*
