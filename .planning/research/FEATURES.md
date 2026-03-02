# Feature Landscape

**Domain:** AI-powered SEO analysis skill system (Claude Code skills using Ahrefs API + GSC MCP)
**Researched:** 2026-03-02
**Confidence:** MEDIUM-HIGH (project spec detailed; market context verified via web search; MCP capabilities inferred from skill source code)

---

## Context: What the Existing claude-seo Tool Already Covers

The open-source claude-seo repo (the baseline being enhanced) already implements 12 static-crawl skills:

| Existing Skill | What It Does | Data Source |
|----------------|-------------|-------------|
| `seo-audit` | Full site audit, health score 0-100, parallel subagents | WebFetch + scripts |
| `seo-technical` | 8-category technical audit (crawlability, CWV, JS rendering, etc.) | WebFetch + scripts |
| `seo-content` | E-E-A-T analysis, readability, AI citation readiness | WebFetch |
| `seo-schema` | Schema detection, validation, generation | WebFetch |
| `seo-sitemap` | Sitemap analysis and generation | WebFetch |
| `seo-images` | Image alt text, format, compression | WebFetch |
| `seo-geo` | GEO/AI Overviews optimization, llms.txt, AI crawler access | WebFetch |
| `seo-plan` | Strategic SEO planning | Claude reasoning |
| `seo-programmatic` | Programmatic SEO analysis | WebFetch |
| `seo-competitor-pages` | Competitor comparison page generation | WebFetch |
| `seo-hreflang` | International SEO, hreflang audits | WebFetch |
| `seo-page` | Deep single-page analysis | WebFetch |

**Critical gap in existing tool:** No live data. Zero Ahrefs integration. Zero GSC integration. Every metric is estimated from static crawl output.

The new skill expansion closes this gap: 15 new commands that add live Ahrefs + GSC data on top of re-implemented and enhanced versions of the 12 originals.

---

## Table Stakes

Features users expect from any professional SEO tool. Missing = product feels incomplete or inferior to free alternatives.

| Feature | Why Expected | Complexity | Skill(s) | Notes |
|---------|--------------|------------|---------|-------|
| **Keyword ranking data** (real positions, volume, difficulty) | All professional tools (Ahrefs, Semrush, Moz) provide this | Low | `seo-ahrefs keywords` | Ahrefs API endpoint: `keyword-rankings`, `top-keywords` |
| **Organic traffic estimation** | Standard in every SEO tool | Low | `seo-ahrefs overview` | Ahrefs provides traffic value in USD cents — must divide by 100 |
| **Backlink profile** (count, referring domains, DR, dofollow ratio) | Ahrefs invented the DR metric; users expect this | Low | `seo-ahrefs backlinks` | Core Ahrefs API feature |
| **Domain Rating (DR)** | The industry-standard authority metric | Low | `seo-ahrefs overview` | Single API call |
| **Competitor identification** | Every SEO audit includes competitive landscape | Medium | `seo-ahrefs competitors` | Organic competitors by keyword overlap |
| **Real search performance data** (clicks, impressions, CTR, position) | GSC is the authoritative source; estimates are no substitute | Low | `seo-gsc overview` | GSC MCP is connected — this is the single biggest upgrade over the existing tool |
| **Indexing status** (indexed vs not indexed + reasons) | Critical for any site audit | Medium | `seo-gsc index-issues` | GSC coverage report via MCP |
| **Content gap analysis** | Standard for competitive research workflows | Medium | `seo-ahrefs content-gap` | Ahrefs API: keywords competitors rank for that target doesn't |
| **Technical SEO audit** (crawlability, robots.txt, canonical, CWV) | Table stakes — existing tool already does this | High | Enhanced `seo-technical` | Upgrade existing with GSC data overlay |
| **On-page analysis** (title, H1, meta description, internal links) | Every SEO tool does this | Low-Med | Enhanced `seo-page`, `seo-audit` | Already implemented; enhance with keyword data |
| **Keyword cannibalization detection** | Standard GSC analysis; missed traffic is invisible without it | Medium | `seo-gsc cannibalization` | Multiple pages ranking for same query = split signals |
| **Traffic drop detection** | Users expect a "what broke?" answer quickly | Medium | `seo-gsc drops` | Compare 28-day vs prior period per page/keyword |
| **Sitemap analysis and validation** | Present in original tool; must carry forward | Low | Enhanced `seo-sitemap` | Already implemented |
| **Schema markup detection + generation** | Table stakes for e-commerce/local/publisher sites | Medium | Enhanced `seo-schema` | Already implemented; add validation against current Google supported types |
| **Markdown pre-publish audit** | Expected by developer/content teams publishing markdown; zero alternatives exist in CLI-native tools | Low | `seo-markdown-audit` | Checks title, meta, headings, internal links, alt text, frontmatter — no MCP required |

---

## Differentiators

Features that set this system apart from both the original claude-seo tool AND from web-based tools like Ahrefs/Semrush dashboard. These represent the genuine competitive advantage of an AI+MCP combo built into the developer's editing environment.

| Feature | Value Proposition | Complexity | Skill(s) | Why Differentiating |
|---------|-------------------|------------|---------|---------------------|
| **Cross-MCP synthesis** (Ahrefs + GSC combined) | "You rank #8 for X with 5,000 impressions and 2% CTR. Competitors in positions 1-3 have 45+ DR. You need 150 more quality backlinks to compete." — No dashboard does this cross-correlation automatically. | High | `seo-site-audit-pro`, `seo-full-audit` | Ahrefs tells you competitors. GSC tells you your real position. Claude synthesizes the gap and the specific action. |
| **AI Search Brand Visibility** (Brand Radar) | Track how often ChatGPT, Perplexity, Claude mention your brand — the new GEO KPI that no traditional tool covers natively | Medium | `seo-brand-radar` | Ahrefs Brand Radar MCP integration. In 2026, AI citation = organic reach for AI-first queries. Ahrefs Dec 2025 study: brand mentions correlate 3x stronger with AI citations than backlinks. |
| **Content brief from live SERP** | SERP analysis → top-5 structure extraction → AI-generated brief targeting real keyword difficulty + internal link suggestions from your own GSC data | High | `seo-content-brief` | Tools like Frase.io and Semrush Brief Generator do this but require leaving Claude. This brings it into the workflow with site-specific GSC data for internal link recommendations. |
| **Content decay detection** | Find pages that peaked and are losing traffic before they drop off page 1 — GSC 90-day comparison with Ahrefs competitor context | Medium | `seo-gsc content-decay` | GSC API comparison query. Existing tools surface this in dashboards; this surfaces it in Claude with prioritized refresh recommendations. |
| **Quick-win keyword opportunities** | High impressions + low CTR = the easiest traffic you're leaving on the table. Claude explains WHY and drafts title tag rewrites. | Low-Med | `seo-gsc opportunities` | The algorithmic detection is simple; the AI-generated fix (title, meta, structured snippet suggestion) is what makes it actionable vs just a data table. |
| **Flagship parallel-agent site audit** | 10+ parallel subagents covering technical, content, backlink, keyword, search performance, AI visibility, competitor gap, content decay, ad intelligence — single command, comprehensive report | Very High | `seo-site-audit-pro` | Combines everything. No web tool gives you a 30/60/90 day roadmap with an effort-vs-impact matrix generated from your actual data. |
| **Live SERP analysis with intent classification** | What content format ranks? (listicle vs guide vs tool vs comparison) — helps match user intent before creating content | Medium | `seo-serp` | Ahrefs SERP Overview API + Claude reasoning about format patterns. Saves a manual 20-minute SERP audit. |
| **Server log analysis for crawl budget** | Googlebot crawl patterns, crawl budget waste, orphan pages in logs vs sitemap — advanced, zero web-UI tools do this well for individual sites | Medium | `seo-log-analysis` | No MCP required — parses Apache/Nginx log files locally. Differentiates for technical SEO specialists. |
| **AI content authenticity check** | Detect low-E-E-A-T signals, generic AI phrasing, burstiness patterns — and generate specific rewrite suggestions | Medium | `seo-ai-content-check` | Post-Sept 2025 QRG: Google raters now formally assess AI-generated content. Tools don't provide actionable rewrite suggestions inline. |
| **Internal link graph + orphan page detection** | Build the actual link graph, find orphan pages, generate contextual link suggestions with anchor text | High | `seo-internal-links` | High value but complex. Most tools show counts; this generates the specific links to add with copy-pasteable anchor text. |
| **Site migration validator** | Cross-reference GSC top pages against redirect map to ensure no high-traffic URL was missed | High | `seo-migration-check` | Critical and situational. The GSC integration makes this actually reliable — instead of guessing which pages matter, you know from real click data. |
| **Competitor ad intelligence** | What ads is competitor X running, what headlines, what landing pages? — without leaving Claude | Medium | `seo-ads-intel` | Google Ads Transparency MCP integration (already connected per seo-skill-expansion.md). |
| **Automated reporting pipeline** | `seo-report monthly` → pull GSC + Ahrefs → generate markdown report → (later) save to Drive, email | Medium | `seo-report` | v1: markdown output only. The intelligence is in the AI-generated insights layered on top of data, not just the data table. |
| **New keyword discovery** | Keywords you recently started ranking for — growth opportunities before competitors notice | Low | `seo-gsc new-keywords` | GSC date-range comparison. Easy to build, high signal for content expansion strategy. |
| **Brand vs non-brand traffic split** | Understand how dependent your traffic is on brand awareness vs discovery | Low | `seo-gsc brand-vs-nonbrand` | Filter GSC queries by brand name. Directionally important for SEO strategy. |

---

## Anti-Features

Features to explicitly NOT build in v1 of this skill expansion. These are either premature, require unconnected MCPs, or create scope creep that dilutes quality of the core build.

| Anti-Feature | Why Avoid | What to Do Instead |
|--------------|-----------|-------------------|
| **Real-time automated competitor monitoring** (set-and-forget alerts) | Requires n8n automation workflows — explicitly deferred in PROJECT.md | Build `seo-competitor-monitor` as an on-demand command only in v1; automation workflows are a separate milestone |
| **PPTX / Google Doc / PDF output** | Requires MCPs not yet integrated in v1 (Canva, Google Drive, PDF skill) | Markdown output only in v1; clean markdown is parseable by downstream tools |
| **Zoho Cliq / Gmail notification integrations** | Requires n8n and Gmail MCP; automation deferred | Document that `seo-report` output can be pasted into any notification tool manually |
| **Google Ads Transparency integration (`seo-ads-intel`)** | Per PROJECT.md constraints, Google Ads Transparency MCP "not connected yet" — contradicts seo-skill-expansion.md which lists it as connected. Resolve before building. | Verify actual MCP connection status before starting this skill; build with graceful degradation if not connected |
| **Local SEO audit (`seo-local`)** | Situational — only useful for businesses with physical locations. Requires Google Business Profile data which is not accessible via current connected MCPs | Build as Tier 3 only after Tier 1 and 2 are solid; it won't leverage Ahrefs or GSC in any differentiated way |
| **WebMCP browser crawling dependency** | PROJECT.md lists WebMCP as "not connected yet" but seo-skill-expansion.md marks it as connected — contradictory. Skills that require live page DOM inspection via WebMCP will break if it's not actually connected. | Audit actual MCP connection state first. For `seo-serp` and `seo-content-brief`, design to work from Ahrefs SERP data alone with graceful degradation if WebMCP unavailable |
| **Backlink outreach email drafts** | Requires Gmail MCP integration for full value; creates scope bleed into outreach tools | Provide outreach _angles_ and target lists as text output; email drafting is a separate workflow |
| **Rank tracking dashboard** (historical position charts) | Requires persistent data storage between sessions; Claude Code has no session persistence by default | Provide current-state snapshots only; long-term trend tracking requires external storage (future milestone) |
| **Automated monthly report scheduling** | n8n deferred; scheduling requires persistent process | Manual invocation only in v1: `seo-report monthly <domain>` on-demand |
| **SEO scoring gamification / badge systems** | Zero value for professional use case; adds UI complexity | Health scores (0-100) are sufficient; no achievement mechanics needed |
| **Natural language query interface** ("show me my worst pages") | Claude already handles this natively — no separate NLU layer needed | All commands already work conversationally because they run inside Claude Code |

---

## Feature Dependencies

Understanding which features must be built before others — critical for phase ordering.

```
GSC MCP connection verified
  → seo-gsc overview (GSC dashboard — simplest GSC feature, build first)
    → seo-gsc drops (requires overview baseline)
    → seo-gsc opportunities (requires overview baseline)
    → seo-gsc content-decay (requires drops + date comparison)
    → seo-gsc cannibalization (requires keyword-level GSC data)
    → seo-gsc brand-vs-nonbrand (requires query filtering)
    → seo-gsc new-keywords (requires date-range comparison)
    → seo-gsc index-issues (requires coverage data from GSC)

Ahrefs MCP connection verified
  → seo-ahrefs overview (DR, backlinks, keywords — simplest Ahrefs feature, build first)
    → seo-ahrefs backlinks (requires domain context)
    → seo-ahrefs keywords (requires domain context)
    → seo-ahrefs competitors (requires keyword data)
      → seo-ahrefs content-gap (requires competitors list)
    → seo-serp (SERP overview endpoint — standalone)
      → seo-content-brief (requires SERP data + GSC internal link data)

seo-gsc overview + seo-ahrefs overview
  → seo-site-audit-pro (requires both MCPs + enhanced original skills)
  → seo-full-audit (cross-MCP synthesis command)

seo-gsc content-decay + seo-ahrefs competitors
  → most useful combined in seo-site-audit-pro

seo-ahrefs keywords + seo-serp
  → seo-content-brief (most useful combined)

Enhanced originals (no MCP dependency):
  seo-audit → seo-technical → seo-content → seo-schema → seo-sitemap → seo-images → seo-geo → seo-page
  (these can be built in parallel with MCP skills — no cross-dependency)

No dependencies (standalone):
  seo-markdown-audit (local file analysis only)
  seo-log-analysis (local file analysis only)
  seo-brand-radar (Ahrefs Brand Radar endpoint — separate from main Ahrefs skills)
  seo-migration-check (GSC + optional redirect map CSV)
  seo-ai-content-check (URL fetch + Claude reasoning — WebMCP optional)
  seo-report (aggregates output from other skills)
  seo-internal-links (WebMCP + optional Ahrefs — complex standalone)
```

---

## MVP Recommendation

**Build in this order to deliver the fastest real value:**

### Tier 1 — Core Live Data Skills (Build First)

These deliver the largest delta vs the existing static-analysis tool. Each one unlocks live data that users currently cannot get from the original claude-seo.

1. **`seo-gsc overview`** + `drops` + `opportunities` — GSC is connected. These three sub-commands alone make the tool 10x more useful for any site already receiving search traffic. Complexity: Low.
2. **`seo-ahrefs overview`** + `backlinks` + `keywords` — Same rationale. Ahrefs is connected. Start with the most-requested data points. Complexity: Low.
3. **`seo-markdown-audit`** — No MCP required. Immediately useful for content teams. Zero dependencies. Complexity: Low.
4. **`seo-ahrefs competitors`** + `content-gap` — The first truly AI-differentiated feature: Claude explains which keywords competitors have that you don't, and why. Complexity: Medium.
5. **`seo-gsc content-decay`** + `cannibalization` — The second most-requested GSC analysis type after overview. Complexity: Medium.

### Tier 2 — Differentiating Features (Build Next)

6. **`seo-content-brief`** — High demand from content teams. Requires Ahrefs SERP + GSC internal link data — both now available. Complexity: High.
7. **`seo-brand-radar`** — AI search visibility is the 2026 hot topic. Ahrefs Brand Radar endpoint. Complexity: Medium.
8. **`seo-serp`** — Essential for keyword research workflows. Standalone. Complexity: Medium.
9. **`seo-site-audit-pro`** — The flagship. Requires Tier 1 skills to be stable first. Complexity: Very High.
10. **`seo-report`** — Aggregates output from all other skills. Complexity: Medium.

### Tier 3 — Enhanced Originals + Niche Skills (Carry Forward)

11. Enhanced `seo-audit`, `seo-technical`, `seo-content`, `seo-schema`, `seo-geo`, `seo-page` — Rebuild with improved architecture and GSC/Ahrefs data overlays where applicable.
12. **`seo-internal-links`** — Complex but high value. Complexity: High.
13. **`seo-ai-content-check`** — Growing demand. Complexity: Medium.
14. **`seo-log-analysis`** — Advanced users only. Complexity: Medium.
15. **`seo-migration-check`** — Situational but critical. Build only when a migration is imminent.
16. **`seo-local`** — Lowest priority. Only for physical location clients.

### Defer (Not v1)

- `seo-competitor-monitor` as automated set-and-forget (n8n deferred)
- `seo-ads-intel` (verify MCP status first — conflicting info in spec docs)
- Any output format beyond markdown (Drive, PPTX, Canva)
- Scheduled automated reports

---

## Feature Complexity Reference

| Skill | Complexity | Primary Blocker |
|-------|-----------|-----------------|
| `seo-gsc overview` | Low | GSC MCP auth |
| `seo-gsc drops` | Low | GSC MCP date filtering |
| `seo-gsc opportunities` | Low | GSC MCP CTR filtering |
| `seo-gsc cannibalization` | Medium | Multiple queries same page detection logic |
| `seo-gsc content-decay` | Medium | 90-day period comparison |
| `seo-gsc index-issues` | Medium | GSC coverage API |
| `seo-ahrefs overview` | Low | Ahrefs API units cost |
| `seo-ahrefs backlinks` | Low | Ahrefs API units cost |
| `seo-ahrefs keywords` | Low | Ahrefs API units cost |
| `seo-ahrefs competitors` | Medium | Keyword overlap algorithm |
| `seo-ahrefs content-gap` | Medium | Multi-domain comparison |
| `seo-markdown-audit` | Low | None — file read only |
| `seo-log-analysis` | Medium | Log format parsing (Apache/Nginx variants) |
| `seo-serp` | Medium | Ahrefs SERP endpoint + format classification |
| `seo-content-brief` | High | Multi-source synthesis (SERP + GSC + Claude reasoning) |
| `seo-brand-radar` | Medium | Ahrefs Brand Radar endpoint availability |
| `seo-site-audit-pro` | Very High | Parallel agent orchestration across all MCPs |
| `seo-report` | Medium | Aggregation across multiple skills |
| `seo-internal-links` | High | Link graph construction + PageRank distribution |
| `seo-ai-content-check` | Medium | E-E-A-T signal detection heuristics |
| `seo-migration-check` | High | Redirect map parsing + GSC top page cross-reference |
| `seo-local` | Medium | No native MCP for GBP data |
| Enhanced `seo-audit` | High | Full rebuild + MCP integration layer |
| Enhanced `seo-technical` | Medium | Add GSC index coverage overlay |
| Enhanced `seo-content` | Medium | Add AI content assessment module |
| Enhanced `seo-geo` | Low | Already comprehensive — minor updates only |

---

## Confidence Assessment

| Area | Confidence | Basis |
|------|------------|-------|
| What existing claude-seo covers | HIGH | Read source code directly |
| Table stakes features | HIGH | Verified against Ahrefs/GSC official API docs + web search on professional tool feature sets |
| Differentiators | MEDIUM | Web search verified; Ahrefs Brand Radar endpoint existence confirmed via search but not tested against actual MCP tools available |
| Anti-features | MEDIUM | Based on PROJECT.md constraints + deferred scope list; MCP connection status contradictions between PROJECT.md and seo-skill-expansion.md should be validated before building |
| Feature dependencies | HIGH | Derived from skill architecture analysis — dependencies are structural, not speculative |
| Complexity ratings | MEDIUM | Estimated from skill design; actual complexity depends on MCP API response shapes which require testing |

---

## Open Questions

1. **WebMCP connection status conflict:** PROJECT.md says "not connected yet" but seo-skill-expansion.md marks it as connected. Which is current? This affects `seo-serp`, `seo-content-brief`, `seo-internal-links`, and `seo-ai-content-check` design.

2. **Google Ads Transparency MCP conflict:** Same issue — PROJECT.md says "not connected yet" but expansion doc says connected. If not connected, `seo-ads-intel` cannot be built in v1.

3. **Ahrefs Brand Radar API endpoint:** Confirmed available in Ahrefs API v3 via web search, but actual endpoint name and response schema need verification against the connected MCP before building `seo-brand-radar`.

4. **Ahrefs API unit costs:** "The minimum cost for any request is 50 units." Need to understand the unit budget for the enterprise plan in use — this affects how aggressively `seo-site-audit-pro` can call the API in parallel.

5. **GSC property format:** Does the connected GSC MCP require site URLs in `sc-domain:` or `https://` format? Affects command parameter design for all `seo-gsc` skills.

---

## Sources

- Existing claude-seo skill files (read directly): `/Users/aash-zsbch1500/Desktop/Github projects/claude-seo-main/skills/` and `seo/SKILL.md`
- Project spec (read directly): `/Users/aash-zsbch1500/Desktop/Github projects/SEO/.planning/PROJECT.md`
- Feature expansion masterplan (read directly): `/Users/aash-zsbch1500/Desktop/Github projects/SEO/seo-skill-expansion.md`
- [Ahrefs API v3 Documentation](https://docs.ahrefs.com/docs/api/reference/introduction) — MEDIUM confidence (confirmed existence and endpoints via search)
- [Ahrefs: About API v3 for Enterprise Plan](https://help.ahrefs.com/en/articles/6559232-about-api-v3-for-enterprise-plan) — MEDIUM confidence
- [Google Search Console API Overview](https://developers.google.com/webmaster-tools) — HIGH confidence (official)
- [Modern SEO Stack for 2026](https://www.searchseo.io/blog/modern-seo-stack) — LOW confidence (single source)
- [AI SEO Tracking Tools 2026 Analysis](https://www.searchinfluence.com/blog/ai-seo-tracking-tools-2026-analysis-platforms/) — LOW confidence (industry blog)
- [Content Decay Detection Tools](https://seotesting.com/blog/content-decay-tools/) — LOW confidence (vendor blog)
- [Content Brief Generator Comparison](https://seoscout.com/best-content-brief-generators) — LOW confidence (single source)
- [SEL: How to Evaluate SEO Tools in 2026](https://searchengineland.com/how-to-evaluate-your-seo-tools-in-2026-and-avoid-budget-traps-465783) — MEDIUM confidence (credible trade publication)
