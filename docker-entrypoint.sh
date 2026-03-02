#!/bin/bash
# Docker Entrypoint Script for SearXNG MCP Server

set -e

echo "=== SearXNG MCP Server Docker Entry ==="

# Check if SearXNG is already set up
if [ ! -d "$SEARXNG_SRC" ] || [ ! -d "$SEARXNG_VENV" ]; then
    echo "SearXNG not found. Setting up now..."
    
    # Run setup script (will clone and configure SearXNG)
    if [ -f "/app/setup-searxng.sh" ]; then
        /app/setup-searxng.sh
    else
        echo "Error: setup-searxng.sh not found!"
        exit 1
    fi
fi

# Verify SearXNG is running
if ! curl -s http://127.0.0.1:8080 &> /dev/null; then
    echo "Starting SearXNG..."
    
    # Start SearXNG in background if not already running
    "$SEARXNG_VENV/bin/python" -m searx.run --port 8080 --host 127.0.0.1 &
    SEARXNG_PID=$!
    
    # Wait for SearXNG to start
    echo "Waiting for SearXNG to start..."
    for i in {1..30}; do
        if curl -s http://127.0.0.1:8080 &> /dev/null; then
            echo "SearXNG started successfully"
            break
        fi
        sleep 1
    done
    
    # If still not running, show error but continue (MCP server can work without search)
    if ! curl -s http://127.0.0.1:8080 &> /dev/null; then
        echo "Warning: SearXNG failed to start"
    fi
fi

echo ""
echo "=== Starting MCP Server ==="

# Run the command passed to docker run (defaults to npm run start-mcp)
exec "$@"