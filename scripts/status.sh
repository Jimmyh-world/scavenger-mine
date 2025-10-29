#!/bin/bash

# Check status of all browser farm services
# Usage: ./scripts/status.sh

echo "Scavenger Mine - Browser Farm Status"
echo "===================================="
echo ""

# Check if containers are running
RUNNING=$(docker compose ps --status running | grep -c "Up" || echo 0)
TOTAL=21

echo "Container Status: $RUNNING/$TOTAL running"
echo ""

# Show detailed container list
echo "Container Details:"
docker compose ps

echo ""
echo "Resource Usage:"
docker stats --no-stream --format "table {{.Container}}\t{{.MemUsage}}\t{{.CPUPerc}}" | head -n 22

echo ""
# Check health status
HEALTHY=$(docker compose ps --status running | grep -c "healthy" || echo 0)
echo "Healthy Services: $HEALTHY/21"

if [ "$RUNNING" -eq 21 ] && [ "$HEALTHY" -eq 21 ]; then
    echo "✅ All services healthy"
else
    echo "⚠️  Some services may need attention"
fi
