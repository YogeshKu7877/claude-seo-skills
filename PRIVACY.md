# Privacy Policy — Claude SEO Skills

## Data Collection

This plugin does **not** collect, transmit, or store any user data. All commands run locally within Claude Code on your machine.

## External Services

Some commands use Claude Code's built-in tools (`web_fetch`, `web_search`) to access public web pages for analysis. These requests go through Claude's infrastructure, not through any third-party service controlled by this plugin.

### MCP Integrations

If you have MCP servers connected, certain commands will query them:

- **Ahrefs MCP** — queries Ahrefs for backlink data, keyword rankings, Domain Rating, and competitor analysis. Connected via your Claude.ai account.
- **Google Search Console MCP** — queries your GSC properties for search analytics, indexing status, and keyword data. Requires your own OAuth credentials configured locally.

These MCP connections are configured and controlled by you. This plugin does not manage credentials or authentication for any MCP server.

## Local Files

- The `/seo log-analysis` command reads server log files you provide from your local filesystem.
- The `/seo report` command writes report files to your local filesystem.
- No files are uploaded or transmitted externally by this plugin.

## Contact

For privacy questions, open an issue at https://github.com/lionkiii/claude-seo-skills/issues
