# Phase 3: Cross-MCP & Differentiating — Research

**Researched:** 2026-03-02
**Domain:** Claude Code skill authoring, multi-agent orchestration, cross-MCP data synthesis, Ahrefs SERP/Brand Radar APIs, file-based report generation
**Confidence:** HIGH for patterns and established conventions; MEDIUM for Ahrefs Brand Radar endpoint schema (tool name known, response schema unverified live); LOW for WebMCP availability

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| CROSS-01 | `/seo serp <keyword>` — Live SERP analysis using Ahrefs SERP Overview + WebMCP crawling | Ahrefs `serp-overview` tool (deferred tool list confirms `mcp__claude_ai_ahrefs__serp-overview`); WebMCP check pattern from mcp-degradation.md; Ahrefs-only fallback mode if WebMCP unavailable |
| CROSS-02 | `/seo content-brief <keyword>` — AI content brief from SERP analysis + optional GSC overlay | Calls `seo-serp` logic first, then optional GSC query for existing rankings; structured brief template with H2 sections, word count target, semantic keywords |
| CROSS-03 | `/seo brand-radar <brand>` — AI search brand monitoring via Ahrefs Brand Radar | `mcp__claude_ai_ahrefs__brand-radar-mentions-overview` (confirmed in ahrefs-api-reference.md); multiple brand-radar tools listed in deferred tool set; no fallback — must return clear error if unavailable |
| CROSS-04 | `/seo site-audit-pro <domain>` — Flagship multi-agent sequential wave audit with rate-limit resilience | Sequential wave architecture (STATE.md decision); 3-4 agent cap per wave; checkpoint saves to disk; cross-MCP synthesis section; each agent runs independently and reports partial results on failure |
| CROSS-05 | `/seo report <type> <domain>` — Automated markdown report file saved to disk | Write tool to save report; AI narrative layer on top of raw data; 4 report types (monthly, weekly, audit, competitor); output filename convention (e.g., `seo-report-YYYY-MM-DD-domain-type.md`) |
</phase_requirements>

---

## Summary

Phase 3 builds five new sub-skill directories that synthesize data from multiple MCPs in ways that no single-source command can replicate. The three simpler commands (serp, content-brief, brand-radar) follow the flat SKILL.md pattern from Phase 2 directly. The two complex commands (site-audit-pro, report) require new patterns not yet established in the project.

The most critical architectural decision for this phase is the sequential wave architecture for `seo-site-audit-pro`. STATE.md explicitly records this decision with a GitHub Issue reference (#6594 — shared AbortController cascade termination). The implementation must use independently-run agents in sequential waves (not parallel), with each wave's results checkpointed to a file before the next wave starts. This ensures rate-limit errors on one agent do not abort the entire audit.

The `seo-report` command introduces file persistence to the project for the first time. All prior skills output to terminal only. The Write tool (already in the project's allowed-tools set) handles this. The report generator must template four report types and layer AI narrative interpretation on top of raw MCP data gathered by calling other skills' logic inline.

WebMCP availability is the key unknown: PROJECT.md says "not connected" but the expansion spec marks it connected. The `seo-serp` command must be designed with Ahrefs-only as the primary mode (WebMCP enrichment as optional overlay), not the reverse. This is the safest architecture given the conflicting signals.

**Primary recommendation:** Build in this order: (1) `seo-serp` to establish the Ahrefs-SERP tool pattern, (2) `seo-content-brief` which depends on serp logic, (3) `seo-brand-radar` as a simple single-tool skill, (4) `seo-report` for the report templating pattern, (5) `seo-site-audit-pro` last because it depends on all other skills working and has the highest architectural complexity.

---

## Standard Stack

### Core

| Component | Source | Purpose | Why Standard |
|-----------|--------|---------|--------------|
| Claude Code skill SKILL.md | Phase 1/2 pattern | Defines command behavior, routing trigger, MCP check | Established pattern; all 32 active sub-skills use this |
| Ahrefs MCP | `mcp__claude_ai_ahrefs__*` prefix | SERP data, Brand Radar data, competitor data | Already verified working in Phase 2 |
| GSC MCP | ToolSearch `+google-search-console` | Optional GSC data overlay for content-brief | Verified tools in Phase 2; alias unknown until runtime |
| Write tool | Claude built-in | Save reports to disk for CROSS-05 | Required for file persistence; already approved in agent patterns |
| ToolSearch | Claude built-in | Runtime MCP availability detection | Established pattern from Phase 2 for all MCP checks |
| `references/mcp-degradation.md` | Phase 1 artifact | Error templates, fallback patterns, WebMCP check pattern | All MCP-dependent skills @-reference this |
| `references/ahrefs-api-reference.md` | Phase 1 artifact (must be updated) | Tool-to-subcommand map; add brand-radar and SERP tools | Must add Phase 3 tool mappings before building sub-skills |

### Supporting

| Component | Purpose | When to Use |
|-----------|---------|-------------|
| `references/gsc-api-reference.md` | GSC tool names for content-brief GSC overlay | content-brief only when GSC site parameter provided |
| Bash tool | Date arithmetic, report filename generation | site-audit-pro wave timing, report filename with date |
| Read tool | Load reference files on-demand | All skills — established pattern |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Sequential wave architecture (site-audit-pro) | Parallel agents | Parallel agents fail cascade when any hits rate limit (GitHub Issue #6594) — sequential is the locked decision |
| File-based checkpoint saves | In-memory state | Claude Code has no session persistence; files survive between agent handoffs |
| Ahrefs-only fallback for serp | Require WebMCP | WebMCP availability unconfirmed; Ahrefs SERP data alone is viable output |
| 4 separate report type skills | Single report skill with type routing | Single skill with type parameter follows the existing pattern and keeps routing simple |

---

## Architecture Patterns

### Recommended Project Structure

```
skills/
├── seo-serp/
│   └── SKILL.md          # SERP analysis via Ahrefs serp-overview + optional WebMCP
├── seo-content-brief/
│   └── SKILL.md          # Content brief using serp analysis + optional GSC overlay
├── seo-brand-radar/
│   └── SKILL.md          # Brand Radar via Ahrefs brand-radar-* tools
├── seo-report/
│   └── SKILL.md          # Report generation with 4 type templates, saves to disk
└── seo-site-audit-pro/
    └── SKILL.md          # Sequential wave multi-agent audit with checkpoint saves
```

All 5 directories already appear in the routing table in `seo/SKILL.md` with Phase 3 status. No routing table update needed — just building the sub-skill directories activates them.

### Pattern 1: Single-Ahrefs Cross-MCP Skill (serp, brand-radar)

**What:** Standard Phase 2 pattern extended with a second optional MCP (WebMCP for serp) or single Ahrefs Brand Radar endpoint (brand-radar)
**When to use:** Commands that have one primary MCP data source and one optional enrichment source

```markdown
---
name: seo-serp
description: >
  Live SERP analysis for a keyword using Ahrefs SERP Overview data. Shows
  ranking pages with their Domain Rating and estimated traffic. Use when user
  says "SERP analysis", "who ranks for", "SERP breakdown", "competitors ranking
  for keyword", or "serp overview for".
allowed-tools:
  - Read
  - Bash
  - ToolSearch
  - Write
---

# SERP Analysis

@skills/seo/references/mcp-degradation.md
@skills/seo/references/ahrefs-api-reference.md

## MCP Check

1. Use ToolSearch with query `+ahrefs`
   - Tools returned → proceed with Ahrefs SERP data (primary mode)
   - No tools → display Ahrefs error template from mcp-degradation.md, stop

2. Use ToolSearch with query `+webmcp` (secondary check, non-blocking)
   - Tools returned → note WebMCP available for page crawl enrichment
   - No tools → note "Running Ahrefs-only mode" and proceed without WebMCP

## Inputs
- `keyword`: The search query to analyze (e.g., "best CRM software")

## Execution

**Step 1 — Ahrefs SERP Overview:**
Call `mcp__claude_ai_ahrefs__serp-overview` with:
- `keyword`: the keyword param (exact query string)

Returns: top ranking URLs, their DR, estimated organic traffic, referring domains

**Step 2 — WebMCP Enrichment (if available):**
For top 3-5 results only, use WebMCP to fetch page titles and H1s for content angle analysis.
If WebMCP unavailable, skip this step entirely.

## Output Format
[structured SERP table + insights]
```

### Pattern 2: Cross-MCP Synthesis Skill (content-brief)

**What:** Calls Ahrefs SERP data first, then optionally overlays GSC data to show existing rankings, producing a synthesized actionable output
**When to use:** Commands where two data sources together produce output neither source alone enables

```markdown
## Inputs
- `keyword`: The target keyword for the content brief
- `site` (optional): GSC property URL to overlay existing GSC ranking data

## Execution

**Step 1 — SERP Analysis (always):**
Run the same logic as seo-serp (do NOT call seo-serp as a sub-skill; inline the logic)
to get the competitive landscape.

**Step 2 — GSC Overlay (if site provided):**
If user provided `site` parameter:
  1. ToolSearch `+google-search-console` to verify GSC available
  2. If available: call `query_search_analytics` for `keyword` to check if site ranks
  3. If unavailable: note "GSC data unavailable — brief generated from SERP data only"

**Step 3 — Generate Brief:**
Synthesize SERP findings + GSC position (if available) into structured brief
```

**Why inline serp logic instead of calling seo-serp:** Claude Code skills cannot call each other as sub-routines. The content-brief SKILL.md must repeat the serp API call logic inline. Reference the same reference files for consistency.

### Pattern 3: Single-Endpoint Brand Radar Skill

**What:** Simple single-tool call with mandatory Ahrefs dependency and no fallback
**When to use:** Commands where the tool IS the data source with no viable substitute

```markdown
## MCP Check

1. Use ToolSearch with query `+ahrefs`
   - Tools returned → proceed
   - No tools → display error, stop (no fallback for brand-radar)

## Execution

**Step 1 — Brand Radar Overview:**
Call `mcp__claude_ai_ahrefs__brand-radar-mentions-overview` with:
- `target`: the brand name or domain

**Step 2 — Supplementary Brand Radar Data:**
If additional brand radar tools are available (discover via ToolSearch schema):
- `mcp__claude_ai_ahrefs__brand-radar-sov-overview` — share of voice
- `mcp__claude_ai_ahrefs__brand-radar-ai-responses` — AI search visibility
- `mcp__claude_ai_ahrefs__brand-radar-cited-domains` — domains citing brand in AI responses
```

### Pattern 4: Sequential Wave Multi-Agent Skill (site-audit-pro)

**What:** The most complex pattern in the project. Runs 3-4 agents per wave sequentially, checkpoints results to disk after each wave, continues on rate-limit errors
**When to use:** site-audit-pro only

This pattern is explicitly required by the STATE.md decision: "seo-site-audit-pro must use sequential wave architecture with 3-4 agent cap per wave and checkpoint saves — shared AbortController causes cascade termination on rate-limit errors (GitHub Issue #6594)"

```markdown
## Architecture

site-audit-pro uses THREE sequential waves:

**Wave 1: Domain Authority and Backlink Health**
Agents (run sequentially, 1 at a time):
  - seo-ahrefs-overview subagent
  - seo-ahrefs-backlinks subagent
  - seo-ahrefs-broken-links subagent
  - seo-ahrefs-dr-history subagent
Checkpoint: Write Wave 1 results to `seo-audit-pro-checkpoint-DOMAIN.md`

**Wave 2: Keyword and Competitive Position**
Agents (run sequentially after Wave 1 checkpoint saved):
  - seo-ahrefs-keywords subagent
  - seo-ahrefs-competitors subagent
  - seo-ahrefs-content-gap subagent (top competitor only)
  - seo-gsc-overview subagent (if GSC site param provided)
Checkpoint: Append Wave 2 results to checkpoint file

**Wave 3: Content and Technical Insights**
Agents (run sequentially after Wave 2 checkpoint saved):
  - seo-gsc-opportunities subagent (if GSC available)
  - seo-gsc-drops subagent (if GSC available)
  - seo-ahrefs-top-pages subagent
  - seo-ahrefs-anchor-analysis subagent
Checkpoint: Append Wave 3 results to checkpoint file

**Synthesis: Cross-MCP Narrative**
Read all checkpoint data and generate the cross-MCP insight section that only
appears when both Ahrefs and GSC data are present (e.g., "You rank #8 for
'project management software' per GSC but Ahrefs shows 3 competitors with
DR 20+ points higher — priority opportunity").
```

**Rate-limit resilience:** Each agent runs in a try/catch-equivalent: if a specific tool call fails with a rate-limit error, that agent logs "SKIPPED: rate limit — [tool name]" in the checkpoint and the wave continues with the next agent. The final report notes all skipped data sources.

### Pattern 5: File-Persisted Report Generation (report)

**What:** Collects data from multiple Ahrefs/GSC tools, applies an AI narrative layer, and saves the output to a markdown file on disk using the Write tool
**When to use:** `seo-report` only

```markdown
## Inputs
- `type`: Report type — one of: monthly, weekly, audit, competitor
- `domain`: The domain to report on (bare domain, e.g., `example.com`)
- `site` (optional): GSC property URL for including GSC data
- `output_dir` (optional): Directory to save the report file (default: current working directory)

## Execution

**Step 1 — Gather Data (varies by report type)**
Monthly: Ahrefs overview + keywords + DR history + GSC compare (if available)
Weekly: GSC drops + GSC opportunities + Ahrefs new-links
Audit: All Ahrefs tools + technical site assessment via WebFetch
Competitor: Ahrefs competitors + content-gap + anchor-analysis vs competitor

**Step 2 — Generate Report File**
Construct report markdown content.
Generate filename: `seo-report-{YYYY-MM-DD}-{domain}-{type}.md`
Use Write tool to save to `output_dir` (default: current directory).

**Step 3 — AI Narrative Layer**
Before saving, generate an executive summary section with AI interpretation
of the data pattern, not just raw numbers. This is the differentiating output.
```

### Anti-Patterns to Avoid

- **Calling one skill from another:** Claude Code skills cannot invoke other skills as functions. The content-brief skill must inline the SERP logic rather than calling seo-serp as a sub-routine.
- **Parallel agents in site-audit-pro:** STATE.md documents GitHub Issue #6594 — shared AbortController causes cascade termination. All agents must run sequentially in site-audit-pro.
- **Fabricating brand-radar data when endpoint unavailable:** mcp-degradation.md requires a clear error for brand-radar with no fallback. Never estimate or fabricate brand monitoring data.
- **Printing report to terminal instead of saving:** CROSS-05 success criterion explicitly requires the file be "saved to disk, not just printed to terminal." Use Write tool unconditionally.
- **Saving checkpoint files in project dir instead of tmp:** site-audit-pro checkpoint files should be saved in the current working directory (or a tmp path), not inside the skills directory.
- **Assuming WebMCP is connected:** STATE.md blocker documents the conflict between PROJECT.md ("not connected") and expansion spec ("connected"). Always check WebMCP with ToolSearch before using it; never assume availability.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| SERP data | Custom search API scraper | Ahrefs `serp-overview` tool | MCP provides DR, traffic estimates that scraping cannot |
| Brand mention tracking | Web scraping for brand citations | Ahrefs brand-radar-* tools | Ahrefs tracks AI mentions, traditional search, share of voice |
| Multi-agent coordination | Custom message passing between agents | Sequential write-to-file checkpoint pattern | Claude Code has no inter-agent message bus; files are the coordination mechanism |
| Report templating | Custom Python template engine | Inline markdown construction in SKILL.md | Skills are markdown-native; no external template engine needed |
| Rate limit retry logic | Exponential backoff loop | Catch-and-continue pattern (log skipped tools, continue wave) | Skills cannot loop; the correct pattern is noting skips and proceeding |
| AI narrative generation | External LLM API call | Claude's own analysis of the gathered data | Claude IS the AI layer; no external call needed for narrative synthesis |

**Key insight:** The entire "AI narrative layer" in `seo-report` is Claude itself interpreting the gathered data — no external AI API or template engine is needed. The skill's SKILL.md instructs Claude to analyze the data it gathered and write interpretive commentary, which is exactly what Claude does natively.

---

## Common Pitfalls

### Pitfall 1: WebMCP Availability Ambiguity
**What goes wrong:** `seo-serp` hardcodes WebMCP calls assuming it is connected, causing the skill to fail for users where it is not connected.
**Why it happens:** PROJECT.md says WebMCP is "not connected" but the expansion spec marks it connected — conflicting signals led Phase 3 design to assume connected.
**How to avoid:** Always ToolSearch `+webmcp` first. Design Ahrefs-only as the PRIMARY mode. WebMCP adds page-level crawl enrichment as OPTIONAL. The Ahrefs SERP overview already provides ranking URLs, DR, and traffic — this is sufficient output without WebMCP.
**Warning signs:** Test output varies between users with and without WebMCP — indicates WebMCP was assumed rather than detected.

### Pitfall 2: Ahrefs Brand Radar Response Schema Unknown
**What goes wrong:** `seo-brand-radar` is built against assumed field names that don't match the actual `brand-radar-mentions-overview` response.
**Why it happens:** The tool name is confirmed (`mcp__claude_ai_ahrefs__brand-radar-mentions-overview`) but the response schema has not been live-tested. The STATE.md blocker "Ahrefs Brand Radar endpoint name and response schema unverified" is still open.
**How to avoid:** The first task of Plan 03-02 must call `brand-radar-mentions-overview` via ToolSearch schema inspection before writing the output format. Use ToolSearch to get the tool definition and inspect parameter/response fields before building the skill logic.
**Warning signs:** Output section shows "null" or "undefined" for key fields — indicates wrong field names.

### Pitfall 3: Ahrefs SERP Tool Parameter Name Unknown
**What goes wrong:** `seo-serp` calls `mcp__claude_ai_ahrefs__serp-overview` with a `keyword` parameter that the tool does not recognize (actual parameter may be `query` or `term`).
**Why it happens:** The deferred tool list confirms the tool exists (`mcp__claude_ai_ahrefs__serp-overview`) but its exact parameter names have not been live-tested.
**How to avoid:** Use ToolSearch to inspect the tool schema before writing Execution steps. The first task of Plan 03-01 should call ToolSearch for `serp-overview` and document the actual parameter names.
**Warning signs:** Tool call returns "unknown parameter" error.

### Pitfall 4: site-audit-pro Agents Running Parallel Instead of Sequential
**What goes wrong:** Agent invocations in site-audit-pro are triggered in parallel (Claude's default for multiple subagent spawns), causing AbortController cascade on any rate-limit error.
**Why it happens:** Claude naturally parallelizes when spawning multiple subagents — the SKILL.md must explicitly instruct sequential execution with checkpoint saves between agents.
**How to avoid:** The SKILL.md execution steps must be written as strictly sequential: "Run Agent A. Wait for completion and save checkpoint. THEN run Agent B. Wait for completion and save checkpoint. THEN run Agent C." The word "THEN" and checkpoint saves between each agent enforce sequencing.
**Warning signs:** Audit output is missing multiple data sections simultaneously — indicates a cascade failure from parallel execution.

### Pitfall 5: Report File Path Not Communicated to User
**What goes wrong:** `seo-report` saves the file but the user cannot find it.
**Why it happens:** The Write tool saves to the specified path but the skill does not tell the user the full absolute path of the saved file.
**How to avoid:** After saving, always output: "Report saved to: [absolute path]" including the full resolved path. Use Bash to get `pwd` and construct the absolute path before writing.
**Warning signs:** User asks "where is the report?" immediately after the command completes.

### Pitfall 6: Content Brief Duplicating serp API Calls
**What goes wrong:** `seo-content-brief` makes the same Ahrefs SERP API call twice (once for its own execution, once because it tried to "call" seo-serp as a sub-skill).
**Why it happens:** The developer knows seo-serp does SERP analysis and tries to reuse it.
**How to avoid:** Accept upfront that skills cannot call each other. The content-brief SKILL.md must replicate the SERP call logic inline. Document in the skill: "Note: SERP analysis is inlined here (cannot call seo-serp as a sub-routine)."
**Warning signs:** Double API unit consumption on Ahrefs SERP tool within a single content-brief run.

### Pitfall 7: Ahrefs API Unit Cost for site-audit-pro
**What goes wrong:** `site-audit-pro` calls 10+ Ahrefs tools in sequence, consuming significant API units in a single run.
**Why it happens:** The site-audit-pro design aggregates data from all Ahrefs sub-commands. This is intentional but expensive.
**How to avoid:** The SKILL.md should warn the user upfront: "This command calls approximately N Ahrefs API tools. Check your Ahrefs API unit balance before running." Design the tool call priority order so highest-value tools run first (waves 1-2) and lower-priority tools run in wave 3, allowing the user to stop after wave 2 if budget is tight.
**Warning signs:** STATE.md blocker "Ahrefs API unit cost per endpoint unknown" is still open — this must be acknowledged in the SKILL.md user-facing warning.

---

## Code Examples

### Pattern: Ahrefs SERP Tool Call (unverified schema — must validate first)

```markdown
## Execution

**Step 1 — Verify SERP tool schema (first run only):**
Use ToolSearch with query "serp-overview" to inspect available tools and parameters.
Document actual parameter names before proceeding.

**Step 2 — Call SERP Overview:**
Call `mcp__claude_ai_ahrefs__serp-overview` with:
- `keyword` (or `query` — verify actual param name via ToolSearch): the keyword param

Returns per result: URL, DR of linking domain, estimated traffic, referring domains, title
```

### Pattern: Sequential Wave Checkpoint Save

```markdown
## Wave 1 Execution

1. **Run seo-ahrefs-overview logic inline:**
   Call `mcp__claude_ai_ahrefs__site-explorer-metrics` with target=domain
   Call `mcp__claude_ai_ahrefs__site-explorer-domain-rating` with target=domain
   If rate-limit error on either → log "SKIPPED: site-explorer-metrics — rate limit" and continue
   Store results as Wave 1 data

2. **Checkpoint save after Wave 1:**
   Construct checkpoint content from Wave 1 data
   Use Write tool to save to `seo-audit-pro-checkpoint-{domain}.md` in current directory
   Output: "Wave 1 complete. Checkpoint saved. Starting Wave 2..."

3. **Run Wave 2 agents...**
   [repeat pattern for each wave]
```

### Pattern: Report File Save

```markdown
## Report File Generation

1. Construct filename:
   Use Bash: `echo "seo-report-$(date +%Y-%m-%d)-{domain}-{type}.md"`

2. Construct report content (full markdown document with AI narrative)

3. Use Write tool to save:
   - file_path: "{output_dir}/seo-report-YYYY-MM-DD-domain-type.md"
   - content: [full report markdown]

4. Output to user:
   "Report saved to: [absolute file path]
   File size: approximately [N] sections covering [data sources used]"
```

### Pattern: Content Brief Structure

The content brief output should follow this structure for copy-paste usability:

```markdown
## Content Brief: "{keyword}"
**Generated:** {date}
**Keyword volume:** {volume from Ahrefs} searches/month
**SERP difficulty:** {competition assessment from DR of top 10}

### Current GSC Position (if site provided)
You currently rank #{position} for this keyword with {clicks} clicks/month.
Target: Move from #{position} to top 3.

### What's Ranking Now (SERP Analysis)
| URL | DR | Est. Traffic | Content Angle |
|-----|----|----|--------------|
| [url1] | [DR] | [traffic] | [topic focus] |

### Recommended Structure
**Target word count:** {word count based on SERP average}
**Content type:** {article/guide/comparison/tool page based on SERP signals}

**Suggested H2 structure:**
1. [H2 topic — derived from SERP analysis]
2. [H2 topic]
3. [H2 topic]

### Semantic Keywords to Include
[keywords from SERP titles and descriptions analysis]

### Differentiation Angle
{AI-generated insight on how to stand out from existing SERP results}
```

### Pattern: Brand Radar Output Structure

```markdown
## Brand Radar: {brand}
**Generated:** {date}

### AI Search Visibility
| Platform | Mention Rate | SOV % | Trend |
|----------|-------------|-------|-------|
| [AI tool] | [N mentions] | [%] | [up/down] |

### Top Cited Sources
| Domain | Citation Count | Context |
|--------|---------------|---------|
| [domain] | [N] | [quote snippet] |

### Brand Mentions Overview
- Total mentions tracked: {N}
- Sentiment: {positive/neutral/negative breakdown}
- Share of voice vs competitors: {N}%
```

---

## Ahrefs Tools for Phase 3 (from Deferred Tool List)

The deferred tool list confirms these Ahrefs tools are available (HIGH confidence — listed as deferred tools in the environment):

**SERP Tools:**
- `mcp__claude_ai_ahrefs__serp-overview` — SERP composition for a keyword

**Brand Radar Tools:**
- `mcp__claude_ai_ahrefs__brand-radar-mentions-overview` — Brand mention overview
- `mcp__claude_ai_ahrefs__brand-radar-mentions-history` — Mention history trend
- `mcp__claude_ai_ahrefs__brand-radar-sov-overview` — Share of voice overview
- `mcp__claude_ai_ahrefs__brand-radar-sov-history` — SOV history trend
- `mcp__claude_ai_ahrefs__brand-radar-impressions-overview` — Impressions overview
- `mcp__claude_ai_ahrefs__brand-radar-impressions-history` — Impressions history
- `mcp__claude_ai_ahrefs__brand-radar-ai-responses` — AI search brand visibility
- `mcp__claude_ai_ahrefs__brand-radar-cited-pages` — Pages citing the brand in AI responses
- `mcp__claude_ai_ahrefs__brand-radar-cited-domains` — Domains citing brand in AI responses

**NOTE:** These tool names are confirmed as existing tools in the environment (HIGH confidence on names). Their exact parameter names and response schemas require live ToolSearch schema inspection before building the skills. This is the MEDIUM confidence area — tool names are known, schemas are not.

---

## State of the Art

| Old Approach | Current Approach | Notes |
|--------------|-----------------|-------|
| Single-MCP commands (Phase 2) | Cross-MCP synthesis (Phase 3) | Phase 3 commands produce output impossible from either MCP alone |
| Terminal-only output (all Phase 2) | File-persisted reports (seo-report) | First time Write tool is used to persist output in this project |
| Inline agent logic (seo-audit) | Sequential wave architecture (site-audit-pro) | Rate-limit resilience requires sequential, not parallel |
| Agent routing known at design time | Runtime ToolSearch for MCP detection | Both patterns coexist; Phase 3 adds WebMCP runtime check |

**Deprecated/outdated:**
- Parallel multi-agent spawning for site-audit-pro: Explicitly rejected by STATE.md decision (GitHub Issue #6594). Do not implement.
- seo-gsc-analyst and seo-ahrefs-analyst agent files: Explicitly rejected in Phase 1 CONTEXT.md. Phase 3 similarly does not need an `seo-competitor-analyst` agent file for the content-brief — the SKILL.md handles logic directly.

---

## Open Questions

1. **Ahrefs SERP tool exact parameter name (`keyword` vs `query`)**
   - What we know: Tool `mcp__claude_ai_ahrefs__serp-overview` exists (confirmed in deferred tool list)
   - What's unclear: Whether the keyword parameter is named `keyword`, `query`, `term`, or another name
   - Recommendation: First task of Plan 03-01 must call ToolSearch with "serp-overview" query and inspect the returned tool's parameter schema before writing Execution steps

2. **Ahrefs Brand Radar response schema fields**
   - What we know: Tool `mcp__claude_ai_ahrefs__brand-radar-mentions-overview` exists; brand-radar suite has 9 tools
   - What's unclear: Response field names (mentions count, SOV percentage, AI response tracking fields)
   - Recommendation: First task of Plan 03-02 must inspect brand-radar tool schemas via ToolSearch before writing output format. Build output format FROM the actual fields, not assumed fields.

3. **WebMCP availability and connection status**
   - What we know: PROJECT.md says not connected; expansion spec says connected; mcp-degradation.md documents the WebMCP check pattern
   - What's unclear: Current registration status (no `~/.claude/mcp.json` file exists — verified during research)
   - Recommendation: Design seo-serp as Ahrefs-only primary with WebMCP as optional enrichment. The SKILL.md should clearly document: "WebMCP enrichment: If WebMCP is available, crawls top 3-5 pages for title/H1 extraction. If not available, runs in Ahrefs-only mode (default)."

4. **site-audit-pro agent architecture: subagents vs inline logic**
   - What we know: The ROADMAP.md Plan 03-03 says "sequential wave architecture, 3-4 agent cap per wave" which implies subagents; seo-audit uses the subagent pattern (delegates to seo-technical, seo-content, etc.)
   - What's unclear: Whether site-audit-pro should spawn actual subagent processes (like seo-audit does) or run tool calls inline within the single SKILL.md
   - Recommendation: Use inline tool calls within the single SKILL.md for site-audit-pro. Do NOT spawn subagents — the sequential wave pattern is about controlling tool call order, not subagent processes. Subagents in seo-audit exist because different agents analyze different URL sets; site-audit-pro analyzes the same domain with different API tools, which does not require subagent delegation.

5. **Ahrefs API unit costs for site-audit-pro**
   - What we know: Ahrefs has per-call API unit costs; exact costs TBD (tracked as Phase 2 STATE.md blocker, still unresolved)
   - What's unclear: Whether a full site-audit-pro run (10+ tool calls) consumes significant unit budget
   - Recommendation: Add a user-facing warning in site-audit-pro SKILL.md: "This command calls approximately 10-12 Ahrefs API tools. Monitor your API unit balance at ahrefs.com/billing." Design wave architecture so user can stop after any wave if budget concern arises.

6. **Report output directory: current working directory vs `~/Desktop` vs user-specified**
   - What we know: Write tool requires absolute path; cwd varies by user's Claude Code session
   - What's unclear: Best default location for report files
   - Recommendation: Default to current working directory (use Bash `pwd` to get absolute path). Accept optional `output_dir` parameter to override. Always print full absolute path after save.

---

## Routing Table: Phase 3 Directories (Already Pre-Registered)

The routing table in `skills/seo/SKILL.md` already has Phase 3 entries (confirmed during research):

| Command | Sub-skill Directory | Current Status |
|---------|--------------------|----|
| `/seo serp` | `seo-serp/` | Phase 3 (directory missing) |
| `/seo content-brief` | `seo-content-brief/` | Phase 3 (directory missing) |
| `/seo brand-radar` | `seo-brand-radar/` | Phase 3 (directory missing) |
| `/seo site-audit-pro` | `seo-site-audit-pro/` | Phase 3 (directory missing) |
| `/seo report` | `seo-report/` | Phase 3 (directory missing) |

**No routing table update needed.** The Phase 3 plan just needs to create these 5 directories with their SKILL.md files. The seo/SKILL.md routing table already handles routing to them, and the status will read as "Phase 3" until the directory exists (the orchestrator checks directory existence per its own routing logic).

**HOWEVER:** After all 5 skills are built, a single update to seo/SKILL.md is still needed to change status from "Phase 3" to "active" and update the description count from "32 active, 5 planned" to "37 active." This should be the final task of Plan 03-03 (same pattern as Phase 2 Plan 02-04).

---

## Sources

### Primary (HIGH confidence)
- `/Users/aash-zsbch1500/Desktop/Github projects/SEO/skills/seo/SKILL.md` — Routing table for Phase 3 commands, confirmed directory names and pre-existing routing entries
- `/Users/aash-zsbch1500/Desktop/Github projects/SEO/skills/seo/references/ahrefs-api-reference.md` — Phase 3 Ahrefs tool names (brand-radar-mentions-overview confirmed), monetary conventions
- `/Users/aash-zsbch1500/Desktop/Github projects/SEO/skills/seo/references/mcp-degradation.md` — WebMCP check pattern, error templates, fallback mapping for all Phase 3 commands
- `/Users/aash-zsbch1500/Desktop/Github projects/SEO/.planning/STATE.md` — Sequential wave architecture decision (GitHub Issue #6594), WebMCP conflict blocker, Brand Radar unverified schema blocker
- `/Users/aash-zsbch1500/Desktop/Github projects/SEO/.planning/phases/02-core-live-data/02-RESEARCH.md` — Established Phase 2 patterns this phase must follow
- `/Users/aash-zsbch1500/Desktop/Github projects/SEO/.planning/phases/01-foundation/01-CONTEXT.md` — Locked decisions: flat directory layout, no analyst agent files, MCP checks self-contained in each skill
- Deferred tool list in environment — Confirms existence of `serp-overview` and all brand-radar-* tools with exact tool names

### Secondary (MEDIUM confidence)
- `/Users/aash-zsbch1500/Desktop/Github projects/SEO/.planning/ROADMAP.md` — Phase 3 plan descriptions; agent mentions contradict Phase 1 decisions (Phase 1 decision takes precedence)
- Phase 2 SKILL.md examples (seo-gsc-overview, seo-ahrefs-competitors, seo-ahrefs-overview) — Pattern reference for how to structure Phase 3 SKILL.md files

### Tertiary (LOW confidence)
- Ahrefs Brand Radar response schema fields: NOT live-tested (tool name confirmed, fields inferred from tool name semantics)
- Ahrefs SERP overview parameter names: NOT live-tested (tool confirmed, param names inferred)
- WebMCP current registration status: Conflicting signals, no mcp.json found — treat as unregistered until confirmed

---

## Metadata

**Confidence breakdown:**
- Phase 3 routing table entries and directory names: HIGH — read directly from skills/seo/SKILL.md
- Ahrefs Brand Radar tool names: HIGH — confirmed in deferred tool list and ahrefs-api-reference.md
- Ahrefs SERP tool name: HIGH — confirmed in deferred tool list
- Brand Radar / SERP response schema fields: LOW — tool names known but response schemas require live ToolSearch inspection
- WebMCP availability: LOW — confirmed not registered (no mcp.json), conflicting project docs
- Sequential wave architecture (site-audit-pro): HIGH — locked decision in STATE.md with GitHub issue reference
- File persistence pattern (Write tool): HIGH — Write tool is in project allowed-tools; standard Claude Code tool
- Skills-cannot-call-skills constraint: HIGH — structural Claude Code limitation, verified by project pattern
- Ahrefs API unit costs: LOW — explicitly marked TBD in ahrefs-api-reference.md and STATE.md blocker

**Research date:** 2026-03-02
**Valid until:** 2026-04-01 (Ahrefs API tool schemas may version; WebMCP registration status may change)
