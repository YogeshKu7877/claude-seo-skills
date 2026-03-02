# Phase 4: Enhanced Originals & Local Analysis - Context

**Gathered:** 2026-03-02
**Status:** Ready for planning

<domain>
## Phase Boundary

Upgrade the 12 original commands with live MCP data overlays (Ahrefs/GSC), add 5 new local analysis commands (log-analysis, ai-content-check, internal-links, local, migration-check), improve existing skills with authoritative guideline alignment, fix deployment so all skills install correctly, and add automated smoke tests. New capabilities like public MCP release, llm.txt/AI bot indexing commands, and GEO expansions are out of scope.

</domain>

<decisions>
## Implementation Decisions

### MCP Overlay Strategy
- Appended section approach: keep existing static output unchanged, add `## Live Data Insights` section at the end when MCPs are available
- Selective overlays only — add MCP data only to commands where it genuinely helps (audit, technical, content, page), skip commands where it doesn't add clear value (plan, programmatic, hreflang)
- Follow existing graceful degradation pattern from `references/mcp-degradation.md`

### Skill Quality Improvements
- Align skill audit checklists to Google's SEO Starter Guide categories (Discoverability, Content Quality, On-Page Elements, Technical/UX, Links)
- Add any missing checks from the Google guide to relevant skills
- Create new reference files: `references/google-seo-guide.md` and `references/markdown-guide.md` — loaded on demand via @-reference, same pattern as existing cwv-thresholds.md and eeat-framework.md
- Update all SKILL.md frontmatter — refresh descriptions to reflect enhanced capabilities, update trigger words for better slash-command discoverability

### Markdown Audit Improvements
- Claude's Discretion: determine which Markdown Guide rules to add during planning (candidates: space after headings, consistent list delimiters, proper emphasis syntax, blank lines before/after elements, URL encoding)

### Install Script Fix
- One install script deploys ALL skills (originals + Phase 2/3 MCP skills) to `~/.claude/skills/`
- This fixes the seo-schema (and other originals) not appearing in slash-command autocomplete
- Same deployment pattern already used for Phase 2/3 skills

### Log Analysis (`/seo log-analysis <file>`)
- Support Apache Combined/Common log format and Nginx access logs
- Auto-detect format from first few lines of the file
- Output: crawl budget breakdown (bot vs user traffic, crawl frequency by path, top crawled URLs)
- No external API calls required

### AI Content Check (`/seo ai-content-check <url or file>`)
- Writing pattern analysis: sentence structure, vocabulary diversity, repetition patterns, common AI tells (filler phrases, hedging language)
- Pure text analysis — no external API calls
- Output: confidence score + flagged passages with explanations

### Internal Links (`/seo internal-links <domain>`)
- Crawl-based approach: reuse existing fetch_page.py + parse_html.py
- Crawl up to 100-200 pages
- Build link graph, identify orphan pages, suggest anchor text for top underlinked pages
- No external API calls required (but could be enriched with Ahrefs data if available)

### Migration Check (`/seo migration-check <old> <new>`)
- Core checks: redirect chain validation (301 vs 302, max hops), canonical consistency, title/meta preservation, HTTP status codes
- Accept CSV/list of URL pairs as input
- Output: pass/fail summary per URL with specific issues listed

### Testing & Validation
- Automated smoke tests: script that invokes each command with a known URL and checks for expected output patterns
- Test target domain: vanihq.com
- Verify: output includes expected sections, MCP data appears when available, graceful degradation works

### Output Format Standards
- Domain-appropriate formatting: each command category uses its natural format (audits get scores, data commands get tables, briefs get narrative)
- Shared element: every command ends with `## Data Sources` footer showing which MCPs contributed and which were unavailable
- Standard 4-level severity scale for action items: Critical > High > Medium > Low (consistent with existing seo-audit)

</decisions>

<specifics>
## Specific Ideas

- Google's SEO Starter Guide (https://developers.google.com/search/docs/fundamentals/seo-starter-guide) as the authoritative reference for SEO audit checks
- Markdown Guide (https://www.markdownguide.org/) as the authoritative reference for markdown-audit syntax rules
- "I want seo-schema and all original skills to show up in slash-command autocomplete" — this is a deployment fix, not a feature gap
- Test against vanihq.com for smoke tests

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `scripts/fetch_page.py`: HTTP fetching with proper headers — reuse for internal-links crawl and migration-check
- `scripts/parse_html.py`: HTML parsing — reuse for link extraction in internal-links
- `scripts/capture_screenshot.py` + `scripts/analyze_visual.py`: visual analysis pipeline
- `references/mcp-degradation.md`: MCP availability check pattern (ToolSearch-based) — reuse for all overlay implementations
- `references/ahrefs-api-reference.md` + `references/gsc-api-reference.md`: API tool mappings already documented

### Established Patterns
- Self-contained MCP checks: each sub-skill checks its own MCP at execution start (not at orchestrator level)
- YAML frontmatter: all skills use `name`, `description`, `allowed-tools` fields
- Reference files loaded on-demand via @-reference (cwv-thresholds.md, eeat-framework.md, quality-gates.md, schema-types.md)
- Install script deploys to `~/.claude/skills/{skill-name}/SKILL.md`

### Integration Points
- Orchestrator routing table in `skills/seo/SKILL.md` — needs update for command count after Phase 4
- Install script — needs to include all 12 original skills in deployment list
- 38 skill directories already exist in `skills/` — new local commands add 4 more (local SEO reuses seo-geo or gets new dir)

</code_context>

<deferred>
## Deferred Ideas

- **Public MCP release** — MCPs-for-Marketing repo at `/Users/aash-zsbch1500/Desktop/Github projects/MCPs-for-Marketing` contains GSC-MCP, GT-MCP, Reddit-MCP, and others. Making these public is a separate project, not Phase 4 work.
- **GEO/LLM.txt commands** — New `/geo-llm-txt` and AI bot indexing/scraping commands. Concepts like llm.txt, AI crawler management, and AI search optimization are emerging topics that deserve their own phase or milestone. Related: seo-geo already exists but could be expanded.
- **Local SEO command depth** — `/seo local <business>` was not discussed in detail. NAP consistency, Google Business Profile, local schema, citation audit — to be determined during planning.

</deferred>

---

*Phase: 04-enhanced-originals-local-analysis*
*Context gathered: 2026-03-02*
