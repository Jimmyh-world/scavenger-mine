#!/bin/bash

# Print the URL to access a browser VNC interface
# Usage: ./scripts/open-browser.sh <number>

set -e

if [ -z "$1" ]; then
    echo "Usage: ./scripts/open-browser.sh <number>"
    echo "Example: ./scripts/open-browser.sh 5"
    exit 1
fi

if [ ! -f .env ]; then
    echo "❌ .env file not found"
    exit 1
fi

BROWSER_NUM=$(printf "%02d" "$1")
PORT_VAR="BROWSER_${BROWSER_NUM}_PORT"
PORT=$(grep "^${PORT_VAR}=" .env | cut -d'=' -f2)

if [ -z "$PORT" ]; then
    echo "❌ Browser ${BROWSER_NUM} port not found in .env"
    exit 1
fi

echo "Browser ${BROWSER_NUM} VNC Interface:"
echo "http://localhost:${PORT}"
echo ""
echo "Open in browser or use noVNC client to connect"
