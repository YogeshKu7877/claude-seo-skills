#!/usr/bin/env bash
set -euo pipefail

# install.sh — Deploy SEO skill system to ~/.claude/
# Copies skills and agents, creates Python venv, verifies MCP registration.
# Idempotent: safe to run multiple times.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="${SCRIPT_DIR}/skills"
AGENTS_SRC="${SCRIPT_DIR}/agents"
TARGET_SKILLS="${HOME}/.claude/skills"
TARGET_AGENTS="${HOME}/.claude/agents"
VENV_PATH="${TARGET_SKILLS}/seo/.venv"
REQUIREMENTS="${TARGET_SKILLS}/seo/requirements.txt"
VALIDATE_SCRIPT="${SKILLS_SRC}/seo/hooks/validate-yaml.py"

DRY_RUN=false

# Parse arguments
for arg in "$@"; do
  case "$arg" in
    --dry-run)
      DRY_RUN=true
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      echo "Usage: $0 [--dry-run]" >&2
      exit 1
      ;;
  esac
done

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log() { echo -e "${GREEN}[install]${NC} $*"; }
warn() { echo -e "${YELLOW}[warn]${NC} $*"; }
err() { echo -e "${RED}[error]${NC} $*" >&2; }

if $DRY_RUN; then
  log "DRY RUN MODE — no files will be copied or modified"
fi

# --- Step 1: Validate all SKILL.md files before deploying ---
log "Validating SKILL.md frontmatter..."

if [ ! -f "${VALIDATE_SCRIPT}" ]; then
  warn "validate-yaml.py not found at ${VALIDATE_SCRIPT} — skipping YAML validation"
else
  # Prefer venv python (has PyYAML installed) over system python3
  PYTHON_BIN="python3"
  if [ -f "${VENV_PATH}/bin/python" ]; then
    PYTHON_BIN="${VENV_PATH}/bin/python"
  fi

  # Check if PyYAML is available
  if ! "${PYTHON_BIN}" -c "import yaml" 2>/dev/null; then
    warn "PyYAML not available in ${PYTHON_BIN} — skipping YAML validation"
    warn "Install with: pip install PyYAML>=6.0 (or run install.sh once without --dry-run to set up venv first)"
  else
    SKILL_MDS=()
    while IFS= read -r -d '' f; do
      SKILL_MDS+=("$f")
    done < <(find "${SKILLS_SRC}" -name "SKILL.md" -print0)

    if [ ${#SKILL_MDS[@]} -eq 0 ]; then
      warn "No SKILL.md files found under ${SKILLS_SRC}"
    else
      if ! "${PYTHON_BIN}" "${VALIDATE_SCRIPT}" "${SKILL_MDS[@]}"; then
        err "YAML validation failed — aborting install. Fix SKILL.md errors above."
        exit 1
      fi
      log "YAML validation passed (${#SKILL_MDS[@]} SKILL.md files validated)"
    fi
  fi
fi

# --- Step 2: Copy skill directories ---
SKILL_COUNT=0
if [ -d "${SKILLS_SRC}" ]; then
  for skill_dir in "${SKILLS_SRC}"/*/; do
    skill_name=$(basename "${skill_dir}")
    target="${TARGET_SKILLS}/${skill_name}"
    if $DRY_RUN; then
      echo "  [dry-run] would copy ${skill_dir} -> ${target}"
    else
      mkdir -p "${TARGET_SKILLS}"
      cp -R "${skill_dir}" "${target}"
    fi
    SKILL_COUNT=$((SKILL_COUNT + 1))
  done
  log "${SKILL_COUNT} skill directories $(if $DRY_RUN; then echo 'would be copied'; else echo 'copied'; fi) to ${TARGET_SKILLS}"
else
  warn "No skills/ directory found at ${SKILLS_SRC}"
fi

# --- Step 3: Copy agent files ---
AGENT_COUNT=0
if [ -d "${AGENTS_SRC}" ]; then
  for agent_file in "${AGENTS_SRC}"/*.md; do
    [ -f "${agent_file}" ] || continue
    agent_name=$(basename "${agent_file}")
    target="${TARGET_AGENTS}/${agent_name}"
    if $DRY_RUN; then
      echo "  [dry-run] would copy ${agent_file} -> ${target}"
    else
      mkdir -p "${TARGET_AGENTS}"
      cp "${agent_file}" "${target}"
    fi
    AGENT_COUNT=$((AGENT_COUNT + 1))
  done
  log "${AGENT_COUNT} agent files $(if $DRY_RUN; then echo 'would be copied'; else echo 'copied'; fi) to ${TARGET_AGENTS}"
else
  warn "No agents/ directory found at ${AGENTS_SRC}"
fi

# --- Step 4: Python venv setup ---
if $DRY_RUN; then
  echo "  [dry-run] would create venv at ${VENV_PATH}"
  echo "  [dry-run] would run pip install -r ${REQUIREMENTS}"
  VENV_STATUS="would be created"
else
  if [ ! -d "${VENV_PATH}" ]; then
    log "Creating Python venv at ${VENV_PATH}..."
    python3 -m venv "${VENV_PATH}"
  else
    log "Python venv already exists at ${VENV_PATH}"
  fi

  if [ -f "${REQUIREMENTS}" ]; then
    log "Installing Python dependencies from ${REQUIREMENTS}..."
    "${VENV_PATH}/bin/pip" install --quiet -r "${REQUIREMENTS}"
    VENV_STATUS="ready (dependencies installed)"
  else
    warn "requirements.txt not found at ${REQUIREMENTS} — skipping pip install"
    VENV_STATUS="created (no requirements.txt found)"
  fi
fi

# --- Step 5: Verify MCP scope ---
MCP_STATUS="unknown"
VERIFY_SCRIPT="${SCRIPT_DIR}/scripts/verify-mcp-scope.sh"
if [ -f "${VERIFY_SCRIPT}" ]; then
  log "Checking MCP registration..."
  MCP_STATUS=$(bash "${VERIFY_SCRIPT}" 2>&1) || true
  echo "${MCP_STATUS}"
else
  warn "verify-mcp-scope.sh not found — skipping MCP verification"
  MCP_STATUS="not checked (script missing)"
fi

# --- Summary ---
echo ""
echo "========================================"
echo "  SEO Skill System Install Summary"
echo "========================================"
echo "  Skills  : ${SKILL_COUNT} directories -> ${TARGET_SKILLS}"
echo "  Agents  : ${AGENT_COUNT} files -> ${TARGET_AGENTS}"
echo "  Venv    : ${VENV_PATH}"
if $DRY_RUN; then
  echo "  Mode    : DRY RUN — no changes made"
fi
echo "========================================"
echo ""
log "Done."
