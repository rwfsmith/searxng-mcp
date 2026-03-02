#!/bin/bash
# Start MCP Server Script
# This script starts the SearXNG MCP server after SearXNG is running

set -e

echo "=== Starting SearXNG MCP Server ==="

SEARXNG_HOME="${SEARXNG_HOME:-$HOME/searxng}"
SEARXNG_VENV="${SEARXNG_VENV:-$HOME/.searxng-venv}"
SEARXNG_SRC="${SEARXNG_SRC:-$HOME/searxng-src}"

# Check if SearXNG is installed (check for source directory and venv)
if [ ! -d "$SEARXNG_SRC" ] || [ ! -d "$SEARXNG_VENV" ]; then
    echo "SearXNG not installed. Setting up now..."
    ./setup-searxng.sh
fi

# Check if SearXNG is running
if ! curl -s http://127.0.0.1:8080 &> /dev/null; then
    echo "Starting SearXNG on http://127.0.0.1:8080 ..."
    "$SEARXNG_VENV/bin/python" -m searx.run --port 8080 --host 127.0.0.1 &
    SEARXNG_PID=$!
    
    # Wait for SearXNG to start (up to 30 seconds)
    echo "Waiting for SearXNG to start..."
    for i in {1..30}; do
        if curl -s http://127.0.0.1:8080 &> /dev/null; then
            echo "SearXNG started successfully"
            break
        fi
        sleep 1
    done
    
    # If still not running, show an error but continue with MCP server
    if ! curl -s http://127.0.0.1:8080 &> /dev/null; then
        echo "Warning: SearXNG failed to start within 30 seconds"
    fi
else
    echo "SearXNG is already running on http://127.0.0.1:8080"
fi

# Start the MCP server using Python virtual environment
echo "Starting MCP server..."
cd "$(dirname "$0")"
"$SEARXNG_VENV/bin/python" searxng_mcp.py
