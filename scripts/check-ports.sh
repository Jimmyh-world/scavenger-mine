#!/bin/bash

# Port discovery script for Scavenger Mine browser farm
# Finds 21 available ports (20 browsers + 1 dashboard)
# Output: Environment variables in .env format

set -e

PORTS_NEEDED=21
START_PORT=7000
MAX_PORT=9999
FOUND_PORTS=()

echo "Scanning for ${PORTS_NEEDED} available ports (${START_PORT}-${MAX_PORT})..." >&2

check_port() {
  local port=$1
  # Try to connect to the port - if it fails, port is available
  if ! timeout 1 bash -c "echo > /dev/tcp/127.0.0.1/${port}" 2>/dev/null; then
    return 0  # Port is available
  else
    return 1  # Port is in use
  fi
}

port=$START_PORT
while [ ${#FOUND_PORTS[@]} -lt $PORTS_NEEDED ] && [ $port -le $MAX_PORT ]; do
  if check_port $port; then
    FOUND_PORTS+=($port)
    echo "✓ Port $port available" >&2
  fi
  ((port++))
done

if [ ${#FOUND_PORTS[@]} -lt $PORTS_NEEDED ]; then
  echo "❌ ERROR: Could not find $PORTS_NEEDED available ports" >&2
  exit 1
fi

# Generate .env file with port assignments
{
  echo "# Generated port assignments for Scavenger Mine"
  echo "# Generated: $(date)"
  echo ""

  # Dashboard port (first found port)
  echo "DASHBOARD_PORT=${FOUND_PORTS[0]}"

  # Browser ports
  for i in {1..20}; do
    port_index=$i  # Browser 01 gets second port, etc.
    printf "BROWSER_%02d_PORT=%d\n" "$i" "${FOUND_PORTS[$port_index]}"
  done
} 1>&1

echo "# Total ports assigned: ${#FOUND_PORTS[@]}" >&2
echo "✅ Port discovery complete" >&2
