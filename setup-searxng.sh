#!/bin/bash
# SearXNG Setup Script
# This script installs and configures SearXNG for use with the MCP server
# SearXNG is installed from source - not via pip

set -e

echo "=== SearXNG Installation ==="

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is required but not installed."
    exit 1
fi

SEARXNG_SRC="${SEARXNG_SRC:-$HOME/searxng-src}"
SEARXNG_VENV="${SEARXNG_VENV:-$HOME/.searxng-venv}"
SEARXNG_HOME="${SEARXNG_HOME:-$HOME/searxng}"

echo "Cloning SearXNG from source..."

# Clone SearXNG repository if not already present
if [ ! -d "$SEARXNG_SRC/.git" ]; then
    echo "Cloning SearXNG repository..."
    git clone https://github.com/searxng/searxng.git "$SEARXNG_SRC"
else
    echo "SearXNG repository already exists, updating..."
    cd "$SEARXNG_SRC"
    git pull --rebase
fi

# Create virtual environment for SearXNG dependencies
echo "Creating Python virtual environment..."
python3 -m venv "$SEARXNG_VENV"
"$SEARXNG_VENV/bin/pip" install --upgrade pip

# Install SearXNG dependencies from the cloned source
echo "Installing SearXNG dependencies..."
cd "$SEARXNG_SRC"
"$SEARXNG_VENV/bin/pip" install -e .

# Create SearXNG home directory for configuration
mkdir -p "$SEARXNG_HOME"

# Generate default configuration if not exists
if [ ! -f "$SEARXNG_HOME/settings.yml" ]; then
    echo "Generating default SearXNG configuration..."
    
    # Try to copy from source repository first
    if [ -f "$SEARXNG_SRC/searx/settings.yml" ]; then
        cp "$SEARXNG_SRC/searx/settings.yml" "$SEARXNG_HOME/settings.yml"
        echo "Copied default settings from SearXNG source."
    else
        # If no settings file found in source, create a basic one
        echo "Creating basic SearXNG configuration..."
        cat > "$SEARXNG_HOME/settings.yml" << 'SETTINGS_EOF'
# SearXNG configuration
# See full documentation: https://docs.searxng.org/admin/configuration.html

use_default_settings: true

search:
    safe_search: 0
    autocomplete: ""
    default_theme: null

server:
    secret_key: "${searxng_secret_key}"
    base_url: "http://127.0.0.1:8080"
    limiter: false
    image_proxy: false
    http_proxy: "${searxng_http_proxy}"
    timeout: 4

outgoing:
    carpooler:
        - "threading"
        - "20"
        - "30"

engines: []

general_stats: true
SETTINGS_EOF
    fi
fi

# Create environment file for secrets
ENV_FILE="$SEARXNG_HOME/.env"
if [ ! -f "$ENV_FILE" ]; then
    echo "Creating environment file..."
    SECRET_KEY=$(openssl rand -hex 32)
    cat > "$ENV_FILE" << EOF
searxng_secret_key=$SECRET_KEY
searxng_http_proxy=
EOF
fi

echo ""
echo "=== Installation Complete ==="
echo ""
echo "SearXNG source: $SEARXNG_SRC"
echo "Virtual environment: $SEARXNG_VENV"
echo "Configuration directory: $SEARXNG_HOME"
echo ""
echo "To start SearXNG, run:"
echo "  source $SEARXNG_VENV/bin/activate && cd $SEARXNG_SRC && python -m searx.run --port 8080 --host 127.0.0.1"
echo ""
echo "Or use the start script:"
echo "  ./start-searxng.sh"
echo ""

# Save installation info to a config file
cat > "$SEARXNG_HOME/install-info.json" << EOF
{
    "venv_path": "$SEARXNG_VENV",
    "searxng_src": "$SEARXNG_SRC",
    "searxng_home": "$SEARXNG_HOME",
    "version": "1.0.0"
}
EOF

echo "Installation info saved to: $SEARXNG_HOME/install-info.json"
