# Technology Stack: Claude Code SEO Skill Expansion

**Project:** Claude Code SEO Skill Expansion (27 commands)
**Researched:** 2026-03-02
**Source:** Direct code inspection of `/Users/aash-zsbch1500/Desktop/Github projects/claude-seo-main/` + installed skills at `~/.claude/`

---

## TL;DR

Skills are Markdown files with YAML frontmatter, not code. Claude reads them at invocation time and follows the instructions inside. Agents are the same format but live in `~/.claude/agents/`. MCP tools are called by name directly in instructions (e.g., "use the Ahrefs MCP to fetch backlink data") — no import, no wiring, no API client code required.

---

## Skill File Structure

### Core Pattern: `~/.claude/skills/{skill-name}/SKILL.md`

Every skill is one Markdown file with YAML frontmatter. This is the complete "framework" — no build step, no runtime, no dependencies.

```
~/.claude/skills/
├── seo/                    # Main orchestrator (the /seo command entry point)
│   ├── SKILL.md            # Routing logic + command table
│   └── references/         # On-demand reference files (loaded only when needed)
│       ├── cwv-thresholds.md
│       ├── schema-types.md
│       ├── eeat-framework.md
│       └── quality-gates.md
│
├── seo-audit/              # /seo audit subcommand
│   └── SKILL.md
├── seo-technical/          # /seo technical subcommand
│   └── SKILL.md
├── seo-content/            # /seo content subcommand
│   └── SKILL.md
├── seo-schema/             # /seo schema subcommand
│   └── SKILL.md
├── seo-page/               # /seo page subcommand
│   └── SKILL.md
├── seo-geo/                # /seo geo subcommand
│   └── SKILL.md
├── seo-plan/               # /seo plan subcommand
│   ├── SKILL.md
│   └── assets/             # Industry template files (saas.md, ecommerce.md, etc.)
├── seo-programmatic/       # /seo programmatic subcommand
│   └── SKILL.md
├── seo-competitor-pages/   # /seo competitor-pages subcommand
│   └── SKILL.md
├── seo-hreflang/           # /seo hreflang subcommand
│   └── SKILL.md
├── seo-images/             # /seo images subcommand
│   └── SKILL.md
└── seo-sitemap/            # /seo sitemap subcommand
    └── SKILL.md
```

### Agent Files: `~/.claude/agents/{agent-name}.md`

```
~/.claude/agents/
├── seo-content.md          # Content quality specialist
├── seo-performance.md      # Core Web Vitals analyzer
├── seo-schema.md           # Schema markup expert
├── seo-sitemap.md          # Sitemap architect
├── seo-technical.md        # Technical SEO specialist
└── seo-visual.md           # Visual/screenshot analyzer
```

---

## SKILL.md Format (Exact Spec)

Skills use a two-section structure: YAML frontmatter + Markdown body.

```markdown
---
name: seo-audit
description: >
  Full website SEO audit with parallel subagent delegation. Crawls up to 500
  pages, detects business type, delegates to 6 specialists, generates health
  score. Use when user says "audit", "full SEO check", "analyze my site",
  or "website health check".
---

# Full Website SEO Audit

## Process

1. **Fetch homepage** — use `scripts/fetch_page.py` to retrieve HTML
2. **Detect business type** — analyze homepage signals per seo orchestrator
3. **Crawl site** — follow internal links up to 500 pages, respect robots.txt
4. **Delegate to subagents** (if available, otherwise run inline sequentially):
   - `seo-technical` — robots.txt, sitemaps, canonicals, Core Web Vitals, security headers
   - `seo-content` — E-E-A-T, readability, thin content, AI citation readiness
   ...
```

**YAML frontmatter fields:**
- `name` — must match the directory name (e.g., `seo-audit` in `skills/seo-audit/`)
- `description` — this is the activation trigger. Claude uses this to decide when to load the skill. Include exact user phrases that should trigger it.
- `allowed-tools` (optional) — restrict which tools the skill can use. If omitted, all tools available.

**Critical:** The `description` field in the main orchestrator skill (`seo/SKILL.md`) is long and covers all possible trigger phrases for all subcommands. Sub-skill descriptions are narrower and focused on their specific command.

---

## Agent File Format (Exact Spec)

Agents are the parallel worker pattern. They are invoked by skills during complex operations.

```markdown
---
name: seo-technical
description: Technical SEO specialist. Analyzes crawlability, indexability, security, URL structure, mobile optimization, Core Web Vitals, and JavaScript rendering.
tools: Read, Bash, Write, Glob, Grep
---

You are a Technical SEO specialist. When given a URL or set of URLs:

1. Fetch the page(s) and analyze HTML source
2. Check robots.txt and sitemap availability
...
```

**Agent frontmatter fields:**
- `name` — agent identifier, used when skills invoke it
- `description` — what this agent does (used for routing/selection)
- `tools` — comma-separated list of Claude Code tools this agent can use

**Tool options:** `Read`, `Write`, `Bash`, `Grep`, `Glob`, `WebFetch`

---

## The Two-Tier System: Skills vs Agents

| Aspect | Skill | Agent |
|--------|-------|-------|
| Location | `~/.claude/skills/{name}/SKILL.md` | `~/.claude/agents/{name}.md` |
| Invocation | User types `/seo audit` | Spawned by a skill via orchestration |
| Context | Shares context with user session | Gets its own isolated context |
| Parallelism | Sequential (one skill active at a time) | Can run concurrently with other agents |
| Tools | Restricted by `allowed-tools` or default | Restricted by `tools` frontmatter |
| When to use | User-facing commands | Parallel background workers |

**When to create an agent vs keep in-skill:** If the analysis can run concurrently with other analyses (e.g., technical check while content check runs), make it an agent. If it's a sequential step or needs user interaction, keep it in the skill.

---

## MCP Integration Pattern

MCPs are called by natural language instructions inside SKILL.md and agent files. No wiring code is needed.

### How It Works

Skills reference MCP tools by description. Claude Code resolves the available MCPs at runtime from `~/.claude/claude.json` (or project-level `claude.json`). The skill just says what it needs:

```markdown
## Data Sources

1. Use the Ahrefs MCP to fetch the domain overview for {domain}:
   - Domain Rating (DR)
   - Total backlinks
   - Organic keywords count
   - Estimated monthly traffic

2. Use the Google Search Console MCP to pull search performance:
   - Total clicks (last 28 days)
   - Total impressions
   - Average CTR
   - Average position
```

### Ahrefs MCP Tool Reference

The Ahrefs MCP (`@ahrefs/mcp`) exposes these capabilities (HIGH confidence — official Ahrefs MCP, launched July 2025):

| Capability | What to Write in SKILL.md |
|------------|--------------------------|
| Domain overview | "Use Ahrefs MCP to get domain overview for {domain}" |
| Backlinks | "Use Ahrefs MCP to fetch top backlinks for {domain}" |
| Organic keywords | "Use Ahrefs MCP to get top organic keywords for {domain}" |
| SERP overview | "Use Ahrefs MCP to get SERP overview for keyword {keyword}" |
| Competitor analysis | "Use Ahrefs MCP to find organic competitors of {domain}" |
| Content gap | "Use Ahrefs MCP to run content gap analysis for {domain} vs {competitors}" |
| Brand Radar | "Use Ahrefs Brand Radar MCP to check AI mentions for {brand}" |
| Broken backlinks | "Use Ahrefs MCP to find broken backlinks for {domain}" |
| New/lost links | "Use Ahrefs MCP to get recently acquired and lost backlinks for {domain}" |

**Critical data formatting rule:** Ahrefs API returns monetary values in USD cents. Always divide by 100 before displaying. Document this in every skill that calls Ahrefs for traffic/value data.

### Google Search Console MCP

The GSC MCP (`mcp-server-gsc`) provides:

| Capability | What to Write in SKILL.md |
|------------|--------------------------|
| Performance overview | "Use GSC MCP to get search performance for {site} over last 28 days" |
| By page | "Use GSC MCP to get performance breakdown by page for {site}" |
| By query | "Use GSC MCP to get performance breakdown by query for {site}" |
| URL inspection | "Use GSC MCP to inspect URL {url} for indexing status" |
| Index coverage | "Use GSC MCP to get coverage report for {site}" |
| Sitemaps | "Use GSC MCP to list submitted sitemaps for {site}" |

**Period comparison:** GSC MCP supports date ranges. For decay detection, request two periods: "last 28 days" and "previous 28 days". Claude handles the diff math in-skill.

### MCP Graceful Degradation

Skills must handle the case where MCPs are unavailable. The pattern from the codebase:

```markdown
## Data Sources

1. **If Ahrefs MCP is available:** Use Ahrefs MCP to fetch domain overview...
2. **If Ahrefs MCP is unavailable:** Note that backlink and keyword data requires
   Ahrefs MCP connection. Proceed with static HTML analysis only and flag
   missing data sections in the report.
```

Never hard-fail when an MCP is optional. Always provide partial value without it.

---

## Orchestration Patterns (Verified from Source)

### Pattern 1: Single Orchestrator with Subagent Fan-Out

Used by `/seo audit`. The main `seo/SKILL.md` routes to `seo-audit/SKILL.md`, which spawns 6 parallel agents.

```
User: /seo audit https://example.com
    → seo/SKILL.md (routes to seo-audit sub-skill)
    → seo-audit/SKILL.md (spawns agents in parallel)
        ├── seo-technical agent   ─┐
        ├── seo-content agent     ─┤
        ├── seo-schema agent      ─┼─ run concurrently
        ├── seo-sitemap agent     ─┤
        ├── seo-performance agent ─┤
        └── seo-visual agent      ─┘
    → Aggregate results
    → Generate unified report
```

**Implementation in SKILL.md:**
```markdown
## Process

4. **Delegate to subagents** (if available, otherwise run inline sequentially):
   - `seo-technical` — robots.txt, sitemaps, canonicals, Core Web Vitals, security headers
   - `seo-content` — E-E-A-T, readability, thin content, AI citation readiness
   - `seo-schema` — detection, validation, generation recommendations
   - `seo-sitemap` — structure analysis, quality gates, missing pages
   - `seo-performance` — LCP, INP, CLS measurements
   - `seo-visual` — screenshots, mobile testing, above-fold analysis
```

The parenthetical `(if available, otherwise run inline sequentially)` is important — it makes the skill degrade gracefully if subagent spawning is not possible.

### Pattern 2: Orchestrator Routes to Sub-Skill

Used by all individual commands. The main skill parses the subcommand and delegates.

```
User: /seo technical https://example.com
    → seo/SKILL.md (routes to seo-technical sub-skill)
    → seo-technical/SKILL.md (handles directly, no agents)
```

**Implementation in seo/SKILL.md:**
```markdown
## Orchestration Logic

When the user invokes `/seo audit`, delegate to subagents in parallel:
1. Detect business type...
2. Spawn subagents: seo-technical, seo-content, seo-schema, seo-sitemap, seo-performance, seo-visual
3. Collect results and generate unified report

For individual commands, load the relevant sub-skill directly.
```

### Pattern 3: Reference File On-Demand Loading

Reference files contain static data (thresholds, rules, deprecated types). They are NOT loaded at startup — loaded only when needed to keep the main skill concise.

```markdown
## Reference Files

Load these on-demand as needed — do NOT load all at startup:
- `references/cwv-thresholds.md` — Current Core Web Vitals thresholds
- `references/schema-types.md` — All supported schema types with deprecation status
- `references/eeat-framework.md` — E-E-A-T evaluation criteria
- `references/quality-gates.md` — Content length minimums, uniqueness thresholds
```

**Why this matters:** Claude Code has a context window. Loading 10 reference files at startup wastes tokens. Load inline only when the specific check is needed.

---

## Recommended File Structure for New Skills

For each new `/seo {command}` skill, create:

```
~/.claude/skills/seo-{command}/
└── SKILL.md           # Required. Frontmatter + instructions.
```

Optional additions based on command complexity:
```
~/.claude/skills/seo-{command}/
├── SKILL.md
├── references/        # Static data (rules, thresholds, lookup tables)
│   └── {topic}.md
└── assets/            # Templates, examples, config
    └── {template}.md
```

For agents supporting complex commands (parallel workers):
```
~/.claude/agents/seo-{function}.md   # Specialized parallel worker
```

---

## Command Routing Architecture

All commands route through the main `seo/SKILL.md` orchestrator. The main skill must list every subcommand in its description and routing table.

```markdown
# SEO — Universal SEO Analysis Skill

## Quick Reference

| Command | What it does |
|---------|-------------|
| `/seo audit <url>` | Full website audit with parallel subagent delegation |
| `/seo gsc <command> <site>` | Live GSC data analysis |
| `/seo ahrefs <command> <domain>` | Live Ahrefs analysis |
...

## Orchestration Logic

When the user invokes `/seo gsc`, load the `seo-gsc` sub-skill.
When the user invokes `/seo ahrefs`, load the `seo-ahrefs` sub-skill.
...
```

**Rule:** Every new `/seo {command}` must be:
1. Registered in `seo/SKILL.md`'s Quick Reference table
2. Added to the Orchestration Logic routing section
3. Added to the `description` frontmatter of `seo/SKILL.md` (so Claude knows when to activate the skill)

---

## Supporting Technologies

### Python Scripts (Optional Helpers)

The original codebase uses Python scripts for tasks that require more than Claude's built-in tools:

```
~/.claude/skills/seo/scripts/
├── fetch_page.py         # HTTP fetch + HTML parsing
├── parse_html.py         # DOM analysis, link extraction
├── capture_screenshot.py # Playwright browser automation
└── analyze_visual.py     # Image analysis helpers
```

**When to use Python scripts vs Claude's Bash tool:**
- Use Python scripts for: HTML parsing, regex processing, file format handling (CSV, log files)
- Use Claude's Bash tool directly for: curl calls, file operations, command-line tools
- Never use Python for: API calls to MCPs (those go through Claude's tool use)

**Python version:** 3.8+ required. Install via venv at `~/.claude/skills/seo/.venv/`

**Requirements managed at:** `~/.claude/skills/seo/requirements.txt`

Current dependencies from the reference repo:
```
requests>=2.31.0
beautifulsoup4>=4.12.0
lxml>=4.9.0
playwright>=1.40.0  # Optional, for screenshots
```

### No Node.js / No Build Step

Skills are pure Markdown. There is no `package.json`, no TypeScript, no compilation. The MCP servers themselves (Ahrefs `@ahrefs/mcp`, GSC `mcp-server-gsc`) run as separate Node.js processes configured in `~/.claude/claude.json`, but skill files do not interact with them at the code level.

---

## Installation & Deployment

### Where Skills Live

Skills install to the user's global Claude config directory, not to any project directory:

```
~/.claude/skills/{skill-name}/SKILL.md     # Skills
~/.claude/agents/{agent-name}.md           # Agents
```

This means skills are available across ALL projects, not just the SEO project directory.

### Install Script Pattern (from reference repo)

The reference repo uses `install.sh` which:
1. Creates `~/.claude/skills/seo/` directory
2. Copies `seo/` contents → `~/.claude/skills/seo/`
3. Copies each `skills/{name}/` → `~/.claude/skills/{name}/`
4. Copies `agents/*.md` → `~/.claude/agents/`
5. Installs Python deps into `~/.claude/skills/seo/.venv/`

For the new expanded skill set, the install script must cover all 27 commands.

### Project Repo Structure (What to Build)

The SEO project repository (`/Users/aash-zsbch1500/Desktop/Github projects/SEO/`) should mirror the reference repo:

```
/SEO/
├── seo/                      # Main orchestrator skill source
│   ├── SKILL.md
│   └── references/
├── skills/                   # Sub-skill sources
│   ├── seo-gsc/
│   │   └── SKILL.md
│   ├── seo-ahrefs/
│   │   └── SKILL.md
│   ├── seo-markdown-audit/
│   │   └── SKILL.md
│   ├── seo-serp/
│   │   └── SKILL.md
│   ├── seo-content-brief/
│   │   └── SKILL.md
│   ├── seo-brand-radar/
│   │   └── SKILL.md
│   ├── seo-site-audit-pro/
│   │   └── SKILL.md
│   ├── seo-report/
│   │   └── SKILL.md
│   ├── seo-internal-links/
│   │   └── SKILL.md
│   ├── seo-ai-content-check/
│   │   └── SKILL.md
│   ├── seo-log-analysis/
│   │   └── SKILL.md
│   ├── seo-local/
│   │   └── SKILL.md
│   ├── seo-migration-check/
│   │   └── SKILL.md
│   ├── seo-competitor-monitor/
│   │   └── SKILL.md
│   ├── seo-ads-intel/
│   │   └── SKILL.md
│   # ... plus enhanced versions of all 12 original skills
├── agents/                   # Agent sources
│   ├── seo-gsc-analyst.md   # New agent for GSC parallel work
│   ├── seo-ahrefs-analyst.md # New agent for Ahrefs parallel work
│   └── ... (existing 6 agents)
├── scripts/                  # Python helpers
├── install.sh
├── install.ps1               # Windows
└── uninstall.sh
```

---

## What NOT to Do

### Anti-Pattern 1: Building a CLI Tool

**Wrong:** Creating a Python CLI (`seo_tool.py`) that calls APIs and outputs text.
**Why wrong:** Bypasses Claude's tool use entirely. No AI reasoning, no context awareness, no MCP integration.
**Right:** Write SKILL.md with instructions. Claude IS the execution engine.

### Anti-Pattern 2: Hardcoding MCP Tool Names

**Wrong:**
```markdown
Call `mcp__ahrefs__get_domain_overview` with parameter `target: {domain}`.
```
**Why wrong:** MCP tool names can change between versions. The skill becomes brittle.
**Right:** Describe what you need in natural language. Claude resolves the right tool:
```markdown
Use the Ahrefs MCP to get the domain overview for {domain}.
```

### Anti-Pattern 3: Loading All Reference Files at Startup

**Wrong:**
```markdown
## Setup
Read all files in references/ before beginning analysis.
```
**Why wrong:** Wastes context window tokens on data that may never be needed.
**Right:**
```markdown
## Reference Files
Load these on-demand as needed — do NOT load all at startup:
- `references/schema-types.md` — Load when doing schema analysis
- `references/cwv-thresholds.md` — Load when evaluating Core Web Vitals
```

### Anti-Pattern 4: Monolithic SKILL.md

**Wrong:** One giant SKILL.md with instructions for all 27 commands (>500 lines).
**Why wrong:** Claude loads the entire file into context for every invocation, even simple ones.
**Right:** Main `seo/SKILL.md` stays under 200 lines. Route to sub-skill files. Each sub-skill has only its own instructions.

### Anti-Pattern 5: Agents Without Tools Declaration

**Wrong:** Agent frontmatter with no `tools` field, or with all tools listed.
**Why wrong:** Agents should have the minimal tools they need. Overly permissive agents can take unintended actions.
**Right:** Declare only the tools needed:
```yaml
---
name: seo-gsc-analyst
description: Pulls and analyzes Google Search Console data for SEO insights.
tools: Read, Write
---
```
(A GSC analyst doesn't need Bash or Glob — just Read for context and Write to produce output.)

### Anti-Pattern 6: Forgetting the Orchestrator Update

**Wrong:** Building `seo-gsc/SKILL.md` without updating `seo/SKILL.md`.
**Why wrong:** The new command will never be discoverable. Users typing `/seo gsc` will get nothing.
**Right:** Every new sub-skill requires three updates to `seo/SKILL.md`:
1. Add row to Quick Reference table
2. Add routing rule in Orchestration Logic
3. Add trigger phrase to `description` frontmatter

---

## Confidence Assessment

| Area | Confidence | Source |
|------|------------|--------|
| Skill file format (SKILL.md structure) | HIGH | Direct code inspection of installed skills |
| Agent file format | HIGH | Direct code inspection of 6 installed agents |
| Installation paths (`~/.claude/skills/`, `~/.claude/agents/`) | HIGH | install.sh + confirmed installed files |
| MCP integration pattern (natural language calls) | HIGH | Architecture doc + README + MCP-INTEGRATION.md |
| Ahrefs MCP capabilities | MEDIUM | MCP-INTEGRATION.md + Ahrefs official launch announcement (July 2025) |
| GSC MCP capabilities | MEDIUM | MCP-INTEGRATION.md references `mcp-server-gsc` by ahonn |
| Subagent parallelism pattern | HIGH | ARCHITECTURE.md + seo-audit SKILL.md inline docs |
| Python scripts as helpers | HIGH | scripts/ directory + install.sh venv setup |
| Tool restriction via frontmatter | HIGH | All 6 agent files confirm this pattern |

---

## Sources

- Direct inspection: `/Users/aash-zsbch1500/Desktop/Github projects/claude-seo-main/` (reference repo, Feb 2026)
- Direct inspection: `/Users/aash-zsbch1500/.claude/skills/seo/` (installed skills, confirmed Feb 2026)
- Direct inspection: `/Users/aash-zsbch1500/.claude/agents/seo-*.md` (installed agents, confirmed Feb 2026)
- `docs/ARCHITECTURE.md` in reference repo — canonical architecture description
- `docs/MCP-INTEGRATION.md` in reference repo — MCP setup and official server list
- `install.sh` — installation paths and deployment approach
- `README.md` — official Ahrefs MCP (`@ahrefs/mcp`) launch confirmation (July 2025)
