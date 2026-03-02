# Domain Pitfalls

**Domain:** Claude Code SEO Skills with MCP Integration (Ahrefs + GSC)
**Researched:** 2026-03-02
**Confidence:** HIGH — findings sourced from confirmed GitHub issues, official Anthropic docs, Ahrefs docs, and Google developer docs

---

## Critical Pitfalls

Mistakes that cause broken features, rewrites, or production-blocking failures.

---

### Pitfall 1: Custom Subagents Cannot Access Project-Scoped MCP Servers

**What goes wrong:** Custom subagents defined in `.claude/agents/` cannot call MCP tools from locally-configured MCP servers (project-level `.mcp.json`). Instead of failing loudly, they silently hallucinate plausible-looking results. Real data is never fetched — the subagent fabricates an answer that looks correct.

**Why it happens:** This is a confirmed Claude Code bug (Issue #13898, open as of March 2026). The MCP tool resolution pathway for custom agents only works with globally-configured MCP servers (`~/.claude/mcp.json` or user-scope `~/.claude.json`), not project-scoped servers.

Confirmed test matrix:
| Subagent Type | MCP Scope | Result |
|---|---|---|
| Built-in (general-purpose) | Project (.mcp.json) | Works |
| Built-in (general-purpose) | Global (~/.claude/mcp.json) | Works |
| Custom (.claude/agents/) | Project (.mcp.json) | HALLUCINATES |
| Custom (.claude/agents/) | Global (~/.claude/mcp.json) | Works |

**Consequences:** Every SEO skill that spawns a custom subagent to call Ahrefs or GSC MCP tools will silently return fabricated data. No error is raised. The user receives a complete-looking report built on invented numbers. This is the highest-severity issue because it produces confident wrong output.

**Prevention:**
1. Configure all MCPs (Ahrefs, GSC) at user scope, not project scope: `claude mcp add my-server --scope user`
2. Alternatively, make MCP calls at the orchestrator level (main skill thread) and pass the real results as data to subagents via their prompt
3. Do not expect custom `.claude/agents/` subagents to call MCP tools directly from project-level config
4. Validate MCP integration by running a simple tool call from a custom subagent and verifying the result against a known value before shipping

**Detection:** Run a custom subagent with an intentionally wrong parameter and verify it returns an actual error, not a plausible-sounding result. If it returns a plausible result, it is hallucinating.

**Phase:** Address in Phase 1 before building any skill that uses a subagent + MCP combination. Establish user-scope MCP config as the project standard.

**Source:** GitHub issue #13898 (confirmed open bug with repro steps)

---

### Pitfall 2: Parallel Subagent Cascade Termination from Shared AbortController

**What goes wrong:** When running multiple subagents in parallel (which `/seo site-audit-pro` does with 10+ agents), a single API error or rate-limit (HTTP 429) from any one subagent kills ALL subagents simultaneously. The entire audit fails with no partial results saved.

**Why it happens:** Claude Code introduced a shared `AbortController` architecture in versions after v1.0.61. When one subagent encounters an error, `abortController.abort()` is called on the shared controller, cascading termination to all other active subagents. This is a regression from v1.0.61 where each subagent had independent error handling.

**Consequences:** `/seo site-audit-pro` spawns 10+ parallel subagents. If any one hits a rate limit on Ahrefs API or GSC API mid-audit, the entire audit is destroyed with no output. The user sees nothing after waiting several minutes.

**Prevention:**
1. Reduce maximum parallel subagents to 3-4 instead of 10+ for production commands
2. Add explicit delays between subagent spawns (1-2 seconds) to reduce likelihood of simultaneous rate-limit hits
3. Build checkpoint/partial-save logic into the orchestrator — save each subagent's result to a temp file as it completes, so a cascade kill doesn't lose all work
4. Structure `site-audit-pro` to run in sequential waves (technical+content first, then backlink+keyword, then cross-MCP) rather than fully parallel
5. Implement a retry wrapper at the orchestrator level before spawning subagents

**Detection:** Run `/seo site-audit-pro` on a target that will trigger Ahrefs rate limits (large domain, many queries). If all subagents die simultaneously when the rate limit hits, the cascade bug is present.

**Phase:** Address in Phase 2 when building `site-audit-pro`. Do not build the 10-agent parallel architecture without the checkpoint pattern.

**Source:** GitHub Issue #6594 (subagent termination bug with confirmed root cause)

---

### Pitfall 3: Ahrefs API Unit Consumption Blowout

**What goes wrong:** The Ahrefs API v3 charges API units per query with a minimum cost of 50 units per query, plus per-row costs. Multi-step skills that make several sequential Ahrefs queries (e.g., `site-audit-pro` calling overview + backlinks + keywords + competitors + content-gap + broken-links) can rapidly exhaust monthly API unit budgets.

**Why it happens:** The Ahrefs MCP abstracts individual API calls but each tool invocation still consumes API units. Skills designed to be comprehensive by default will make 5-15 Ahrefs API calls per invocation. At 50+ units minimum per call, a single `/seo site-audit-pro` run could cost 500-1,500+ units. Monthly plans have fixed unit allocations.

**Consequences:** Monthly Ahrefs API units depleted before month end. Skills become unavailable mid-month. Published commands that community installs could drain their API credits in days.

**Prevention:**
1. Implement a `--lite` vs `--full` flag on all Ahrefs-heavy commands. Default to `--lite` (fewer API calls, core data only).
2. Display estimated API unit cost to the user before executing a heavy query
3. Cache Ahrefs results to temp files with a configurable TTL (default: 24 hours). Never re-query if recent data is available
4. Document the API unit cost of each command in the skill's description
5. Monetary values returned by Ahrefs API are in USD cents — always divide by 100 before displaying. This is documented in PROJECT.md as a constraint
6. Group queries to maximize rows per call rather than making many low-row calls

**Detection:** Monitor Ahrefs Accounts → Limits & Usage after running skills once. If a single audit session consumed >500 units, the command is not API-efficient.

**Phase:** Address before Phase 2 (Ahrefs commands). Establish caching layer and `--lite` defaults in Phase 1 infrastructure.

**Source:** Ahrefs API pricing documentation; PROJECT.md constraint annotation; Ahrefs Academy course structure (confirmed minimum 50 units per query)

---

### Pitfall 4: GSC API Quota Exceeded on High-Frequency Commands

**What goes wrong:** Google Search Console API has a 1,200 QPM (queries per minute) per-site limit and a 2,000 QPD URL inspection quota per site. Commands like `/seo gsc content-decay` (which analyzes 90 days of data across all pages) or `/seo migration-check` (which inspects many URLs) can hit these limits, returning `403 Load Quota Exceeded` errors mid-execution.

**Why it happens:** The GSC Search Analytics API is most expensive when grouping/filtering by both page AND query string simultaneously. Commands that pull per-page, per-keyword data for date ranges hit load limits quickly. The per-site quota applies to the specific property, meaning heavy use of one command can block all subsequent GSC calls for 10-15 minutes.

**Consequences:** Command execution fails mid-analysis. Subsequent GSC commands from any `/seo gsc` subcommand are blocked until quota resets. Users cannot understand why the tool "broke."

**Prevention:**
1. Never group by both page AND query string in the same GSC query — this is the most expensive operation. Break into two separate queries: one for pages, one for keywords
2. Add exponential backoff retry logic when `403` is received: wait 15 minutes for long-term quota resets
3. Cache GSC results locally for 24 hours — GSC data does not change minute-to-minute
4. For `/seo gsc content-decay` (90-day analysis), paginate requests: max 25,000 rows per call, spread across time to stay under load limits
5. Warn users upfront that URL Inspection quota is 2,000 per day per property — do not run migration-check on large sites without explicitly warning them

**Detection:** Watch for `403 Load Quota Exceeded` errors. Also check Google API Console quota tab for actual usage.

**Phase:** Address in Phase 1 (GSC commands). Implement caching and backoff before shipping any GSC command.

**Source:** Google Search Console API Usage Limits documentation; confirmed quota limits: 1,200 QPM per-site, 2,000 QPD URL inspection per-site

---

### Pitfall 5: YAML Frontmatter Errors Silently Break Skills

**What goes wrong:** A SKILL.md file with invalid YAML frontmatter (HTML comments before the `---` markers, XML tags in name/description, name exceeding 64 characters, use of reserved words like "claude" or "anthropic") causes the skill to silently fail to load. The command either stops appearing or produces no output with no error message.

**Why it happens:** This is the #1 bug fixed in the existing claude-seo project (TODO.md shows "Fix YAML frontmatter parsing — Removed HTML comments before `---` in 8 files"). The original repo shipped with broken frontmatter in 8 of its files. The Claude Code skill loader is strict: any YAML parsing failure silently skips the skill.

**Consequences:** The command `/seo gsc` or any other skill simply does not respond. The user sees nothing. There is no error to debug from. This is particularly damaging for community-published skills where users will assume the tool is broken and abandon it.

YAML validation rules confirmed from official docs:
- `name`: max 64 characters, lowercase letters/numbers/hyphens only, no XML tags, no reserved words ("anthropic", "claude")
- `description`: max 1024 characters, non-empty, no XML tags, must be in third person
- No content before the opening `---` delimiter

**Prevention:**
1. Add a YAML frontmatter validation script to the install process — run it against all SKILL.md files and fail loudly if any are invalid
2. Use a linter or CI check that validates frontmatter before any commit
3. Never add HTML comments, prose text, or blank lines before the `---` marker in SKILL.md files
4. Keep skill names under 40 characters to leave buffer
5. Write skill descriptions in third person ("Analyzes...") — description is injected into system prompt and first-person breaks discovery

**Detection:** Run `head -5 ~/.claude/skills/seo-*/SKILL.md` after install. Each file must start with `---` on line 1. Also: run `/seo markdown-audit` — if the command does nothing, frontmatter is likely broken.

**Phase:** Build the validation script in Phase 1 before writing any skill files. Run it as a pre-commit hook.

**Source:** Official Anthropic Skills documentation (YAML validation rules); claude-seo TODO.md showing 8 files with this exact bug were fixed in v1.2.0

---

## Moderate Pitfalls

Mistakes that degrade quality or waste significant development time, but do not cause complete failure.

---

### Pitfall 6: 27-Command Scope Creep Causing Adoption Failure

**What goes wrong:** Building all 27 commands before validating that the Tier 1 commands deliver value. The project ships with 27 commands and none of them are polished. Users (including the author) don't know which to use. Discoverability collapses when there are 30+ commands in a skill namespace.

**Why it happens:** The seo-skill-expansion.md document defines 27 commands across three tiers. The instinct is to implement all of them. But research shows that teams building everything as commands produce 30+ slash commands nobody remembers to use (verified by SFEIR Institute data on Claude Code command adoption).

**Consequences:** Shallow implementations across 27 commands instead of deep, reliable implementations of 5-10. The skills that people would actually use daily (`/seo gsc`, `/seo ahrefs`) get the same treatment as niche ones (`/seo local`, `/seo log-analysis`). The project's value per command is diluted.

**Prevention:**
1. Implement in strict tier order: fully ship and validate Tier 1 (5 commands) before starting Tier 2
2. Define "done" for each command: runs end-to-end without errors, caches results, handles API failures gracefully, produces useful output
3. Publish Tier 1 as v1.0 and validate community usage before building Tier 2
4. Treat Tier 3 commands (local, log-analysis, migration-check) as separate future milestones, not current scope

**Detection:** If any Tier 1 command cannot be run reliably 5 times in a row without failure, do not begin Tier 2.

**Phase:** Enforce at Phase 0 (planning). Build roadmap around tiers, not total command count.

---

### Pitfall 7: Bloated SKILL.md Context Window Consumption

**What goes wrong:** Writing verbose SKILL.md files for each command, embedding all instructions, reference data, and documentation inline. A 1,000-line SKILL.md for `/seo site-audit-pro` with all scoring rubrics, agent instructions, and reference tables embedded is loaded in full whenever the skill triggers — consuming context window tokens that should go to actual analysis data.

**Why it happens:** It feels like more instructions = better skill behavior. The instinct is to over-specify everything in the main file. The existing claude-seo repo demonstrates good progressive disclosure (main SKILL.md is concise, references sub-skills), but when adding 15 new commands, the temptation is to put everything in one file.

**Consequences:** Skills that load in full at trigger time eat 5,000-10,000 tokens before any analysis begins. With 27 skills loaded, metadata evaluation alone can consume 50-200 tokens per skill per conversation turn. Context window shrinks from 200K to effectively much less.

**Prevention:**
1. Keep each SKILL.md body under 500 lines (official Anthropic recommendation)
2. Use progressive disclosure: SKILL.md provides routing/overview, separate reference files provide detail
3. Follow the pattern established in claude-seo: core skill file delegates to reference files loaded on-demand
4. Put scoring rubrics, schema templates, and reference tables in separate `.md` files, loaded only when needed
5. Test each skill file with `wc -l` — any file over 300 lines needs to be split

**Detection:** Use `/cost` in Claude Code after running a complex skill. If token usage is unexpectedly high before any real work is done, SKILL.md files are too large.

**Phase:** Address from the start. Establish file size limits as a coding standard in Phase 1.

---

### Pitfall 8: Subagents Launched Without MCP Data Context

**What goes wrong:** The orchestrator skill calls an Ahrefs or GSC MCP tool, then spawns a subagent to analyze the results — but passes only the raw JSON payload without context about what it represents, what the user's goal is, or what output format is expected. Each subagent starts with blank context and wastes ~15,000 tokens reconstructing what it should be doing.

**Why it happens:** Subagents in Claude Code each start with a completely blank context. They do not see the parent conversation. Passing a data blob to a subagent without a complete framing prompt results in the subagent spending its first 10,000+ tokens trying to understand what it has and what to do with it.

**Consequences:** Token waste per subagent invocation. Inconsistent output formats between runs. Subagents that produce generic analysis instead of domain-specific SEO recommendations.

**Prevention:**
1. Every subagent prompt must include: (a) the user's goal, (b) the data being passed, (c) the site/domain context, (d) the exact output format required, (e) any domain-specific rules
2. Template each subagent invocation: create a standard prompt structure that all skills use when spawning SEO analysis subagents
3. Pass structured JSON data, not raw API responses — pre-process the MCP output at the orchestrator level before sending to subagents
4. Include site context (domain, industry, competitor list) in every subagent prompt, even if it was already established in the parent conversation

**Detection:** Review subagent output quality — if the first 500 words of a subagent's response are scene-setting and restating what data it has, the prompt is insufficient.

**Phase:** Address in Phase 1 by establishing a standard subagent prompt template for SEO analysis.

---

### Pitfall 9: GSC Data Limitations Presented as Complete Truth

**What goes wrong:** GSC data is presented to users without caveats, leading to incorrect conclusions. GSC has significant structural limitations that affect analysis quality: (a) only 16 months of historical data available, (b) queries from fewer than ~50 users per month are anonymized/removed ("(other)" category), (c) 1,000 row limit in UI (50,000 via API), (d) data is sampled not complete, (e) data appears in GSC with a 2-3 day lag.

**Why it happens:** The GSC MCP returns data that looks authoritative. Commands like `/seo gsc drops` and `/seo gsc content-decay` pull real data but fail to communicate that the long tail of keywords is invisible and that very recent changes haven't appeared yet.

**Consequences:** Users make decisions based on incomplete keyword data. Content decay analysis misses the silent long-tail drop (which is the most common type of decay). Traffic drops in the last 48 hours show as "no change" because data hasn't propagated.

**Prevention:**
1. Add a standard disclaimer block to every GSC output report: data covers up to 16 months, long-tail keywords (< ~50 monthly searches for the site) are excluded, data lags 2-3 days
2. For content decay analysis, explicitly note that a page "not found in GSC" could mean (a) no impressions, (b) below anonymization threshold, or (c) not indexed — these require different fixes
3. `/seo gsc drops` should always show the date range analyzed and warn if the range includes the last 3 days
4. When zero results are returned for a keyword or page, distinguish between "never ranked" vs "below threshold" vs "data not yet available"

**Detection:** If any GSC command output says nothing about data limitations, that command needs a disclaimer block added.

**Phase:** Address in all GSC command implementations. Build the disclaimer as a reusable template.

---

### Pitfall 10: Ahrefs "Archved Local Server" vs Remote Server Confusion

**What goes wrong:** The GitHub repository `ahrefs/ahrefs-mcp-server` is archived and explicitly labeled as OUTDATED. It uses API v3 keys but explicitly states "DOES NOT work with MCP keys." Building skills that try to use this local server (or any documentation referencing it) means the integration is broken by design.

**Why it happens:** The local server was the first Ahrefs MCP implementation. It was replaced by a hosted remote MCP server. GitHub search for "Ahrefs MCP" returns the archived repo prominently, and many tutorials reference it.

**Consequences:** Integration built against the archived local server will fail silently or with authentication errors. The remote server has different authentication patterns and tool names.

**Prevention:**
1. Use only the official remote Ahrefs MCP server (not the archived `ahrefs/ahrefs-mcp-server` GitHub repo)
2. Authentication for the remote server uses a different credential model — verify against current Ahrefs Connect docs
3. Ahrefs MCP is available on Lite, Standard, Advanced, and Enterprise plans — verify which plan is in use before assuming all tools are available
4. Document which Ahrefs MCP server version and tool names are being called in the skill

**Detection:** If the skill references the `ahrefs/ahrefs-mcp-server` npm package, it is using the archived and deprecated implementation.

**Phase:** Verify at the start of Phase 1 by making a single test call to the remote Ahrefs MCP server and confirming the tool names match what the skill expects.

---

### Pitfall 11: Skill Description Written in First Person Breaks Discovery

**What goes wrong:** Writing skill descriptions like "I analyze your Google Search Console data to find opportunities" instead of "Analyzes Google Search Console data for keyword opportunities and CTR improvements." Claude Code injects the description into the system prompt — first-person descriptions create point-of-view inconsistencies that damage skill discovery and trigger reliability.

**Why it happens:** It feels natural to write "I can..." descriptions. The original claude-seo README uses first-person language, and that style bleeds into SKILL.md descriptions.

**Consequences:** Skills don't trigger when expected. Skill selection becomes inconsistent. Claude may not select the skill because the description doesn't clearly communicate when to use it from Claude's perspective.

**Prevention:**
1. All `description` fields must be written in third person: "Analyzes...", "Generates...", "Audits..."
2. Description must include both WHAT the skill does AND the trigger keywords (what the user might say that should invoke this skill)
3. Template: `"[Gerund verb] [what]. Use when user says '[trigger phrase 1]', '[trigger phrase 2]', or mentions [topic]."`
4. Include specific activation phrases in the description — these are the actual strings users will type

**Detection:** Review every SKILL.md description. Any that start with "I", "We", "You can", or "This helps" must be rewritten.

**Phase:** Enforce from Phase 1. Write a description template and use it for all 27 commands.

---

## Minor Pitfalls

Issues that cause friction but are recoverable without significant rework.

---

### Pitfall 12: Monetary Values Displayed in Cents Instead of Dollars

**What goes wrong:** Ahrefs API returns monetary values (traffic value, CPC estimates) in USD cents. Displaying raw API values produces "$14500" when the correct value is "$145.00".

**Why it happens:** This is documented in PROJECT.md as a constraint but is easy to forget when writing specific commands. The conversion is simple but must be applied consistently across all Ahrefs output.

**Prevention:**
1. Create a single utility function `format_ahrefs_money(cents)` used by all commands
2. Code review checklist: any Ahrefs field that could be monetary must pass through the formatter
3. Test with known domains where you know the approximate traffic value

**Detection:** Run `/seo ahrefs overview` on a known domain. If traffic value looks 100x too high, the division by 100 is missing.

**Phase:** Address as a shared utility in Phase 1 infrastructure before building any Ahrefs commands.

---

### Pitfall 13: MCP Tool Names Must Be Fully Qualified in Skill Files

**What goes wrong:** Referencing MCP tools in SKILL.md without the server prefix (`tool_name` instead of `ServerName:tool_name`) causes Claude to fail to locate the tool, especially when multiple MCP servers are connected and tool names could be ambiguous.

**Why it happens:** It's tempting to write short tool names. With only one Ahrefs MCP connected, it seems unambiguous. But when multiple MCPs are active (Ahrefs + GSC + RSS), ambiguity increases. Official Anthropic docs explicitly warn about this.

**Prevention:**
1. Always use fully qualified tool names in SKILL.md: `Ahrefs:get_domain_overview`, not `get_domain_overview`
2. Audit all MCP tool references in every SKILL.md file before shipping
3. Document the full server:tool mapping in a shared reference file

**Detection:** If a skill works in isolation but fails when other MCPs are also connected, tool names are likely unqualified.

**Phase:** Enforce from Phase 1. Establish the naming convention before writing any skill files.

---

### Pitfall 14: Skill Names Conflicting with Native Claude Code Commands

**What goes wrong:** Creating a skill file named after a built-in Claude Code command (like `compact`, `doctor`, `review`) silently conflicts with the native implementation since version 2.0. The skill may partially override the native command or not trigger at all.

**Why it happens:** The seo-skill-expansion.md uses the namespace `/seo [subcommand]`, which avoids most conflicts. But if any top-level skill accidentally shares a name with a built-in, the conflict happens without error.

**Prevention:**
1. Always use the `seo-` prefix for skill names in the `name` field
2. Test new skill names against the built-in command list before creating files
3. Never create skills named: `compact`, `doctor`, `review`, `clear`, `help`, `bug`, `init`, `config`, `cost`

**Detection:** If a skill triggers correctly sometimes but not others, check for name conflicts with built-in commands.

**Phase:** Minor risk given the `seo-` prefix convention, but verify in Phase 1.

---

### Pitfall 15: Nested Reference File Structure Breaking Claude's Navigation

**What goes wrong:** Creating a deeply nested reference structure (SKILL.md → advanced.md → details.md → specifics.md) causes Claude to use `head -100` preview reads instead of reading full files, missing critical information. Reference files should be maximum one level deep from SKILL.md.

**Why it happens:** The natural instinct when organizing large amounts of SEO reference material is to create sub-hierarchies. The existing claude-seo has a `references/` folder inside the main skill which is appropriate — one level deep. Adding sub-folders within that breaks the pattern.

**Prevention:**
1. All files referenced from SKILL.md must be directly readable without nested lookups
2. Maximum directory depth: `skill-name/SKILL.md` → `skill-name/references/reference-file.md`
3. No `skill-name/references/sub-topic/detail.md` — flatten to `skill-name/references/topic-detail.md`
4. Include a table of contents at the top of any reference file over 100 lines

**Detection:** If Claude is using partial reads or `head` commands on reference files, the hierarchy is too deep.

**Phase:** Establish directory structure conventions in Phase 1.

---

## Phase-Specific Warnings

| Phase Topic | Likely Pitfall | Mitigation |
|-------------|---------------|------------|
| MCP Setup (Phase 1) | Custom subagents hallucinate when MCP is project-scoped | Configure all MCPs at user scope; validate with known-value test |
| GSC Commands (Phase 1) | Quota exceeded errors (403) on content-decay analysis | Cache results; never group page+query in same call |
| Ahrefs Commands (Phase 1) | API unit blowout from multi-call skills | Default to `--lite`, cache 24hr, display cost warnings |
| Ahrefs Data Display (Phase 1) | Monetary values shown in cents not dollars | Build format_ahrefs_money() utility before any command output |
| SKILL.md Authoring (all phases) | YAML frontmatter validation failures, silent skill loading failure | Run linter on all SKILL.md files as part of build |
| site-audit-pro (Phase 2) | Cascade termination kills all 10+ parallel subagents | Limit to 3-4 parallel; add checkpoint saves; sequential waves |
| site-audit-pro (Phase 2) | Context window exhaustion from 10+ subagents reporting back | Pre-structure output format strictly; avoid verbose subagent responses |
| content-brief (Phase 1-2) | WebMCP not connected — skill spec references it for SERP crawling | Degrade gracefully to Ahrefs SERP data only when WebMCP is absent |
| brand-radar (Phase 2) | Ahrefs Brand Radar availability varies by plan | Validate tool availability at skill invocation; fail gracefully with message |
| All published commands | Community users hit Ahrefs API limits faster than expected | Document API unit cost in each skill's description; default to lite mode |
| GSC data presentation | Missing data caveat causes wrong decisions | Every GSC command output must include data-limitation disclaimer |

---

## Sources

- GitHub Issue #13898 — "Custom Subagents Cannot Access Project-Scoped MCP Servers (Hallucinate Instead)" (open bug, confirmed repro) — https://github.com/anthropics/claude-code/issues/13898
- GitHub Issue #6594 — "Subagent Termination Bug in Claude Code v1.0.62" (confirmed root cause: shared AbortController) — https://github.com/anthropics/claude-code/issues/6594
- Anthropic Official — Skill authoring best practices (YAML validation rules, description third-person, 500-line limit, MCP tool naming) — https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
- Google Search Console API Usage Limits (1,200 QPM, 2,000 QPD URL inspection, 16-month data retention) — https://developers.google.com/webmaster-tools/limits
- Ahrefs MCP server GitHub (ARCHIVED — confirmed outdated, do not use) — https://github.com/ahrefs/ahrefs-mcp-server
- SFEIR Institute — Common mistakes in Claude Code skills (wrong file location, vague prompts, missing $ARGUMENTS) — https://institute.sfeir.com/en/claude-code/claude-code-custom-commands-and-skills/errors/
- claude-seo TODO.md — Historical bugs from the source project (YAML frontmatter in 8 files, SSRF prevention, subagent timeout handling documented as known issues)
- claude-seo TROUBLESHOOTING.md — Confirmed real-world issues: Python deps, Playwright, subagent-not-found, hook failures
- PROJECT.md — Ahrefs monetary values constraint ("USD cents — must divide by 100 for display")
- Google Search Console data limitations (16-month retention, row limits, anonymized queries) — https://seotesting.com/google-search-console/data-limitations/
