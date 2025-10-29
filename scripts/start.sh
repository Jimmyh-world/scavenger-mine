#!/bin/bash

# Start all browser farm services
# Usage: ./scripts/start.sh

set -e

echo "Starting Scavenger Mine browser farm..."
echo "Loading configuration from .env..."

# Check if .env exists
if [ ! -f .env ]; then
    echo "❌ .env file not found. Run 'bash scripts/check-ports.sh > .env' first"
    exit 1
fi

# Pull latest images
echo "Pulling Docker images..."
docker compose pull

# Start services
echo "Starting containers..."
docker compose up -d

# Wait for health checks
echo "Waiting for containers to become healthy..."
timeout 120 bash -c 'until [ $(docker compose ps --status running | grep -c "Up") -eq 21 ]; do echo -n "."; sleep 2; done'

echo ""
echo "✅ Browser farm started successfully"
echo "Dashboard: http://localhost:$(grep DASHBOARD_PORT .env | cut -d'=' -f2)"
echo "Browser instances: 20 (7001-7020)"
