#!/bin/bash
# Start SearXNG Script
# This script starts the SearXNG search engine

set -e

echo "=== Starting SearXNG ==="

# Load installation info if available
INSTALL_INFO="$HOME/searxng/install-info.json"
if [ -f "$INSTALL_INFO" ]; then
    echo "Loading installation info..."
    # shellcheck source=/dev/null
    source <(grep -E '^(venv_path|searxng_src)=' "$INSTALL_INFO" 2>/dev/null | sed 's/"://g' || true)
fi

SEARXNG_VENV="${SEARXNG_VENV:-$HOME/.searxng-venv}"
SEARXNG_HOME="${SEARXNG_HOME:-$HOME/searxng}"
SEARXNG_SRC="${SEARXNG_SRC:-$HOME/searxng-src}"

# Check if SearXNG is installed (check for source directory and venv)
if [ ! -d "$SEARXNG_VENV" ] || [ ! -d "$SEARXNG_SRC" ]; then
    echo "Error: SearXNG not properly installed."
    echo "Please run ./setup-searxng.sh first to install SearXNG."
    exit 1
fi

# Load secrets from .env file
ENV_FILE="$SEARXNG_HOME/.env"
if [ -f "$ENV_FILE" ]; then
    echo "Loading environment variables..."
    export $(grep -v '^#' "$ENV_FILE" | xargs)
fi

# Start SearXNG from source directory
echo "Starting SearXNG on http://127.0.0.1:8080 ..."
cd "$SEARXNG_SRC"
"$SEARXNG_VENV/bin/python" -m searx.run --port 8080 --host 127.0.0.1
