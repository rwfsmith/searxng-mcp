#!/bin/bash
# Start MCP Server Script
# This script starts the SearXNG MCP server after SearXNG is running

set -e

echo "=== Starting SearXNG MCP Server ==="

SEARXNG_HOME="${SEARXNG_HOME:-$HOME/searxng}"
SEARXNG_VENV="${SEARXNG_VENV:-$HOME/.searxng-venv}"

# Check if SearXNG is running
if ! curl -s http://127.0.0.1:8080 &> /dev/null; then
    echo "Warning: SearXNG does not appear to be running on http://127.0.0.1:8080"
    echo "Please start SearXNG first with ./start-searxng.sh"
    echo ""
fi

# Check if virtual environment exists
if [ ! -d "$SEARXNG_VENV" ]; then
    echo "Error: Virtual environment not found at $SEARXNG_VENV"
    echo "Please run ./setup-searxng.sh first to install SearXNG."
    exit 1
fi

# Start the MCP server using Python virtual environment
echo "Starting MCP server..."
cd "$(dirname "$0")"
"$SEARXNG_VENV/bin/python" searxng_mcp.py
