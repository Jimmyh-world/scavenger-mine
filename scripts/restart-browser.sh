#!/bin/bash

# Restart a specific browser instance
# Usage: ./scripts/restart-browser.sh <number>

set -e

if [ -z "$1" ]; then
    echo "Usage: ./scripts/restart-browser.sh <number>"
    echo "Example: ./scripts/restart-browser.sh 5"
    exit 1
fi

BROWSER_NUM=$(printf "%02d" "$1")
CONTAINER_NAME="scavenger-mine-browser-${BROWSER_NUM}"

echo "Restarting browser ${BROWSER_NUM}..."
docker compose restart "browser-${BROWSER_NUM}"

echo "Waiting for container to be healthy..."
timeout 60 bash -c "until docker compose ps --status running 'browser-${BROWSER_NUM}' | grep -q 'Up'; do sleep 1; done"

echo "✅ Browser ${BROWSER_NUM} restarted"
