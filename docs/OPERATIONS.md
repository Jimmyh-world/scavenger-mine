# Scavenger Mine Browser Farm - Operations Guide

**Last Updated**: 2025-10-29
**Status**: Production Deployment Complete

---

## Overview

The Scavenger Mine browser farm consists of 20 VNC-accessible Selenium Chrome containers deployed on Beast (192.168.68.100) for Midnight Network scavenger mining operations.

### Key Metrics

- **Total Browsers**: 20 instances
- **Dashboard**: 1 grid management interface
- **Total Containers**: 21
- **Memory Usage**: ~3.4 GiB per browser (169 MiB avg), total ~3.6 GiB
- **Storage**: ~10 GiB allocated for persistent profiles
- **Port Range**: 7000-7020 (dynamically allocated)
- **Network**: Internal Docker bridge network (scavenger-network)

---

## Quick Start

### Start the Browser Farm

```bash
cd /home/jimmyb/scavenger-mine
bash scripts/start.sh
```

This will:
1. Check that .env file exists
2. Pull the latest Docker images
3. Start all 21 containers
4. Wait for health checks to pass

**Expected time**: 30-60 seconds

### Check Status

```bash
bash scripts/status.sh
```

Shows:
- Container running status (21/21)
- Resource usage per container
- Port mappings
- Health check status

### Stop All Browsers

```bash
bash scripts/stop.sh
```

Gracefully stops all containers while preserving persistent data.

---

## Accessing Browser Instances

### Via Dashboard (Recommended)

```bash
# Get dashboard port from .env
DASHBOARD_PORT=$(grep DASHBOARD_PORT .env | cut -d'=' -f2)
echo "Open http://localhost:${DASHBOARD_PORT}"
```

The dashboard provides a 4×5 grid view of all 20 browser instances with status indicators.

### Direct VNC Access

```bash
# Access a specific browser (example: browser 5)
bash scripts/open-browser.sh 5

# Output: http://localhost:7005
# Open in browser or use noVNC client
```

Each browser is accessible via noVNC web interface:
- **Browser 01-20**: http://localhost:7001-7020
- **VNC Protocol**: Port 7900 (internal, mapped to 7000-7020)
- **Default Display**: 1920×1080 resolution

---

## Management Commands

### Restart a Specific Browser

```bash
bash scripts/restart-browser.sh 5

# Waits for container to be healthy before returning
# Preserves persistent browser profile data
```

### View Real-time Logs

```bash
# All containers
docker compose logs -f

# Specific browser
docker compose logs -f browser-05

# Dashboard
docker compose logs -f dashboard
```

### Monitor Resource Usage

```bash
# Real-time stats
docker stats

# One-time snapshot
docker stats --no-stream
```

---

## Persistent Data Management

### Browser Profiles

Each browser has a persistent volume for user data:
- **Location**: `/home/seluser/.config` (inside container)
- **Docker Volume**: `scavenger-mine_browser-XX-data`
- **Host Storage**: Docker data directory (typically `/var/lib/docker/volumes/`)

Data persists across container restarts.

### Clear a Browser Profile

```bash
# Stop the browser
docker compose stop browser-05

# Remove its volume
docker volume rm scavenger-mine_browser-05-data

# Restart with fresh profile
docker compose up -d browser-05
```

---

## Network Configuration

### Internal Network

All containers communicate via the `scavenger-network` bridge network:
- **Driver**: Docker bridge
- **Name**: `scavenger-mine_scavenger-network`
- **Isolation**: Internal to Docker

### Port Mapping

Ports are dynamically assigned via environment variables in `.env`:

```bash
DASHBOARD_PORT=7000
BROWSER_01_PORT=7001
BROWSER_02_PORT=7002
...
BROWSER_20_PORT=7020
```

### Add External Access

If you need to expose browsers externally (not recommended):

```bash
# Get a specific browser's container ID
CONTAINER=$(docker compose ps -q browser-05)

# Expose additional port (example: 9001 → browser 5)
docker run --rm -d \
  --name proxy-browser-05 \
  -p 9001:7900 \
  --link ${CONTAINER}:browser \
  nginx:latest
```

---

## Troubleshooting

### Browsers Not Starting

**Symptoms**: Containers stuck in "health: starting"

**Solution**:
```bash
# Check logs
docker compose logs browser-01

# Restart specific browser
bash scripts/restart-browser.sh 1

# If still failing, restart all
bash scripts/stop.sh
bash scripts/start.sh
```

### Port Conflicts

**Symptoms**: Cannot bind to port 7000-7020

**Solution**:
```bash
# Re-scan for available ports
bash scripts/check-ports.sh > .env

# Redeploy
docker compose down
docker compose up -d
```

### High Memory Usage

**Symptoms**: Container memory > 1GB limit

**Solution**:
```bash
# Check which container is consuming memory
docker stats --no-stream

# Restart the offending browser
bash scripts/restart-browser.sh <number>
```

### Dashboard Not Accessible

**Symptoms**: Cannot connect to http://localhost:7000

**Solution**:
```bash
# Check if dashboard container is running
docker compose ps dashboard

# Check logs
docker compose logs dashboard

# Restart dashboard
docker compose restart dashboard
```

---

## Maintenance Schedule

### Daily

- [ ] Check status: `bash scripts/status.sh`
- [ ] Monitor resource usage
- [ ] Review logs for errors

### Weekly

- [ ] Update Docker images: `docker compose pull && docker compose up -d`
- [ ] Check disk usage: `docker system df`
- [ ] Clear unused volumes: `docker volume prune -f`

### Monthly

- [ ] Full health check of all browsers
- [ ] Review persistent storage usage
- [ ] Test browser profile restore functionality

---

## Advanced Operations

### Scale to More Browsers

To add additional browser instances (not part of current deployment):

1. Edit `docker-compose.yml` to add new services (browser-21, browser-22, etc.)
2. Run port scanner: `bash scripts/check-ports.sh >> .env`
3. Deploy: `docker compose up -d browser-21 browser-22`

### Backup Browser Profiles

```bash
# Create backups directory
mkdir -p backups

# Backup specific browser
docker run --rm \
  -v scavenger-mine_browser-05-data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/browser-05-$(date +%Y%m%d).tar.gz /data

# List backups
ls -lh backups/
```

### Performance Tuning

#### Increase Resource Limits

Edit `docker-compose.yml` for specific browser:

```yaml
browser-05:
  # ...
  mem_limit: 2g      # Increase from 1g
  cpus: 2.0          # Increase from 1.0
  shm_size: 4gb      # Increase from 2gb
```

Then restart:
```bash
docker compose up -d browser-05
```

#### Enable Container Statistics

Prometheus metrics are available via Docker stats API:

```bash
# Export stats to JSON
docker stats --no-stream --format "{{json .}}" > /tmp/browser-stats.json
```

---

## Security Notes

### Network Isolation

- Browsers are isolated within Docker network
- No direct internet access (must go through network configuration)
- Internal communication only

### Volume Permissions

- Browser data volumes owned by `seluser` inside container
- Read/write accessible to browser process only
- Host-level access via Docker volume management

### Password/Credentials

- Browser profiles stored in Docker volumes (encrypted container storage)
- Passwords stored in browser's local storage (encrypted by browser)
- No plaintext credentials in configuration files

---

## Recovery Procedures

### Rollback to Last Known Good State

```bash
# Stop all services
docker compose down

# Remove all volumes (WARNING: data loss!)
docker volume prune -f

# Restart
docker compose up -d
```

### Single Browser Recovery

```bash
# If a browser is corrupted:
docker compose stop browser-10
docker volume rm scavenger-mine_browser-10-data
docker compose up -d browser-10
```

---

## Support Resources

- **Docker Docs**: https://docs.docker.com/
- **Selenium Standalone**: https://github.com/SeleniumHQ/docker-selenium
- **Midnight Network**: https://www.midnightnetwork.io/
- **Project Repo**: https://github.com/Jimmyh-world/scavenger-mine

---

## Contact

For deployment issues, consult:
- **Deployment Spec**: `docs/BEAST-DEPLOYMENT-SPEC.md`
- **Project Docs**: `README.md`
- **Git History**: `git log --oneline`

**Last Deployment**: 2025-10-29 12:50 UTC
**Next Review**: 2025-11-05
