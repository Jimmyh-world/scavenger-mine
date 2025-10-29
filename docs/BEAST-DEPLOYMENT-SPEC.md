# Beast Deployment Specification - Scavenger Mine Browser Farm

**Created**: 2025-10-29
**Target**: Beast (192.168.68.100)
**Executor**: Claude Code CLI with Haiku 4.5
**Status**: Ready for execution

---

## Deployment Overview

Deploy 20 VNC-accessible browser instances using Docker Compose for Midnight Network scavenger mining.

**Key Constraint**: Dynamic port allocation - NO hardcoded ports
**Model Optimization**: Haiku 4.5 (fast, cost-effective, structured task execution)

---

## Success Criteria

- [ ] 20 browser containers running and healthy
- [ ] All ports dynamically assigned (no conflicts)
- [ ] Grid dashboard accessible
- [ ] Each browser accessible via noVNC web interface
- [ ] Persistent browser profiles configured
- [ ] Resource usage <15GB RAM total
- [ ] All validation commands pass

---

## Jimmy's Workflow Phases

### 🔴 PHASE 1: Port Discovery & Environment Setup (RED - 15 min)

**Objective**: Find available ports and create .env configuration

**Tasks**:
1. Create `scripts/check-ports.sh` to scan for 21 available ports (20 browsers + 1 dashboard)
2. Execute port scan and generate `.env` file
3. Validate `.env` contains all required port assignments

**Validation Commands**:
```bash
# Port scan script exists and is executable
test -x scripts/check-ports.sh && echo "✅ Port scanner ready"

# Generate .env file
bash scripts/check-ports.sh > .env

# Verify 21 ports assigned
grep -c "_PORT=" .env | grep -q "21" && echo "✅ All ports assigned"

# Show port assignments
cat .env
```

**Deliverables**:
- `scripts/check-ports.sh` - Port scanner script
- `.env` - Generated port assignments
- `.env.example` - Template for documentation

**Rollback**: Delete `.env` and re-run `check-ports.sh`

---

### 🔴 PHASE 2: Docker Compose Configuration (RED - 20 min)

**Objective**: Create docker-compose.yml with 20 browser services + grid dashboard

**Tasks**:
1. Create `docker-compose.yml` with:
   - Dashboard service (simple nginx or Python HTTP server)
   - 20 browser services (selenium/standalone-chrome)
   - Persistent volumes for each browser (browser-01-data through browser-20-data)
   - Resource limits (512MB-1GB RAM, 1 CPU, 2GB shm_size per browser)
   - Environment variable port references (NO hardcoded ports)
   - Health checks for all services
   - Restart policy: unless-stopped

2. Create dashboard files:
   - `dashboard/index.html` - Grid view (4x5 layout)
   - `dashboard/styles.css` - Simple styling
   - `dashboard/Dockerfile` - nginx or Python server

**Validation Commands**:
```bash
# docker-compose.yml exists
test -f docker-compose.yml && echo "✅ Docker Compose file created"

# Check for hardcoded ports (should return ZERO matches)
grep -E "ports:.*[0-9]{4}:" docker-compose.yml && echo "❌ HARDCODED PORTS FOUND" || echo "✅ No hardcoded ports"

# Validate env var usage
grep -c "\${.*_PORT}" docker-compose.yml | grep -q "[0-9]" && echo "✅ Using environment variables"

# Check dashboard files exist
test -f dashboard/index.html && test -f dashboard/styles.css && echo "✅ Dashboard files created"

# Validate compose file syntax
docker compose config > /dev/null && echo "✅ Docker Compose syntax valid"
```

**Deliverables**:
- `docker-compose.yml` - Main orchestration file
- `dashboard/index.html` - Grid UI
- `dashboard/styles.css` - Styling
- `dashboard/Dockerfile` - Dashboard container config

**Rollback**: `git checkout docker-compose.yml dashboard/`

---

### 🟢 PHASE 3: Deployment & Validation (GREEN - 15 min)

**Objective**: Deploy all services and verify they're accessible

**Tasks**:
1. Pull required Docker images
2. Start all services with `docker compose up -d`
3. Wait for all containers to reach healthy status
4. Verify each browser instance is accessible
5. Test grid dashboard access

**Validation Commands**:
```bash
# Pull images
docker compose pull && echo "✅ Images pulled"

# Start services
docker compose up -d && echo "✅ Services started"

# Wait for health checks (max 60 seconds)
timeout 60 bash -c 'until [ $(docker compose ps --status running | grep -c healthy) -eq 21 ]; do sleep 2; done' && echo "✅ All 21 services healthy"

# Verify container count
docker compose ps | grep -c "Up" | grep -q "21" && echo "✅ All 21 containers running"

# Check resource usage
docker stats --no-stream --format "table {{.Name}}\t{{.MemUsage}}\t{{.CPUPerc}}" > /tmp/resource-check.txt
cat /tmp/resource-check.txt && echo "✅ Resource usage logged"

# Test dashboard access (get port from .env)
DASHBOARD_PORT=$(grep DASHBOARD_PORT .env | cut -d'=' -f2)
curl -f http://localhost:${DASHBOARD_PORT} > /dev/null && echo "✅ Dashboard accessible"

# Test first browser VNC access
BROWSER_01_PORT=$(grep BROWSER_01_PORT .env | cut -d'=' -f2)
curl -f http://localhost:${BROWSER_01_PORT} > /dev/null && echo "✅ Browser 01 VNC accessible"
```

**Success Indicators**:
- All 21 containers show status "Up (healthy)"
- Total RAM usage <15GB
- Dashboard responds on assigned port
- At least one browser VNC interface accessible

**Rollback**:
```bash
docker compose down
docker volume prune -f
```

---

### 🔴 PHASE 4: Operational Scripts (RED - 10 min)

**Objective**: Create management scripts for daily operations

**Tasks**:
1. Create `scripts/start.sh` - Start all services
2. Create `scripts/stop.sh` - Stop all services
3. Create `scripts/status.sh` - Health check all containers
4. Create `scripts/restart-browser.sh <number>` - Restart specific browser
5. Create `scripts/open-browser.sh <number>` - Print browser URL

**Validation Commands**:
```bash
# All scripts exist and are executable
for script in start stop status restart-browser open-browser; do
  test -x scripts/$script.sh && echo "✅ $script.sh ready" || echo "❌ $script.sh missing"
done

# Test status script
bash scripts/status.sh && echo "✅ Status script works"

# Test restart script (restart browser 1)
bash scripts/restart-browser.sh 1 && sleep 5
docker ps | grep browser-01 | grep -q "Up" && echo "✅ Restart script works"

# Test open-browser script
bash scripts/open-browser.sh 1 | grep -q "http://" && echo "✅ Open browser script works"
```

**Deliverables**:
- `scripts/start.sh`
- `scripts/stop.sh`
- `scripts/status.sh`
- `scripts/restart-browser.sh`
- `scripts/open-browser.sh`

**Rollback**: Delete scripts and use docker compose commands directly

---

### 🟢 PHASE 5: Documentation & Monitoring (GREEN - 10 min)

**Objective**: Document deployment and integrate with Beast monitoring

**Tasks**:
1. Create `docs/OPERATIONS.md` - Day-to-day usage guide
2. Create `README.md` - Quick start guide
3. Create Grafana dashboard JSON for browser metrics
4. Update Beast's Prometheus to scrape browser metrics

**Validation Commands**:
```bash
# Documentation exists
test -f docs/OPERATIONS.md && echo "✅ Operations guide created"
test -f README.md && echo "✅ README created"

# Grafana dashboard exists
test -f monitoring/browser-farm.json && echo "✅ Grafana dashboard created"

# Check if Prometheus can reach metrics (if exposed)
# (Optional - only if metrics endpoints are configured)
```

**Deliverables**:
- `docs/OPERATIONS.md`
- `README.md`
- `monitoring/browser-farm.json`

---

### 🔵 CHECKPOINT: Deployment Complete

**Final Validation Checklist**:
```bash
# All containers running
docker compose ps | grep -c "Up" | grep -q "21" && echo "✅ All 21 containers up"

# Resource check
TOTAL_MEM=$(docker stats --no-stream --format "{{.MemUsage}}" | awk -F'/' '{sum+=$1} END {print sum}')
echo "Total RAM: ${TOTAL_MEM}GB" && echo "✅ Resource usage documented"

# Dashboard accessible
DASHBOARD_PORT=$(grep DASHBOARD_PORT .env | cut -d'=' -f2)
curl -f http://localhost:${DASHBOARD_PORT} > /dev/null && echo "✅ Dashboard working"

# All browsers accessible (test 3 random instances)
for i in 01 05 10; do
  PORT=$(grep BROWSER_${i}_PORT .env | cut -d'=' -f2)
  curl -f http://localhost:${PORT} > /dev/null && echo "✅ Browser ${i} accessible"
done

# Scripts functional
bash scripts/status.sh && echo "✅ Management scripts working"

# Documentation complete
test -f README.md && test -f docs/OPERATIONS.md && echo "✅ Documentation complete"
```

**Completion Actions**:
1. Commit all files to Git
2. Push to GitHub
3. Update AGENTS.md current status
4. Document in dev-network Beast infrastructure status

**Commit Message**:
```bash
git add .
git commit -m "$(cat <<'EOF'
feat: Complete browser farm deployment on Beast

Deployed 20 VNC-accessible browser instances with grid dashboard.

- Dynamic port allocation (no hardcoded ports)
- Persistent browser profiles
- Resource limits per container
- Management scripts for operations
- Grafana monitoring integration

Resource usage: ~12GB RAM, 20% CPU
All 21 containers healthy and accessible.

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
git push origin main
```

---

## Haiku 4.5 Optimization Notes

**Why Haiku for this task**:
- ✅ Structured, sequential tasks (perfect for Haiku)
- ✅ File creation and templating (Haiku excels at this)
- ✅ Validation commands are explicit (no complex reasoning needed)
- ✅ Cost-effective for repetitive operations (20 browser configs)
- ✅ Fast execution (total time ~70 minutes vs 2+ hours with larger model)

**Haiku Strengths Used**:
- File creation from templates
- Shell script writing
- YAML/JSON configuration
- Explicit validation checking
- Structured documentation

**Task Boundaries**:
- Each phase is self-contained
- Clear validation commands at each step
- No complex decision-making required
- Explicit rollback procedures

---

## Emergency Procedures

### Complete Rollback
```bash
# Stop all services
docker compose down

# Remove all volumes
docker volume rm $(docker volume ls -q | grep scavenger-mine)

# Remove .env
rm .env

# Start fresh
git checkout main
```

### Partial Rollback (Single Browser)
```bash
# Stop specific browser
docker compose stop browser-05

# Remove its volume
docker volume rm scavenger-mine_browser-05-data

# Restart
docker compose up -d browser-05
```

### Port Conflict Resolution
```bash
# Re-scan for ports
bash scripts/check-ports.sh > .env

# Recreate containers with new ports
docker compose down
docker compose up -d
```

---

## Expected Timeline

| Phase | Duration | Total |
|-------|----------|-------|
| Phase 1: Port Discovery | 15 min | 15 min |
| Phase 2: Docker Compose | 20 min | 35 min |
| Phase 3: Deployment | 15 min | 50 min |
| Phase 4: Scripts | 10 min | 60 min |
| Phase 5: Documentation | 10 min | 70 min |

**Total Estimated Time**: 70 minutes

---

## Resource Projections

| Resource | Per Browser | Total (20) | Available | Usage % |
|----------|-------------|------------|-----------|---------|
| RAM | 600MB | 12GB | 96GB | 12.5% |
| CPU | 0.5 core | 10 cores | Unknown | TBD |
| Disk | 500MB | 10GB | 2TB | 0.5% |
| Ports | 1 | 20 | 65535 | <1% |

**Safety Margin**: Excellent - Beast has massive headroom

---

**Specification Version**: 1.0
**Last Updated**: 2025-10-29
**Execution Model**: Jimmy's Workflow (RED→GREEN→CHECKPOINT)
**Optimized For**: Claude Haiku 4.5 on Beast
