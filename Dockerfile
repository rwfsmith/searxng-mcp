# Dockerfile for SearXNG MCP Server
FROM node:20-alpine

# Install required dependencies
RUN apk add --no-cache python3 py3-pip py3-virtualenv curl git bash

# Create app directory
WORKDIR /app

# Copy project files
COPY package.json .
COPY *.sh .
COPY searxng_mcp.py .
COPY requirements.txt .

# Install npm dependencies
RUN npm install

# Create virtual environment for MCP server Python dependencies
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install -r requirements.txt && \
    /opt/venv/bin/pip install mcp

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PATH="/opt/venv/bin:$PATH"
ENV SEARXNG_SRC=/root/searxng-src
ENV SEARXNG_VENV=/root/.searxng-venv
ENV SEARXNG_HOME=/root/searxng

# Use entrypoint script
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Default command
CMD ["npm", "run", "start-mcp"]
