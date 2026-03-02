---
name: seo
description: >
  Comprehensive SEO analysis for any website or business type. Orchestrates 27 sub-skills
  (12 active, 15 planned): full site audits, single-page analysis, technical SEO (CWV/INP),
  schema markup, E-E-A-T content quality (Dec 2025 QRG), image optimization, sitemaps, and
  GEO for AI Overviews, ChatGPT, Perplexity. Analyzes AI crawlers (GPTBot, ClaudeBot),
  llms.txt, brand signals. Phase 2+ adds live Google Search Console and Ahrefs MCP data.
  Industry detection for SaaS, e-commerce, local, publishers, agencies. Triggers on: "SEO",
  "audit", "schema", "Core Web Vitals", "sitemap", "E-E-A-T", "AI Overviews", "GEO",
  "technical SEO", "content quality", "page speed", "structured data", "GSC", "Ahrefs",
  "backlinks", "keywords", "search console", "domain rating", "keyword rankings".
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - WebFetch
---

# SEO — Universal SEO Analysis Skill

Comprehensive SEO analysis across all industries (SaaS, local services,
e-commerce, publishers, agencies). Orchestrates 27 specialized sub-skills
(12 active, 15 planned) and 6 subagents.

## Quick Reference

### Active Commands (Phase 1)

| Command | What it does | Status |
|---------|-------------|--------|
| `/seo audit <url>` | Full website audit with parallel subagent delegation | active |
| `/seo page <url>` | Deep single-page analysis | active |
| `/seo sitemap <url or generate>` | Analyze or generate XML sitemaps | active |
| `/seo schema <url>` | Detect, validate, and generate Schema.org markup | active |
| `/seo images <url>` | Image optimization analysis | active |
| `/seo technical <url>` | Technical SEO audit (8 categories) | active |
| `/seo content <url>` | E-E-A-T and content quality analysis | active |
| `/seo geo <url>` | AI Overviews / Generative Engine Optimization | active |
| `/seo plan <business-type>` | Strategic SEO planning | active |
| `/seo programmatic [url\|plan]` | Programmatic SEO analysis and planning | active |
| `/seo competitor-pages [url\|generate]` | Competitor comparison page generation | active |
| `/seo hreflang [url]` | Hreflang/i18n SEO audit and generation | active |

### Phase 2 Commands (Live MCP Data)

| Command | What it does | Status |
|---------|-------------|--------|
| `/seo gsc overview <site>` | GSC performance overview (clicks, impressions, CTR, position) | Phase 2 |
| `/seo gsc drops <site>` | Detect keyword/page ranking drops | Phase 2 |
| `/seo gsc opportunities <site>` | Find high-impression, low-CTR opportunities | Phase 2 |
| `/seo gsc pages <site>` | Top performing pages by clicks | Phase 2 |
| `/seo gsc queries <site>` | Top performing queries and brand vs non-brand split | Phase 2 |
| `/seo gsc indexing <site>` | Indexing coverage report | Phase 2 |
| `/seo gsc cannibalization <site>` | Detect keyword cannibalization | Phase 2 |
| `/seo gsc compare <site>` | Period-over-period comparison (MoM, YoY) | Phase 2 |
| `/seo gsc sitemaps <site>` | Sitemap submission and coverage status | Phase 2 |
| `/seo ahrefs overview <domain>` | Domain authority, traffic, and top metrics | Phase 2 |
| `/seo ahrefs backlinks <domain>` | Backlink profile analysis | Phase 2 |
| `/seo ahrefs keywords <domain>` | Organic keyword rankings | Phase 2 |
| `/seo ahrefs competitors <domain>` | Identify organic competitors | Phase 2 |
| `/seo ahrefs content-gap <domain>` | Keywords competitors rank for, you don't | Phase 2 |
| `/seo ahrefs broken-links <domain>` | Find broken backlinks to reclaim | Phase 2 |
| `/seo ahrefs new-links <domain>` | New referring domains (last 30 days) | Phase 2 |
| `/seo ahrefs anchor-analysis <domain>` | Anchor text distribution analysis | Phase 2 |
| `/seo ahrefs dr-history <domain>` | Domain Rating history trend | Phase 2 |
| `/seo ahrefs top-pages <domain>` | Top pages by organic traffic | Phase 2 |
| `/seo markdown-audit <path>` | Markdown SEO audit (no MCP needed) | Phase 2 |

### Phase 3 Commands (Multi-MCP)

| Command | What it does | Status |
|---------|-------------|--------|
| `/seo serp <keyword>` | Live SERP analysis via Ahrefs + WebMCP | Phase 3 |
| `/seo content-brief <keyword>` | AI content brief from SERP data | Phase 3 |
| `/seo brand-radar <brand>` | AI search brand monitoring via Ahrefs Brand Radar | Phase 3 |
| `/seo site-audit-pro <domain>` | Flagship multi-MCP audit (sequential wave architecture) | Phase 3 |
| `/seo report <type> <domain>` | Automated report generation from available MCP data | Phase 3 |

## Orchestration Logic

When the user invokes `/seo audit`, delegate to subagents in parallel:
1. Detect business type (SaaS, local, ecommerce, publisher, agency, other)
2. Spawn subagents: seo-technical, seo-content, seo-schema, seo-sitemap, seo-performance, seo-visual
3. Collect results and generate unified report with SEO Health Score (0-100)
4. Create prioritized action plan (Critical → High → Medium → Low)

For individual commands, load the relevant sub-skill directly.

**Logic ownership:** All command logic lives in each sub-skill's SKILL.md (not in agent files). Agents are only used for parallel audit work within `/seo audit`.

## Command Routing

### Level 1: Command Group Detection

When the user invokes `/seo <command>`:
1. Match against the routing table below
2. If exact match with active command → load the sub-skill SKILL.md directly
3. If group match (gsc, ahrefs) → extract sub-command and route to specific sub-skill via Level 2 routing
4. If Phase 2+ command and sub-skill directory does not exist → return "Not Yet Available" message (see below)
5. If no match → suggest the closest command from the Quick Reference table

### Level 2: Sub-command Routing

For grouped commands, extract the sub-command and route to the specific sub-skill:

**GSC sub-commands** (all require GSC MCP — see `references/mcp-degradation.md`):
- `/seo gsc overview <site>` → load `seo-gsc-overview/SKILL.md`
- `/seo gsc drops <site>` → load `seo-gsc-drops/SKILL.md`
- `/seo gsc opportunities <site>` → load `seo-gsc-opportunities/SKILL.md`
- `/seo gsc pages <site>` → load `seo-gsc-pages/SKILL.md`
- `/seo gsc queries <site>` → load `seo-gsc-queries/SKILL.md`
- `/seo gsc indexing <site>` → load `seo-gsc-indexing/SKILL.md`
- `/seo gsc cannibalization <site>` → load `seo-gsc-cannibalization/SKILL.md`
- `/seo gsc compare <site>` → load `seo-gsc-compare/SKILL.md`
- `/seo gsc sitemaps <site>` → load `seo-gsc-sitemaps/SKILL.md`

**Ahrefs sub-commands** (all require Ahrefs MCP — see `references/mcp-degradation.md`):
- `/seo ahrefs overview <domain>` → load `seo-ahrefs-overview/SKILL.md`
- `/seo ahrefs backlinks <domain>` → load `seo-ahrefs-backlinks/SKILL.md`
- `/seo ahrefs keywords <domain>` → load `seo-ahrefs-keywords/SKILL.md`
- `/seo ahrefs competitors <domain>` → load `seo-ahrefs-competitors/SKILL.md`
- `/seo ahrefs content-gap <domain>` → load `seo-ahrefs-content-gap/SKILL.md`
- `/seo ahrefs broken-links <domain>` → load `seo-ahrefs-broken-links/SKILL.md`
- `/seo ahrefs new-links <domain>` → load `seo-ahrefs-new-links/SKILL.md`
- `/seo ahrefs anchor-analysis <domain>` → load `seo-ahrefs-anchor-analysis/SKILL.md`
- `/seo ahrefs dr-history <domain>` → load `seo-ahrefs-dr-history/SKILL.md`
- `/seo ahrefs top-pages <domain>` → load `seo-ahrefs-top-pages/SKILL.md`

### Routing Table

Full mapping of all 27 commands to sub-skill directory names:

| Command | Sub-skill Directory | Status |
|---------|--------------------|----|
| `/seo audit` | `seo-audit/` | active |
| `/seo page` | `seo-page/` | active |
| `/seo sitemap` | `seo-sitemap/` | active |
| `/seo schema` | `seo-schema/` | active |
| `/seo images` | `seo-images/` | active |
| `/seo technical` | `seo-technical/` | active |
| `/seo content` | `seo-content/` | active |
| `/seo geo` | `seo-geo/` | active |
| `/seo plan` | `seo-plan/` | active |
| `/seo programmatic` | `seo-programmatic/` | active |
| `/seo competitor-pages` | `seo-competitor-pages/` | active |
| `/seo hreflang` | `seo-hreflang/` | active |
| `/seo gsc overview` | `seo-gsc-overview/` | Phase 2 |
| `/seo gsc drops` | `seo-gsc-drops/` | Phase 2 |
| `/seo gsc opportunities` | `seo-gsc-opportunities/` | Phase 2 |
| `/seo gsc pages` | `seo-gsc-pages/` | Phase 2 |
| `/seo gsc queries` | `seo-gsc-queries/` | Phase 2 |
| `/seo gsc indexing` | `seo-gsc-indexing/` | Phase 2 |
| `/seo gsc cannibalization` | `seo-gsc-cannibalization/` | Phase 2 |
| `/seo gsc compare` | `seo-gsc-compare/` | Phase 2 |
| `/seo gsc sitemaps` | `seo-gsc-sitemaps/` | Phase 2 |
| `/seo ahrefs overview` | `seo-ahrefs-overview/` | Phase 2 |
| `/seo ahrefs backlinks` | `seo-ahrefs-backlinks/` | Phase 2 |
| `/seo ahrefs keywords` | `seo-ahrefs-keywords/` | Phase 2 |
| `/seo ahrefs competitors` | `seo-ahrefs-competitors/` | Phase 2 |
| `/seo ahrefs content-gap` | `seo-ahrefs-content-gap/` | Phase 2 |
| `/seo ahrefs broken-links` | `seo-ahrefs-broken-links/` | Phase 2 |
| `/seo ahrefs new-links` | `seo-ahrefs-new-links/` | Phase 2 |
| `/seo ahrefs anchor-analysis` | `seo-ahrefs-anchor-analysis/` | Phase 2 |
| `/seo ahrefs dr-history` | `seo-ahrefs-dr-history/` | Phase 2 |
| `/seo ahrefs top-pages` | `seo-ahrefs-top-pages/` | Phase 2 |
| `/seo markdown-audit` | `seo-markdown-audit/` | Phase 2 |
| `/seo serp` | `seo-serp/` | Phase 3 |
| `/seo content-brief` | `seo-content-brief/` | Phase 3 |
| `/seo brand-radar` | `seo-brand-radar/` | Phase 3 |
| `/seo site-audit-pro` | `seo-site-audit-pro/` | Phase 3 |
| `/seo report` | `seo-report/` | Phase 3 |

### Unavailable Command Response

If a command is marked as Phase 2+ and its sub-skill directory does not exist:
1. Tell the user: "`[command]` is planned for [Phase N] and not yet available."
2. Suggest an alternative from the active commands that provides partial value.
3. Do NOT attempt to fabricate the functionality inline.

Example response for unavailable command:
```
/seo gsc overview is planned for Phase 2 and not yet available.

While waiting, you can use:
- `/seo technical <url>` — static technical SEO audit without live GSC data
- `/seo audit <url>` — full site audit using available static analysis
```

## Industry Detection

Detect business type from homepage signals:
- **SaaS**: pricing page, /features, /integrations, /docs, "free trial", "sign up"
- **Local Service**: phone number, address, service area, "serving [city]", Google Maps embed
- **E-commerce**: /products, /collections, /cart, "add to cart", product schema
- **Publisher**: /blog, /articles, /topics, article schema, author pages, publication dates
- **Agency**: /case-studies, /portfolio, /industries, "our work", client logos

## Quality Gates

Read `references/quality-gates.md` for thin content thresholds per page type.
Hard rules:
- WARNING at 30+ location pages (enforce 60%+ unique content)
- HARD STOP at 50+ location pages (require user justification)
- Never recommend HowTo schema (deprecated Sept 2023)
- FAQ schema only for government and healthcare sites
- All Core Web Vitals references use INP, never FID

## Reference Files

Load these on-demand as needed — do NOT load all at startup:
- `references/cwv-thresholds.md` — Current Core Web Vitals thresholds and measurement details
- `references/schema-types.md` — All supported schema types with deprecation status
- `references/eeat-framework.md` — E-E-A-T evaluation criteria (Sept 2025 QRG update)
- `references/quality-gates.md` — Content length minimums, uniqueness thresholds
- `references/mcp-degradation.md` — MCP availability checks, error templates, fallback mapping
- `references/ahrefs-api-reference.md` — Ahrefs MCP tool mapping, response fields, monetary conversion
- `references/gsc-api-reference.md` — GSC MCP tool mapping, property formats, response fields

## Scoring Methodology

### SEO Health Score (0-100)
Weighted aggregate of all categories:

| Category | Weight |
|----------|--------|
| Technical SEO | 25% |
| Content Quality | 25% |
| On-Page SEO | 20% |
| Schema / Structured Data | 10% |
| Performance (CWV) | 10% |
| Images | 5% |
| AI Search Readiness | 5% |

### Priority Levels
- **Critical**: Blocks indexing or causes penalties (immediate fix required)
- **High**: Significantly impacts rankings (fix within 1 week)
- **Medium**: Optimization opportunity (fix within 1 month)
- **Low**: Nice to have (backlog)

## Sub-Skills

This skill orchestrates 27 specialized sub-skills (12 active, 15 planned):

**Active (Phase 1):**
1. **seo-audit** — Full website audit with parallel delegation
2. **seo-page** — Deep single-page analysis
3. **seo-technical** — Technical SEO (8 categories)
4. **seo-content** — E-E-A-T and content quality
5. **seo-schema** — Schema markup detection and generation
6. **seo-images** — Image optimization
7. **seo-sitemap** — Sitemap analysis and generation
8. **seo-geo** — AI Overviews / GEO optimization
9. **seo-plan** — Strategic planning with templates
10. **seo-programmatic** — Programmatic SEO analysis and planning
11. **seo-competitor-pages** — Competitor comparison page generation
12. **seo-hreflang** — Hreflang/i18n SEO audit and generation

**Phase 2 (GSC MCP — requires GSC MCP registration):**
13. **seo-gsc-overview** — GSC performance dashboard
14. **seo-gsc-drops** — Ranking drop detection
15. **seo-gsc-opportunities** — High-impression, low-CTR opportunity finder
16. **seo-gsc-pages** — Top pages by clicks
17. **seo-gsc-queries** — Top queries with brand/non-brand split
18. **seo-gsc-indexing** — Indexing coverage report
19. **seo-gsc-cannibalization** — Keyword cannibalization detection
20. **seo-gsc-compare** — Period-over-period comparison
21. **seo-gsc-sitemaps** — Sitemap submission and coverage

**Phase 2 (Ahrefs MCP):**
22. **seo-ahrefs-overview** — Domain authority and top metrics
23. **seo-ahrefs-backlinks** — Backlink profile analysis
24. **seo-ahrefs-keywords** — Organic keyword rankings
25. **seo-ahrefs-competitors** — Organic competitor identification
26. **seo-ahrefs-content-gap** — Content gap analysis
27. **seo-ahrefs-broken-links** — Broken backlink recovery
28. **seo-ahrefs-new-links** — New referring domain monitoring
29. **seo-ahrefs-anchor-analysis** — Anchor text distribution
30. **seo-ahrefs-dr-history** — Domain Rating history
31. **seo-ahrefs-top-pages** — Top pages by organic traffic
32. **seo-markdown-audit** — Markdown file SEO audit

**Phase 3 (Multi-MCP):**
33. **seo-serp** — Live SERP analysis
34. **seo-content-brief** — AI content brief from SERP data
35. **seo-brand-radar** — Brand monitoring via Ahrefs Brand Radar
36. **seo-site-audit-pro** — Flagship multi-MCP audit (sequential wave)
37. **seo-report** — Automated report generation

## Subagents

For parallel analysis during audits:
- `seo-technical` — Crawlability, indexability, security, CWV
- `seo-content` — E-E-A-T, readability, thin content
- `seo-schema` — Detection, validation, generation
- `seo-sitemap` — Structure, coverage, quality gates
- `seo-performance` — Core Web Vitals measurement
- `seo-visual` — Screenshots, mobile testing, above-fold
