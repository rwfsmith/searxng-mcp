# SearXNG MCP Server - Standalone Installer

A standalone installer for setting up SearXNG search engine and MCP server.

This package is designed to be used as a named MCP server with the `mcp-proxy` tool.
When run via MCP proxy, it sets up SearXNG and starts the MCP server on stdio.

## Installation

### Quick Start (Local)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/searxng-mcp.git
   cd searxng-mcp
   ```

2. **Setup SearXNG (installed from source, not pip):**
   ```bash
   npm run setup-searxng
   # Or manually: ./setup-searxng.sh
   ```
   
   This will:
   - Clone the SearXNG repository from GitHub
   - Create a Python virtual environment
   - Install SearXNG dependencies

3. **Start SearXNG:**
   ```bash
   npm run start-searxng
   # Or manually: ./start-searxng.sh
   ```

4. **Start the MCP Server:**
   ```bash
   npm run start-mcp
   # Or manually: ./start-mcp.sh
   ```

## Scripts

- `npm run setup-searxng` - Install and configure SearXNG
- `npm run start-searxng` - Start the SearXNG search engine
- `npm run start-mcp` - Start the MCP server

## Usage with MCP Proxy

This package is configured to be used as a named MCP server:

```json
{
  "mcpServers": {
    "SearXNG": {
      "command": "npm",
      "args": ["run", "start-mcp"]
    }
  }
}
```

When run via `mcp-proxy`, the following happens:
1. If SearXNG is not installed, it runs `./setup-searxng.sh` automatically
2. If SearXNG is not running, it starts on port 8080
3. The MCP server starts and listens on stdio

## Scripts

- `npm run setup-searxng` - Install and configure SearXNG
- `npm run start-searxng` - Start the SearXNG search engine
- `npm run start-mcp` - Start the MCP server

## Requirements

- Node.js 18+
- npm
- Python 3.8+
- pip
- curl
- wget (for setup script)

## License

MIT
