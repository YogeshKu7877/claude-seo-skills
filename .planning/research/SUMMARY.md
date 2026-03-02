# Project Research Summary

**Project:** Claude Code SEO Skill Expansion (27 commands)
**Domain:** AI-powered SEO analysis — Claude Code skill system with Ahrefs MCP + GSC MCP integration
**Researched:** 2026-03-02
**Confidence:** HIGH (stack, architecture, pitfalls verified against source code; features MEDIUM-HIGH)

## Executive Summary

This project expands an existing 12-command Claude Code SEO skill system (`claude-seo`) to 27 commands by integrating live Ahrefs API and Google Search Console data via MCP. The existing tool is already proven — it uses a two-tier Markdown-file architecture where `SKILL.md` files define behavior and subagents handle parallel analysis — but it has a critical gap: every metric is estimated from static HTML crawls with zero live data. Adding Ahrefs MCP and GSC MCP closes that gap and unlocks the primary differentiator: cross-MCP synthesis that no web dashboard can replicate natively (e.g., "You rank #8 for X with 5,000 impressions and 2% CTR — you need 150 more quality backlinks to compete").

The recommended approach is to extend, not reinvent. The reference implementation establishes all the right patterns — single orchestrator routing through sub-skills, parallel agents with isolated context, lazy-loaded reference files, graceful MCP degradation. The 15 new commands should follow these patterns exactly. Build in strict tier order: validate 5 core live-data commands before touching the flagship `seo-site-audit-pro` or any niche commands. The biggest risk is scope creep across all 27 commands producing shallow implementations that nobody uses.

Two confirmed Claude Code bugs demand immediate attention before writing any skill files. First, custom subagents cannot call MCP tools when those MCPs are configured at project scope (they silently hallucinate instead of failing). All MCPs must be registered at user scope (`~/.claude/mcp.json`). Second, parallel subagents share an AbortController, so a single API rate-limit error kills all sibling agents simultaneously. The `seo-site-audit-pro` architecture must cap parallel agents at 3-4 and implement checkpoint saves to temp files before any aggregation step.

## Key Findings

### Recommended Stack

Skills are Markdown files with YAML frontmatter — no build step, no compiled code, no dependencies to install for skill logic. Claude Code resolves the skill at invocation time and reads the instructions. Agents follow the same format but live in `~/.claude/agents/` and run with isolated context. MCP tools are referenced in natural language ("Use the Ahrefs MCP to fetch domain overview for {domain}") — no import statements or API client code.

**Core technologies:**
- **SKILL.md files** — the execution format for all 27 commands; frontmatter activates skills, body defines behavior
- **Agent .md files** — parallel workers for complex audits; declared tools restrict what each agent can do
- **Ahrefs MCP (`@ahrefs/mcp`)** — live backlink, keyword, SERP, competitor, and Brand Radar data; remote-hosted (NOT the archived local server)
- **GSC MCP (`mcp-server-gsc`)** — real search performance data: clicks, impressions, CTR, position, index coverage
- **Python 3.8+ scripts** — HTML parsing, screenshot capture via Playwright, log file parsing; optional helpers, not the core engine
- **`seo/SKILL.md` orchestrator** — single entry point routing all 27 commands; must stay under 200 lines

**Critical format rules:**
- Skill `name`: max 64 chars, lowercase/hyphens only, no reserved words ("anthropic", "claude")
- Skill `description`: max 1024 chars, third person ("Analyzes..."), includes activation trigger phrases
- No content before the opening `---` YAML delimiter
- Every new sub-skill requires three updates to the main orchestrator: Quick Reference table row, routing rule, and description trigger phrase

### Expected Features

The existing 12 static-analysis commands carry forward enhanced. The 15 new commands add live data.

**Must have (table stakes):**
- Real keyword rankings and organic traffic data via Ahrefs MCP — without this, the tool is inferior to any free alternative
- Actual search performance (clicks, impressions, CTR, position) via GSC MCP — this is the single biggest upgrade over the current tool
- Indexing status and coverage issues via GSC — critical for any site audit
- Backlink profile (count, referring domains, DR) via Ahrefs — Ahrefs invented DR; users expect it
- Competitor identification and content gap analysis — every professional SEO workflow includes this
- Traffic drop detection and keyword cannibalization — two highest-demand GSC analysis types
- Markdown pre-publish audit (`seo-markdown-audit`) — no MCP required, zero alternatives in CLI tools

**Should have (competitive differentiators):**
- AI brand visibility monitoring via Ahrefs Brand Radar — the 2026 GEO metric; traditional tools don't surface this in-workflow
- Content brief generation from live SERP data — combines Ahrefs SERP + GSC internal link data; keeps the workflow inside Claude
- `seo-site-audit-pro` flagship — 10+ parallel agents, cross-MCP synthesis, 30/60/90-day action plan; nothing equivalent exists in web tools
- Content decay detection — GSC 90-day comparison with Ahrefs context; actionable prioritization
- Internal link graph with orphan page detection — generates specific links with copy-pasteable anchor text
- Server log analysis for crawl budget — local file parsing, differentiates for technical SEO specialists
- Automated reporting pipeline — markdown output with AI-generated insights layered on data

**Defer (v2+):**
- Automated competitor monitoring as set-and-forget (requires n8n, deferred per PROJECT.md)
- PPTX, Google Docs, PDF output (requires unintegrated MCPs)
- Scheduled automated reports (requires persistent process)
- `seo-ads-intel` (Google Ads Transparency MCP — conflicting connection status, verify before building)
- `seo-local` (no native MCP for Google Business Profile data, lowest-priority use case)

### Architecture Approach

Adopt the reference implementation's architecture wholesale, then extend for MCP layers. The system is a four-tier hierarchy: (1) single `seo/SKILL.md` orchestrator routes all commands and stays under 200 lines; (2) sub-skill SKILL.md files implement one command each; (3) agents handle parallel background work and write to named temp files to avoid race conditions; (4) shared reference files in `seo/references/` are loaded lazily, never at startup. New commands that require only one MCP follow Pattern B (check availability, call MCP, fall back gracefully). `seo-site-audit-pro` follows Pattern C (multi-MCP with sequential agent waves, not full parallel).

**Major components:**
1. **`seo/SKILL.md` orchestrator** — routes all 27 commands, lists Quick Reference table, must be updated for every new sub-skill
2. **Sub-skill SKILL.md files** — one per command domain; contains the analysis logic, sub-command parsing, and MCP instructions
3. **Specialist agents** — 6 existing + 3 new (`seo-ahrefs-analyst`, `seo-gsc-analyst`, `seo-competitor-analyst`); parallel workers with `tools` restricted to minimum needed
4. **Reference files** — shared constants (CWV thresholds, E-E-A-T framework, schema types, Ahrefs API reference, GSC API reference); loaded on-demand only
5. **Python scripts** — `fetch_page.py`, `parse_html.py`, `capture_screenshot.py`, `parse_log.py`; called via Bash from agents

### Critical Pitfalls

1. **Custom subagents hallucinate when MCP is project-scoped** — Confirmed Claude Code bug (Issue #13898). Custom agents in `.claude/agents/` cannot reach project-level MCP servers; they silently return fabricated data instead of failing. Prevention: register all MCPs at user scope (`claude mcp add --scope user`). Validate before any subagent+MCP build.

2. **Parallel agent cascade termination** — Confirmed bug (Issue #6594). Shared `AbortController` means a single Ahrefs 429 rate-limit kills all sibling agents simultaneously. Prevention: cap parallel agents at 3-4; structure `site-audit-pro` in sequential waves; save each agent result to a temp file immediately on completion.

3. **Ahrefs API unit blowout** — 50 units minimum per query; multi-call skills can exhaust monthly budgets in days. Prevention: default all heavy commands to `--lite` mode; cache results 24 hours; display estimated cost before executing heavy queries.

4. **GSC quota exceeded mid-execution** — 1,200 QPM per-site limit; grouping page+query in a single call is the most expensive pattern. Prevention: separate page queries from keyword queries; cache 24 hours; exponential backoff on 403 responses.

5. **YAML frontmatter validation failures silently break skills** — The source project shipped with 8 broken SKILL.md files. The loader silently skips invalid files with no error output. Prevention: build a frontmatter validation script as a pre-commit hook before writing any skill files; enforce it across all 27 commands.

## Implications for Roadmap

Based on combined research, a four-phase build order follows dependency direction and risk management.

### Phase 0: Foundation and Infrastructure
**Rationale:** Nothing else works without this. The MCP scoping bug (Pitfall 1), the YAML validation failure mode (Pitfall 5), the Ahrefs monetary formatting bug (Pitfall 12), and the subagent prompt template (Pitfall 8) must all be addressed before the first command is written. This phase produces no user-visible features but prevents catastrophic failures in all subsequent phases.
**Delivers:** Updated `seo/SKILL.md` orchestrator with extended routing table; YAML validation script wired as pre-commit hook; shared reference files including `ahrefs-api-reference.md` and `gsc-api-reference.md`; standard subagent prompt template; confirmed user-scope MCP registration for Ahrefs and GSC; MCP connectivity validation test
**Addresses:** Pitfalls 1, 3, 4, 5, 8, 12, 13, 14
**Avoids:** Any command being built on unvalidated infrastructure

### Phase 1: Core Live Data Commands (Tier 1)
**Rationale:** These five commands deliver the highest delta vs the existing static tool. GSC and Ahrefs are confirmed connected. Each command is low-complexity and has no cross-dependencies, so they validate the MCP integration patterns before anything complex is built.
**Delivers:** `seo-gsc` with `overview`, `drops`, `opportunities`, `content-decay`, `cannibalization` sub-commands; `seo-ahrefs` with `overview`, `backlinks`, `keywords`, `competitors`, `content-gap` sub-commands; `seo-markdown-audit` (no MCP, immediate value for content teams); `seo-gsc-analyst` and `seo-ahrefs-analyst` agents
**Addresses:** All table-stakes features (keyword data, traffic data, backlink profile, search performance, content gap)
**Avoids:** Pitfalls 3, 4 (caching layer and lite-mode defaults established here); Pitfall 9 (GSC disclaimer blocks built into all GSC commands from the start)
**Research Flag:** Needs research-phase for GSC MCP property format (`sc-domain:` vs `https://`) and Ahrefs API unit cost per endpoint before implementation

### Phase 2: Differentiating Commands (Tier 2)
**Rationale:** These commands require Phase 1 infrastructure to be stable. `seo-content-brief` requires both Ahrefs SERP data and GSC internal link data. `seo-site-audit-pro` requires all Tier 1 MCP analysts. `seo-brand-radar` requires Ahrefs Brand Radar endpoint verification.
**Delivers:** `seo-serp`, `seo-content-brief`, `seo-brand-radar`, `seo-report`; `seo-site-audit-pro` built with sequential wave architecture (not fully parallel), checkpoint saves, 3-4 agent cap per wave
**Addresses:** Cross-MCP synthesis differentiator; AI brand visibility; content brief workflow; flagship audit
**Avoids:** Pitfall 2 (cascade termination — sequential waves + checkpoint pattern required); Pitfall 7 (strict SKILL.md size limits)
**Research Flag:** Needs research-phase for `seo-site-audit-pro` agent orchestration design before implementation; verify Ahrefs Brand Radar endpoint name and response schema before `seo-brand-radar`

### Phase 3: Enhanced Originals + MCP-Independent Commands (Tier 3)
**Rationale:** The 12 original skills are functional but built on static analysis only. Enhancing them with GSC/Ahrefs overlay adds value without new architecture risk. The MCP-independent new commands (`seo-log-analysis`, `seo-ai-content-check`, `seo-internal-links`, `seo-migration-check`) can be built in parallel with Phase 2 if capacity allows since they have no MCP dependencies.
**Delivers:** Enhanced `seo-audit`, `seo-technical`, `seo-content`, `seo-schema`, `seo-geo`, `seo-page`; new `seo-log-analysis`, `seo-ai-content-check`, `seo-internal-links`, `seo-migration-check`
**Addresses:** Technical SEO depth, E-E-A-T analysis, crawl budget optimization, content authenticity, internal link graph
**Avoids:** Pitfall 5 (duplication of reference data — all shared data lives in `seo/references/`)
**Research Flag:** Standard patterns for enhanced originals (copy-extend from reference repo, no deep research needed); `seo-internal-links` link graph construction may need research-phase

### Phase 4: Niche Commands (Tier 3 Remainder, Deferred)
**Rationale:** These commands have the narrowest use cases and the least MCP leverage. `seo-local` requires Google Business Profile data unavailable via current MCPs. `seo-competitor-monitor` requires n8n automation infrastructure explicitly deferred per PROJECT.md. `seo-ads-intel` has conflicting connection status — verify Ads Transparency MCP before committing to build.
**Delivers:** `seo-local`, `seo-competitor-monitor` (on-demand only, no automation), `seo-ads-intel` (conditional on MCP verification)
**Defer indefinitely:** Automated scheduling, non-markdown output formats, competitor monitoring automation
**Research Flag:** Verify Google Ads Transparency MCP actual connection status before starting `seo-ads-intel`

### Phase Ordering Rationale

- Phase 0 before everything: the MCP scoping bug is silent and catastrophic — discovering it in Phase 3 would require rewriting all MCP calls
- Phase 1 before Phase 2: `seo-site-audit-pro` aggregates results from all `seo-gsc` and `seo-ahrefs` analysts; those must be stable first
- Tier ordering within phases: feature dependency graph in FEATURES.md shows `seo-gsc overview` must precede `drops`, `opportunities`, `content-decay`, and `cannibalization`; `seo-ahrefs overview` must precede `backlinks`, `keywords`, `competitors`, and `content-gap`
- Enhanced originals in Phase 3, not Phase 1: they work today; getting live data skills right is higher priority than polish on existing functionality

### Research Flags

Phases needing deeper research during planning:
- **Phase 1 — GSC MCP:** Verify property format requirement (`sc-domain:example.com` vs `https://example.com`); test actual rate limit behavior on first call
- **Phase 1 — Ahrefs MCP:** Verify actual API unit cost per endpoint; confirm Brand Radar endpoint is available on the plan in use
- **Phase 2 — `seo-site-audit-pro`:** Research checkpoint/partial-save orchestration pattern for sequential agent waves before implementation

Phases with standard patterns (skip research-phase):
- **Phase 0:** Established pattern from reference repo; no novel decisions
- **Phase 3 enhanced originals:** Copy-extend from reference implementation; patterns are documented
- **Phase 3 MCP-independent commands:** Local file parsing and text analysis are standard; no external API uncertainty

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | Direct code inspection of reference repo + installed skills; YAML spec verified from official Anthropic docs |
| Features | MEDIUM-HIGH | Existing tool read directly; table stakes verified against Ahrefs/GSC official docs; differentiators and complexity estimates are projections |
| Architecture | HIGH | Direct inspection of 12 sub-skills + 6 agents + install.sh; patterns confirmed working in production |
| Pitfalls | HIGH | Two bugs confirmed via GitHub issues with repros; GSC/Ahrefs quotas from official docs; YAML failures from project's own TODO.md |

**Overall confidence:** HIGH for build approach; MEDIUM for MCP-specific implementation details (actual endpoint names and rate-limit behaviors require first-call validation)

### Gaps to Address

- **WebMCP connection status conflict:** PROJECT.md says "not connected yet" but seo-skill-expansion.md marks it connected. Resolve before building `seo-serp`, `seo-content-brief`, `seo-internal-links`, or `seo-ai-content-check`. Design all four with graceful degradation to Ahrefs-only data.

- **Google Ads Transparency MCP conflict:** Same contradiction as WebMCP. Do not begin `seo-ads-intel` until actual connection status is confirmed. If not connected, move to v2 scope.

- **Ahrefs Brand Radar endpoint:** Existence confirmed via web search but actual MCP tool name and response schema unverified. Validate against live MCP before building `seo-brand-radar`.

- **GSC MCP property format:** Unknown whether the connected MCP accepts `sc-domain:example.com` or `https://example.com` format. All `seo-gsc` commands depend on this. Test as first action in Phase 1.

- **Ahrefs API unit budget:** Monthly unit allocation on the plan in use is unknown. This determines how aggressive `seo-site-audit-pro` can be with API calls. Check Ahrefs account before designing the flagship audit.

## Sources

### Primary (HIGH confidence)
- Direct inspection: `/Users/aash-zsbch1500/Desktop/Github projects/claude-seo-main/` — skill files, agents, install.sh, ARCHITECTURE.md, MCP-INTEGRATION.md
- Direct inspection: `~/.claude/skills/seo/` and `~/.claude/agents/seo-*.md` — confirmed installed files
- GitHub Issue #13898 — Custom subagents + project-scoped MCP hallucination bug (open, confirmed repro)
- GitHub Issue #6594 — Subagent cascade termination via shared AbortController (confirmed root cause)
- Anthropic Official Skill Best Practices — YAML validation rules, 500-line limit, third-person descriptions
- Google Search Console API Usage Limits — 1,200 QPM, 2,000 QPD URL inspection, 16-month retention
- Project spec: `/Users/aash-zsbch1500/Desktop/Github projects/SEO/.planning/PROJECT.md`
- Expansion spec: `/Users/aash-zsbch1500/Desktop/Github projects/SEO/seo-skill-expansion.md`

### Secondary (MEDIUM confidence)
- Ahrefs API v3 Documentation — endpoint list, 50-unit minimum, monetary values in cents
- Ahrefs MCP official launch announcement (July 2025) — confirmed remote MCP server, plan availability
- Google Search Console API overview — quota structure, filtering patterns
- claude-seo TODO.md — historical bugs including 8 files with YAML frontmatter errors

### Tertiary (LOW confidence)
- Industry blogs on SEO tool feature sets (searchseo.io, searchinfluence.com, seotesting.com) — used only to validate table-stakes feature list, not architectural decisions
- SFEIR Institute article on Claude Code command adoption — scope creep warning supported by this but not sole basis

---
*Research completed: 2026-03-02*
*Ready for roadmap: yes*
