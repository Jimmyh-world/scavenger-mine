#!/bin/bash

# Stop all browser farm services
# Usage: ./scripts/stop.sh

set -e

echo "Stopping Scavenger Mine browser farm..."
docker compose down

echo "✅ Browser farm stopped"
