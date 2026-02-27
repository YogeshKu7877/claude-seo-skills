# Claude SEO Skill — Feature Expansion

## What This Is

A comprehensive SEO analysis toolkit built as Claude Code skills (slash commands) that combines live data from Ahrefs MCP, Google Search Console MCP, and RSS feeds with existing static analysis capabilities. It recreates and enhances the open-source claude-seo tool with 15 new data-driven commands, turning Claude Code into a full SEO workstation. Built for personal SEO work and published publicly for the community.

## Core Value

Every /seo command delivers actionable SEO insights using real data from connected MCPs — not estimates or static analysis alone.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Recreate and enhance the 12 original claude-seo commands as Claude Code skills
- [ ] Build 15 new /seo commands that leverage Ahrefs MCP, GSC MCP, and RSS feeds
- [ ] Commands work as Claude Code skills (slash commands) following the existing pattern
- [ ] Ahrefs MCP integration for backlinks, keywords, DR, competitor analysis, SERP data, brand radar
- [ ] GSC MCP integration for real clicks, impressions, CTR, index status, content decay
- [ ] Cross-MCP commands that combine Ahrefs + GSC data for deeper insights
- [ ] Markdown audit command for pre-publish SEO checks (no MCP needed)
- [ ] Content brief generation from SERP analysis
- [ ] Automated report generation in markdown format
- [ ] Server log analysis for crawl pattern insights
- [ ] Internal link structure analysis and optimization suggestions
- [ ] Site migration validation
- [ ] AI content detection and authenticity optimization
- [ ] Local SEO audit capabilities
- [ ] Brand monitoring via Ahrefs Brand Radar for AI search visibility

### Out of Scope

- n8n automation workflows — deferred to future milestone
- Google Drive/Gmail/Canva/Calendar integrations — MCPs not connected yet
- PPTX/Google Doc output formats — markdown first
- WebMCP browser automation — not connected yet, can add later
- Google Ads Transparency MCP — not connected yet
- Zoho Cliq notifications — not connected yet
- Real-time competitor monitoring (requires n8n) — deferred

## Context

- **Base repo:** Existing open-source claude-seo at `/Users/aash-zsbch1500/Downloads/claude-seo-main` — will be studied and adapted, not forked
- **Architecture:** Claude Code skills pattern — each command is a skill definition with agent/subagent orchestration
- **Connected MCPs:** Ahrefs (full API v3), Google Search Console (custom-built), RSS feeds
- **MCPs to add later:** WebMCP, Google Drive, Gmail, Canva, n8n, Google Ads Transparency
- **Target:** 27 total commands (12 enhanced originals + 15 new)
- **Priority order:** Tier 1 (GSC, Ahrefs, markdown-audit, site-audit-pro, content-brief) → Tier 2 (brand-radar, serp, ads-intel, report, competitor-monitor) → Tier 3 (internal-links, ai-content-check, log-analysis, local, migration-check)

## Constraints

- **MCP availability:** Commands requiring unconnected MCPs (WebMCP, Google Ads Transparency) should gracefully degrade or skip those data sources
- **Ahrefs API:** Monetary values returned in USD cents — must divide by 100 for display
- **Skill pattern:** Must follow Claude Code skill conventions for discoverability and invocation
- **Public release:** Code must be clean, documented, and installable by others

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Claude Code skills (not standalone CLI) | Matches existing claude-seo pattern, leverages Claude's AI capabilities | — Pending |
| Ahrefs + GSC as primary data sources | These MCPs are connected and working now | — Pending |
| Markdown-only output for v1 | Simplest format, works everywhere, other formats need more MCPs | — Pending |
| Recreate rather than fork claude-seo | Opportunity to improve architecture while adding new capabilities | — Pending |
| Commands only, no automation workflows | Reduces scope, automation needs n8n which is a separate concern | — Pending |

---
*Last updated: 2026-02-27 after initialization*
