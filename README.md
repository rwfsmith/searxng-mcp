# SearXNG MCP Server - Standalone Installer

A standalone installer for setting up SearXNG search engine and MCP server.

## Installation

### Quick Start

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

## Requirements

- Node.js 18+
- npm
- Python 3.8+
- pip
- curl
- wget

## License

MIT