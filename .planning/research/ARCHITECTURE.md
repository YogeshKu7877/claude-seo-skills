# Architecture Patterns: Claude Code SEO Skill System

**Domain:** Claude Code skill system — 27 SEO analysis commands
**Researched:** 2026-03-02
**Confidence:** HIGH — based on direct inspection of reference implementation at `/Users/aash-zsbch1500/Downloads/claude-seo-main/`

---

## Recommended Architecture

The reference implementation (`claude-seo`) establishes the proven pattern. Adopt it wholesale, then extend it with MCP data layers for the 15 new commands. Do not reinvent — extend.

### System Overview

```
~/.claude/
├── skills/
│   ├── seo/                          # Main orchestrator (entry point)
│   │   ├── SKILL.md                  # Routing logic, quick reference table
│   │   ├── references/               # On-demand reference data (load lazily)
│   │   │   ├── cwv-thresholds.md
│   │   │   ├── eeat-framework.md
│   │   │   ├── quality-gates.md
│   │   │   ├── schema-types.md
│   │   │   ├── ahrefs-api-reference.md   [NEW]
│   │   │   └── gsc-api-reference.md      [NEW]
│   │   ├── schema/
│   │   │   └── templates.json            # Schema.org JSON-LD templates
│   │   ├── scripts/                      # Shared Python utilities
│   │   │   ├── fetch_page.py
│   │   │   ├── parse_html.py
│   │   │   ├── capture_screenshot.py
│   │   │   ├── analyze_visual.py
│   │   │   └── parse_log.py              [NEW] for /seo log-analysis
│   │   └── hooks/
│   │       ├── pre-commit-seo-check.sh
│   │       └── validate-schema.py
│   │
│   ├── seo-audit/SKILL.md                # [EXISTING] Full site audit
│   ├── seo-page/SKILL.md                 # [EXISTING] Single page analysis
│   ├── seo-technical/SKILL.md            # [EXISTING] Technical audit
│   ├── seo-content/SKILL.md              # [EXISTING] E-E-A-T analysis
│   ├── seo-schema/SKILL.md               # [EXISTING] Schema markup
│   ├── seo-images/SKILL.md               # [EXISTING] Image optimization
│   ├── seo-sitemap/SKILL.md              # [EXISTING] Sitemap
│   ├── seo-geo/SKILL.md                  # [EXISTING] AI search / GEO
│   ├── seo-plan/                         # [EXISTING] Strategic planning
│   │   ├── SKILL.md
│   │   └── assets/                       # Industry templates
│   │       ├── saas.md, local-service.md, ecommerce.md
│   │       ├── publisher.md, agency.md, generic.md
│   ├── seo-programmatic/SKILL.md         # [EXISTING] Programmatic SEO
│   ├── seo-competitor-pages/SKILL.md     # [EXISTING] Comparison pages
│   ├── seo-hreflang/SKILL.md             # [EXISTING] i18n SEO
│   │
│   ├── seo-gsc/SKILL.md                  # [NEW] GSC sub-commands
│   ├── seo-ahrefs/SKILL.md               # [NEW] Ahrefs sub-commands
│   ├── seo-markdown-audit/SKILL.md       # [NEW] Markdown pre-publish audit
│   ├── seo-site-audit-pro/SKILL.md       # [NEW] Full audit with MCPs
│   ├── seo-content-brief/SKILL.md        # [NEW] Brief from SERP
│   ├── seo-brand-radar/SKILL.md          # [NEW] AI brand monitoring
│   ├── seo-serp/SKILL.md                 # [NEW] SERP analysis
│   ├── seo-report/SKILL.md               # [NEW] Report generation
│   ├── seo-competitor-monitor/SKILL.md   # [NEW] Competitor tracking
│   ├── seo-ads-intel/SKILL.md            # [NEW] Ad intelligence
│   ├── seo-internal-links/SKILL.md       # [NEW] Internal link optimizer
│   ├── seo-ai-content-check/SKILL.md     # [NEW] AI content detection
│   ├── seo-log-analysis/SKILL.md         # [NEW] Server log analysis
│   ├── seo-local/SKILL.md                # [NEW] Local SEO
│   └── seo-migration-check/SKILL.md      # [NEW] Migration validation
│
└── agents/
    ├── seo-technical.md                  # [EXISTING] Technical specialist
    ├── seo-content.md                    # [EXISTING] Content reviewer
    ├── seo-schema.md                     # [EXISTING] Schema expert
    ├── seo-sitemap.md                    # [EXISTING] Sitemap architect
    ├── seo-performance.md                # [EXISTING] CWV analyzer
    ├── seo-visual.md                     # [EXISTING] Screenshot analyzer
    ├── seo-ahrefs-analyst.md             # [NEW] Ahrefs data specialist
    ├── seo-gsc-analyst.md                # [NEW] GSC data specialist
    └── seo-competitor-analyst.md         # [NEW] Competitor intelligence
```

---

## Component Boundaries

Each component has a single responsibility. Components are separated by type (skill vs agent) and by data source dependency.

| Component | Responsibility | Communicates With | Data Source |
|-----------|---------------|-------------------|-------------|
| `seo` (orchestrator) | Route commands, spawn sub-skills, aggregate results | All sub-skills and agents | None directly |
| Sub-skills (`seo-*/SKILL.md`) | Define instructions and logic for one command domain | Orchestrator (receives tasks), agents (delegates parallel work) | Inherited from caller |
| Agents (`agents/seo-*.md`) | Execute specialized parallel analysis, return structured results | Spawned by orchestrator or sub-skills | Python scripts, MCPs, WebFetch |
| Reference files (`references/*.md`) | Provide authoritative data constants (thresholds, frameworks) | Loaded on-demand by skills/agents | Static |
| Scripts (`scripts/*.py`) | Perform concrete I/O operations (fetch, parse, screenshot) | Called via Bash by agents | HTTP, filesystem |
| Industry templates (`seo-plan/assets/`) | Provide starting-point site structures per business type | Loaded by `seo-plan` sub-skill | Static |
| Schema templates (`schema/templates.json`) | Ready-to-use JSON-LD blocks | Loaded by `seo-schema` sub-skill | Static |

### New MCP-Aware Components (15 new commands)

| Component | Responsibility | Required MCPs | Degrades Without |
|-----------|---------------|---------------|-----------------|
| `seo-gsc` | Real GSC data: clicks, impressions, drops, opportunities | GSC MCP | Tells user MCP not available |
| `seo-ahrefs` | DR, backlinks, keyword rankings, competitor gaps | Ahrefs MCP | Tells user MCP not available |
| `seo-site-audit-pro` | Full audit combining all data sources | GSC + Ahrefs MCPs | Falls back to static HTML analysis |
| `seo-content-brief` | SERP-driven content brief | Ahrefs MCP | Uses WebFetch fallback |
| `seo-brand-radar` | AI brand mention monitoring | Ahrefs Brand Radar MCP | Partial output only |
| `seo-serp` | Live SERP analysis | Ahrefs MCP | Uses WebFetch fallback |
| `seo-report` | Automated markdown reports | GSC + Ahrefs MCPs | Generates report skeleton only |
| `seo-competitor-monitor` | Ongoing competitor tracking (setup command) | RSS feeds | Core functionality survives |
| `seo-ads-intel` | Competitor ad intelligence | Google Ads Transparency MCP | Skip ad data, warn user |
| `seo-internal-links` | Internal link graph analysis | None (uses sitemap/crawl) | Fully functional |
| `seo-ai-content-check` | AI content detection and optimization | None (text analysis) | Fully functional |
| `seo-log-analysis` | Server log crawl pattern analysis | None (file input) | Fully functional |
| `seo-local` | Local SEO audit | None (HTML analysis) | Fully functional |
| `seo-migration-check` | Migration redirect validation | GSC MCP (for traffic data) | Partial without traffic data |
| `seo-markdown-audit` | Pre-publish markdown file audit | None | Fully functional |

---

## Data Flow

### Pattern A: Static Analysis (No MCP)

Used by: `seo-markdown-audit`, `seo-log-analysis`, `seo-ai-content-check`, `seo-local`, `seo-internal-links`

```
User invokes /seo <command>
        │
        ▼
seo orchestrator (SKILL.md)
        │  reads routing table
        │  routes to sub-skill
        ▼
seo-<command>/SKILL.md
        │  loads reference files on-demand
        │  calls Python script via Bash (if needed)
        ▼
scripts/*.py
        │  performs I/O (file read, HTTP fetch)
        │  returns structured data
        ▼
Sub-skill aggregates result
        │
        ▼
Output: Markdown report written to file or streamed to user
```

### Pattern B: MCP-Enriched Analysis (Single MCP)

Used by: `seo-gsc`, `seo-ahrefs`, `seo-content-brief`, `seo-serp`

```
User invokes /seo <command>
        │
        ▼
seo orchestrator → routes to sub-skill
        │
        ▼
seo-<command>/SKILL.md
        │  checks MCP availability
        │  queries MCP tool directly (Ahrefs or GSC)
        │
        ├─── MCP available ───────────────────────────┐
        │                                              │
        ▼                                              ▼
Calls MCP tools                               WebFetch fallback
(mcp__ahrefs__* / mcp__gsc__*)               (scrapes public data)
        │                                              │
        └────────────────┬─────────────────────────────┘
                         │
                         ▼
               Parses + formats results
               Applies analysis logic
                         │
                         ▼
               Markdown report output
```

### Pattern C: Multi-MCP Audit with Parallel Agents

Used by: `seo-site-audit-pro`, `seo-audit` (enhanced version)

```
User invokes /seo site-audit-pro <domain>
        │
        ▼
seo-site-audit-pro/SKILL.md
        │  detects business type
        │  spawns agents in parallel
        │
   ┌────┴──────┬──────────┬──────────┬──────────┬──────────┬──────────┐
   ▼           ▼          ▼          ▼          ▼          ▼          ▼
seo-       seo-       seo-       seo-       seo-ahrefs seo-gsc   seo-
technical  content    schema     sitemap    -analyst   -analyst  competitor
agent      agent      agent      agent      agent      agent     -analyst
   │           │          │          │          │          │          │
WebFetch   WebFetch   WebFetch   WebFetch   Ahrefs     GSC MCP   Ahrefs
scripts    scripts    scripts    scripts    MCP        tools     MCP
   │           │          │          │          │          │          │
   └────────────────────────────────┬──────────────────────────────────┘
                                    │  all results collected
                                    ▼
                          seo-site-audit-pro
                          aggregates + scores
                                    │
                                    ▼
                      FULL-AUDIT-REPORT.md
                      ACTION-PLAN.md
                      (30/60/90-day roadmap)
```

### Pattern D: Report Generation Flow

Used by: `seo-report`

```
User invokes /seo report monthly <domain>
        │
        ▼
seo-report/SKILL.md
        │
        ├── Fetch GSC period data (MCP)
        ├── Fetch Ahrefs ranking/backlink changes (MCP)
        ├── Compare periods (inline logic)
        ├── Format into markdown template
        │
        ▼
Output: MONTHLY-REPORT-{domain}-{date}.md
(saved to project directory)
```

---

## Patterns to Follow

### Pattern 1: Lazy Reference Loading

**What:** Reference files are NOT loaded at skill startup. They are loaded inline when the specific analysis requiring them runs.

**Why:** Keeps skill context lean. The main `seo/SKILL.md` is under 200 lines. Reference files (e.g., `eeat-framework.md` at 7KB) only enter context when an E-E-A-T analysis is triggered.

**Implementation:**
```markdown
# In seo-content/SKILL.md

When assessing E-E-A-T signals, read `seo/references/eeat-framework.md`
for the full criteria. Do NOT load at startup.
```

### Pattern 2: Single Orchestrator, Many Sub-Skills

**What:** All 27 commands are routed through a single `seo/SKILL.md` entry point that contains the command routing table.

**Why:** Users only need to learn one skill name (`/seo`). The orchestrator handles discovery and routing invisibly.

**Implementation:**
The main `SKILL.md` contains a Quick Reference table listing all commands and one-line descriptions. For each command, it either loads the sub-skill directly or spawns agents in parallel.

### Pattern 3: MCP Availability Checks with Graceful Degradation

**What:** Every MCP-dependent skill checks if the required MCP is available before attempting to call it, then falls back to static analysis or a clear error message.

**Why:** The system must be installable by others who may not have Ahrefs or GSC connected. Public release requires graceful behavior.

**Implementation:**
```markdown
# In seo-ahrefs/SKILL.md

Before calling Ahrefs MCP tools, check availability:
- If Ahrefs MCP tools are accessible, proceed with live data
- If not available, inform the user: "Ahrefs MCP not connected.
  Connect via `@ahrefs/mcp` to enable live data. Static analysis
  not available for this command."
```

### Pattern 4: Structured Agent Definitions

**What:** Subagents are separate `.md` files in `~/.claude/agents/` with YAML frontmatter declaring `name`, `description`, and `tools`.

**Why:** Claude Code's agent system requires this format to discover and spawn agents. The `description` field drives automatic selection — write it with activation keywords.

**Implementation:**
```yaml
---
name: seo-ahrefs-analyst
description: >
  Ahrefs data specialist. Retrieves backlink profiles, domain rating,
  keyword rankings, and competitor data using Ahrefs MCP. Spawn when
  analysis requires live Ahrefs data for backlinks, DR, keywords,
  content gap, or competitor research.
tools: Read, Write, Bash
---
```

### Pattern 5: Ahrefs Currency Handling

**What:** Ahrefs API returns monetary values (e.g., traffic value) in USD cents. Skills must divide by 100 before displaying.

**Why:** Documented API behavior. Displaying raw cents would show "traffic value: $450000" instead of "$4,500.00".

**Implementation:**
```markdown
# In seo-ahrefs/SKILL.md

IMPORTANT: Ahrefs API returns monetary values in USD cents.
Always divide traffic_value by 100 before displaying.
Example: traffic_value: 450000 → display as "$4,500"
```

### Pattern 6: Sub-Command Pattern for Complex Skills

**What:** Skills with multiple related operations use sub-commands rather than separate top-level skills.

**Why:** Keeps the command surface manageable. `/seo gsc overview`, `/seo gsc drops`, `/seo gsc opportunities` are related and users expect them together.

**Implementation:**
```markdown
# In seo-gsc/SKILL.md

## Sub-commands

Parse the second argument to determine operation:
- `overview` → Dashboard: clicks, impressions, CTR, position
- `drops` → Pages/keywords that lost traffic
- `opportunities` → High impressions + low CTR keywords
...
```

---

## Anti-Patterns to Avoid

### Anti-Pattern 1: One Monolithic SKILL.md

**What:** Putting all 27 commands' logic into a single `seo/SKILL.md` file.

**Why bad:** Context bloat. Claude Code loads the entire file. A 5,000-line SKILL.md wastes tokens on irrelevant instructions for every invocation. The reference implementation keeps the main SKILL.md under 200 lines.

**Instead:** Main SKILL.md contains routing only. Each sub-skill has its own SKILL.md with full logic. Reference files are loaded lazily.

### Anti-Pattern 2: Agents That Share Mutable State

**What:** Designing agents to read/write shared files mid-execution during parallel audit runs.

**Why bad:** Race conditions. Two agents writing to the same `audit-results.md` simultaneously produces corrupted output.

**Instead:** Each agent writes to a named temporary file (e.g., `technical-results.tmp`, `content-results.tmp`). The orchestrator sub-skill reads and merges them after all agents complete.

### Anti-Pattern 3: MCP Calls in Reference Files

**What:** Putting MCP API calls inside reference files (e.g., having `cwv-thresholds.md` call a live API for current thresholds).

**Why bad:** Reference files are loaded as context — they should be static data. MCP calls belong in agents and skills.

**Instead:** Reference files contain static, curated thresholds. When live CWV data is needed, the `seo-performance` agent calls PageSpeed Insights or CrUX API directly.

### Anti-Pattern 4: Skipping the Graceful Degradation Pattern

**What:** Writing commands that fail hard when an MCP is unavailable.

**Why bad:** The system will be published publicly. Most users won't have Ahrefs or GSC connected. Hard failures make the tool unusable for static analysis use cases.

**Instead:** Every MCP-dependent command documents its fallback behavior explicitly in SKILL.md.

### Anti-Pattern 5: Duplicating Reference Data Across Skills

**What:** Each sub-skill maintaining its own copy of CWV thresholds, schema deprecation lists, or E-E-A-T criteria.

**Why bad:** Divergence. When INP thresholds change or a schema type is deprecated, you'd need to update 12 files instead of one.

**Instead:** All shared reference data lives in `seo/references/`. Sub-skills reference these files with load-on-demand instructions.

---

## Component Build Order

Build order is determined by dependency direction: foundational components first, dependent components after.

### Tier 0 — Foundation (build first, everything depends on this)

1. **Main orchestrator** (`seo/SKILL.md`) — routing table and command registry
2. **Shared scripts** (`scripts/*.py`) — `fetch_page.py`, `parse_html.py` used by most agents
3. **Reference files** (`references/`) — thresholds and frameworks referenced by all skills
4. **Existing agents** (copy from reference repo, update as needed)

### Tier 1 — Enhanced Originals (12 commands)

Migrate from reference implementation with improvements. These are independent of MCP.

5. `seo-audit` + `seo-page` + `seo-technical`
6. `seo-content` + `seo-schema` + `seo-sitemap`
7. `seo-geo` + `seo-images` + `seo-plan`
8. `seo-programmatic` + `seo-competitor-pages` + `seo-hreflang`

**Dependency:** All require Tier 0 foundation. None depend on each other.

### Tier 2 — New MCP-Independent Commands (build before MCP commands)

These new commands don't require MCPs, so they can be built and tested immediately.

9. `seo-markdown-audit` — file system only
10. `seo-log-analysis` — file input, `parse_log.py` script
11. `seo-ai-content-check` — text analysis, no external calls
12. `seo-internal-links` — uses sitemap/HTML crawl
13. `seo-local` — HTML analysis + schema generation
14. `seo-migration-check` (core) — redirect chain validation

**Dependency:** Requires Tier 0. Independent of Tier 1.

### Tier 3 — Single-MCP Commands (require one MCP each)

15. `seo-gsc` + `seo-gsc-analyst` agent — requires GSC MCP
16. `seo-ahrefs` + `seo-ahrefs-analyst` agent — requires Ahrefs MCP
17. `seo-serp` — requires Ahrefs MCP
18. `seo-content-brief` — requires Ahrefs MCP
19. `seo-brand-radar` — requires Ahrefs Brand Radar
20. `seo-report` (skeleton) — requires GSC + Ahrefs for full output

**Dependency:** Requires Tier 0. Build MCP reference files (`ahrefs-api-reference.md`, `gsc-api-reference.md`) before agents.

### Tier 4 — Multi-MCP Commands (build last)

21. `seo-site-audit-pro` — requires GSC + Ahrefs + all Tier 1 agents
22. `seo-competitor-monitor` (setup command) — requires Ahrefs + RSS feeds
23. `seo-ads-intel` — requires Google Ads Transparency MCP
24. `seo-migration-check` (enhanced) — adds GSC traffic data layer

**Dependency:** Requires Tier 0, Tier 1 agents, and Tier 3 MCP analysts.

---

## Directory Naming Conventions

Established by reference implementation. Maintain exactly.

| Type | Pattern | Location | Example |
|------|---------|----------|---------|
| Orchestrator skill | `seo/SKILL.md` | `~/.claude/skills/seo/` | `seo/SKILL.md` |
| Sub-skill | `seo-{name}/SKILL.md` | `~/.claude/skills/seo-{name}/` | `seo-gsc/SKILL.md` |
| Agent | `seo-{name}.md` | `~/.claude/agents/` | `seo-ahrefs-analyst.md` |
| Reference file | `{topic}.md` | `~/.claude/skills/seo/references/` | `ahrefs-api-reference.md` |
| Script | `{action}_{noun}.py` | `~/.claude/skills/seo/scripts/` | `parse_log.py` |
| Industry template | `{industry}.md` | `~/.claude/skills/seo-plan/assets/` | `saas.md` |
| Schema template | `templates.json` | `~/.claude/skills/seo/schema/` | `templates.json` |

---

## Scalability Considerations

This is a local developer tool installed per-user. Scalability means: "works well for one user with large sites and many commands." Not multi-tenant or cloud-scale.

| Concern | For 1 user (personal tool) | For community (public release) |
|---------|---------------------------|-------------------------------|
| Skill context size | Keep each SKILL.md under 300 lines | Same constraint — document it |
| Parallel agent count | seo-site-audit-pro spawns 7-10 agents | Cap at 10 to avoid overwhelming Claude |
| MCP rate limits | Ahrefs: check API quota before bulk calls | Document rate limits in reference files |
| Script dependencies | Python 3.8+, optional Playwright | Clear requirements.txt, graceful fallback |
| Install complexity | One `install.sh` handles everything | Test on macOS, Linux, Windows (PS1 script) |

---

## Sources

- Direct code inspection: `/Users/aash-zsbch1500/Downloads/claude-seo-main/` (reference implementation, Feb 2026)
  - `seo/SKILL.md` — orchestrator pattern
  - `docs/ARCHITECTURE.md` — component type definitions
  - `agents/seo-*.md` — 6 agent definitions
  - `skills/*/SKILL.md` — 12 sub-skill implementations
  - `install.sh` — deployment target paths
- Project requirements: `/Users/aash-zsbch1500/Desktop/Github projects/SEO/.planning/PROJECT.md`
- Expansion spec: `/Users/aash-zsbch1500/Desktop/Github projects/SEO/seo-skill-expansion.md`
