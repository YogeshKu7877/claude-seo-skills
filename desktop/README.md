# Claude SEO Skills — Desktop Edition

Use the SEO skill system in **Claude Desktop** or **Claude.ai web** via Projects.

## Setup (2 minutes)

### Step 1: Create a Project

1. Open Claude Desktop (or claude.ai)
2. Click **"Projects"** in the sidebar → **"Create Project"**
3. Name it: `SEO Skills`

### Step 2: Add Project Instructions

1. Click **"Set custom instructions"** in the project
2. Copy the entire contents of `PROJECT-INSTRUCTIONS.md` and paste it in
3. Save

### Step 3: Upload Reference Guides (Knowledge Files)

Upload these files as project knowledge (drag-and-drop or click "Add content"):

| File | What It Provides |
|------|-----------------|
| `knowledge/llms-txt-spec.md` | Full llms.txt specification, validation rules, examples, tooling |
| `knowledge/ai-crawlers-guide.md` | AI crawler registry, robots.txt strategies, blocking statistics |
| `knowledge/google-seo-guide.md` | Google SEO Starter Guide audit checklist |
| `knowledge/eeat-framework.md` | E-E-A-T evaluation criteria |
| `knowledge/schema-types.md` | Schema.org types with deprecation status |
| `knowledge/cwv-thresholds.md` | Core Web Vitals thresholds |
| `knowledge/quality-gates.md` | Content length and uniqueness thresholds |

### Step 4: Connect MCP Servers (Optional)

**Ahrefs MCP** — If you have Ahrefs connected on claude.ai, it's available as a remote connector:
- Claude Desktop: Settings → Connectors → Ahrefs should appear if connected to your Claude.ai account

**Filesystem MCP** — For writing llms.txt files to disk (Desktop only):
- Claude Desktop: Settings → Developer → Edit Config
- Add to `claude_desktop_config.json`:
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/you/Desktop"]
    }
  }
}
```
- Restart Claude Desktop after saving

## Usage

Start a new chat inside your "SEO Skills" project, then just ask naturally:

```
Audit example.com for SEO issues

Check example.com/robots.txt for AI crawler policies

Generate an llms.txt file for example.com

Analyze the SERP for "best project management tools"

Check my Ahrefs backlink profile for example.com

Find ranking drops in my GSC data for sc-domain:example.com
```

Or use command syntax:

```
/seo-audit example.com
/seo-robots-ai example.com
/seo-llms-txt generate example.com
/seo-serp "keyword research tools"
/seo-ahrefs-overview example.com
/seo-gsc-drops site=sc-domain:example.com
```

## What Works vs Claude Code

| Feature | Desktop Edition | Claude Code |
|---|---|---|
| SEO analysis & recommendations | Yes | Yes |
| Ahrefs live data | Yes (if connected) | Yes |
| GSC live data | Yes (if connected) | Yes |
| Web search for SERP analysis | Yes | Yes |
| Reference guides (llms.txt spec, AI crawlers, etc.) | Yes (via project knowledge) | Yes (via @references) |
| Write files to disk (llms.txt generation) | Yes (with Filesystem MCP) | Yes (built-in) |
| Parallel agent delegation for audits | No | Yes |
| Bash/terminal commands | No | Yes |
| Git operations | No | Yes |
| 44 structured skill workflows | Conversational approximation | Native skill system |

## Tips

- **Upload your own files** — Drop in your robots.txt, sitemap.xml, or markdown files for analysis
- **Paste HTML source** — Copy page source and paste it for on-page SEO analysis
- **Use web search** — Claude Desktop can search the web to check live page status
- **Be specific** — Say "audit the technical SEO of example.com focusing on Core Web Vitals" for focused results
