# Scavenger Mine - Browser Farm for Midnight Network Mining

<!--
TEMPLATE_VERSION: 1.5.0
TEMPLATE_SOURCE: /home/jimmyb/templates/AGENTS.md.template
LAST_SYNC: 2025-10-29
SYNC_CHECK: Run ~/templates/tools/check-version.sh to verify you have the latest template version
AUTO_SYNC: Run ~/templates/tools/sync-templates.sh to update (preserves your customizations)
CHANGELOG: See ~/templates/CHANGELOG.md for version history
-->

**STATUS: IN DEVELOPMENT** - Last Updated: 2025-10-29

## Repository Information
- **GitHub Repository**: https://github.com/Jimmyh-world/scavenger-mine
- **Local Directory (Chromebook)**: `~/scavenger-mine`
- **Deployment Target (Beast)**: `~/scavenger-mine` on 192.168.68.100
- **Primary Purpose**: Deploy and manage 20 VNC-accessible browser instances for Midnight Network scavenger mining operations

## Important Context

<!-- PROJECT_SPECIFIC START: IMPORTANT_CONTEXT -->
**Deployment Target**: Beast (192.168.68.100) - Ubuntu Server 24.04 with 96GB RAM, 2TB NVMe SSD

**Orchestration Model**: Chromebook creates deployment specs and action plans. Beast executes via Docker. This repository contains the complete Docker Compose setup, monitoring configuration, and operational procedures.

**Browser Requirements**: Each browser instance requires manual interaction (form filling, terms acceptance) before automation begins. VNC web interface (noVNC) provides GUI access without requiring VNC clients.

**Port Strategy**: Ports must be dynamically checked on Beast before deployment. Do NOT hardcode port numbers in deployment specifications.

**Machine Roles**:
- Chromebook (this machine): Orchestrator, planning, code review
- Beast (192.168.68.100): Executor, runs Docker containers, heavy workloads
- Coordination: GitHub single source of truth
<!-- PROJECT_SPECIFIC END: IMPORTANT_CONTEXT -->

## Core Development Principles (MANDATORY)

### 1. KISS (Keep It Simple, Stupid)
- Avoid over-complication and over-engineering
- Choose simple solutions over complex ones
- Question every abstraction layer
- If a feature seems complex, ask: "Is there a simpler way?"

### 2. TDD (Test-Driven Development)
- Write tests first
- Run tests to ensure they fail (Red phase)
- Write minimal code to pass tests (Green phase)
- Refactor while keeping tests green
- Never commit code without tests

### 3. Separation of Concerns (SOC)
- Each module/component has a single, well-defined responsibility
- Clear boundaries between different parts of the system
- Services should be loosely coupled
- Avoid mixing business logic with UI or data access code

### 4. DRY (Don't Repeat Yourself)
- Eliminate code duplication
- Extract common functionality into reusable components
- Use configuration files for repeated settings
- Create shared libraries for common operations

### 5. Documentation Standards
- Always include the actual date when writing documentation
- Use objective, factual language only
- Avoid marketing terms like "production-ready", "world-class", "highly sophisticated", "cutting-edge", etc.
- State current development status clearly
- Document what IS, not what WILL BE

### 6. Jimmy's Workflow (Red/Green Checkpoints)
**MANDATORY for all implementation tasks**

Use the Red/Green/Blue checkpoint system to prevent AI hallucination and ensure robust implementation:

- 🔴 **RED (IMPLEMENT)**: Write code, build features, make changes
- 🟢 **GREEN (VALIDATE)**: Run explicit validation commands, prove it works
- 🔵 **CHECKPOINT**: Mark completion with machine-readable status, document rollback

**Critical Rules:**
- NEVER skip validation phases
- NEVER proceed to next checkpoint without GREEN passing
- ALWAYS document rollback procedures
- ALWAYS use explicit validation commands (not assumptions)

**Reference**: See **JIMMYS-WORKFLOW.md** for complete workflow system, templates, and patterns

**Usage**: When working with AI assistants, say: *"Let's use Jimmy's Workflow to execute this plan"*

### 7. YAGNI (You Ain't Gonna Need It)
- Don't implement features until they're actually needed
- Build for current requirements, not hypothetical future ones
- Only write what's necessary for the task at hand

### 8. Fix Now, Not Later
- Fix vulnerabilities immediately when discovered
- Fix warnings immediately (don't suppress or accumulate)
- Fix failing tests immediately
- Never use suppressions without documented justification

## Service Overview

<!-- PROJECT_SPECIFIC START: SERVICE_OVERVIEW -->
Scavenger Mine is a Docker-based browser farm infrastructure that deploys 20 concurrent VNC-accessible Chrome instances for participating in the Midnight Network scavenger hunt (https://www.midnight.gd/scavenger-mine).

**Key Responsibilities:**
- Deploy 20 Selenium Standalone Chrome containers with noVNC web access
- Provide persistent browser profiles (cookies, sessions, localStorage)
- Expose web-based grid dashboard for easy browser access
- Integrate with Beast monitoring infrastructure (Prometheus/Grafana)
- Enable manual browser interaction for initial setup and configuration
- Support optional automation after manual configuration complete

**Important Distinctions:**
- **Browser Instance**: Individual Selenium Chrome container with its own VNC interface
- **Grid Dashboard**: Central web UI showing all 20 browser thumbnails with click-to-access
- **Persistent Profile**: Docker volume storing browser data (cookies, sessions) across restarts
- **noVNC**: Web-based VNC client - no desktop VNC client needed, access via browser
<!-- PROJECT_SPECIFIC END: SERVICE_OVERVIEW -->

## Current Status

<!-- PROJECT_SPECIFIC START: CURRENT_STATUS -->
🔄 **Initial Development - 0% Complete**

**Phase 1: Planning & Specification (Current)**
- 🔄 Repository initialization
- 🔄 Action plan creation (Haiku 4.5 optimized)
- ⚪ Port availability audit on Beast
- ⚪ Docker Compose specification

**Phase 2: Infrastructure Setup (Pending)**
- ⚪ Grid dashboard implementation
- ⚪ Browser container configuration (x20)
- ⚪ Persistent volume setup
- ⚪ Monitoring integration

**Phase 3: Deployment & Validation (Pending)**
- ⚪ Deploy to Beast
- ⚪ Verify all 20 instances accessible
- ⚪ Manual browser testing
- ⚪ Resource usage validation
<!-- PROJECT_SPECIFIC END: CURRENT_STATUS -->

## Technology Stack

**Infrastructure:**
- **Platform**: Docker Compose
- **Base Image**: selenium/standalone-chrome:latest
- **Orchestration**: Docker Compose on Beast
- **Monitoring**: Prometheus + Grafana (existing Beast infrastructure)
- **Network**: Docker bridge network

**Dashboard:**
- **Framework**: Vanilla HTML/CSS/JavaScript (KISS principle)
- **Server**: Simple Python HTTP server or nginx
- **Features**: Grid view, screenshot display, instance controls

**Deployment:**
- **Host**: Beast (Ubuntu Server 24.04, 96GB RAM, 2TB SSD)
- **Access**: Local network (192.168.68.0/24)
- **Remote Access**: Optional Cloudflare Tunnel

## Build & Test Commands

### Development (Chromebook - Planning)
```bash
# Create action plan
cd ~/scavenger-mine
claude  # Start AI assistant session

# Push specifications to GitHub
git add .
git commit -m "spec: [description]"
git push origin main
```

### Deployment (Beast - Execution)
```bash
# Pull latest specs
cd ~/scavenger-mine
git pull origin main

# Check available ports
bash scripts/check-ports.sh

# Deploy services
docker compose up -d

# Verify deployment
docker compose ps
bash scripts/status.sh
```

### Monitoring
```bash
# Real-time container stats
docker stats

# View logs
docker compose logs -f

# Access Grafana dashboard
# http://192.168.68.100:3000
```

## Repository Structure

```
scavenger-mine/
├── docker-compose.yml          # Main service orchestration
├── .env.example                # Environment variable template
├── dashboard/                  # Grid dashboard web UI
│   ├── index.html             # Main grid view
│   ├── styles.css             # Styling
│   └── app.js                 # Browser control logic
├── scripts/                    # Operational scripts
│   ├── check-ports.sh         # Find available ports on Beast
│   ├── start.sh               # Start all services
│   ├── stop.sh                # Stop all services
│   ├── status.sh              # Check health status
│   ├── restart-browser.sh     # Restart individual browser
│   └── open-browser.sh        # Open browser in new tab
├── monitoring/                 # Grafana dashboards
│   └── browser-farm.json      # Browser metrics dashboard
├── docs/                       # Documentation
│   ├── DEPLOYMENT-SPEC.md     # Complete deployment workflow
│   ├── OPERATIONS.md          # Day-to-day operations
│   └── TROUBLESHOOTING.md     # Common issues & solutions
├── AGENTS.md                   # AI assistant guidelines (this file)
├── CLAUDE.md                   # Claude-specific quick reference
└── JIMMYS-WORKFLOW.md         # Complete workflow documentation
```

## Development Workflow

### Chromebook (Orchestrator) Workflow
1. Read AGENTS.md for context
2. Create detailed execution specs for Beast
3. Use Jimmy's Workflow for planning:
   - 🔴 RED: Design solution, create specs
   - 🟢 GREEN: Review specs with checklist
   - 🔵 CHECKPOINT: Commit and push to GitHub
4. Push specifications to GitHub
5. Pull results from Beast, audit implementation
6. Approve or request iterations

### Beast (Executor) Workflow
1. Pull latest from GitHub
2. Execute deployment following specs
3. Use Jimmy's Workflow for implementation:
   - 🔴 RED: Deploy infrastructure
   - 🟢 GREEN: Validate with explicit commands
   - 🔵 CHECKPOINT: Document completion, push results
4. Push results to GitHub
5. Await review from Chromebook

## Known Issues & Technical Debt

<!-- PROJECT_SPECIFIC START: KNOWN_ISSUES -->
### 🔴 Critical Issues
None yet - project just initialized

### 🟡 Important Issues
None yet

### 📝 Technical Debt
None yet - greenfield project
<!-- PROJECT_SPECIFIC END: KNOWN_ISSUES -->

## Project-Specific Guidelines

<!-- PROJECT_SPECIFIC START: PROJECT_SPECIFIC_GUIDELINES -->

### Port Management
**CRITICAL**: Never hardcode ports in specifications

```bash
# Bad (hardcoded)
browser-01:
  ports: ["7001:7900"]

# Good (environment variable)
browser-01:
  ports: ["${BROWSER_01_PORT}:7900"]
```

**Process**:
1. Beast runs `scripts/check-ports.sh` to find 20+ available ports
2. Beast creates `.env` file with PORT assignments
3. docker-compose.yml references environment variables
4. Deployment uses dynamically assigned ports

### Resource Limits
Each browser container should have:
- Memory limit: 512MB - 1GB (depending on usage)
- CPU limit: 1 core
- Shared memory: 2GB (prevents Chrome crashes)

### Volume Naming
- Pattern: `browser-{number}-data` (e.g., browser-01-data, browser-02-data)
- Persistent: All browser profiles must persist across restarts
- Cleanup: Document volume removal procedure for fresh starts

### Dashboard Design
- KISS principle: Vanilla HTML/CSS/JS, no frameworks
- Grid layout: 4x5 or 5x4 (20 instances)
- Auto-refresh screenshots: Every 10-30 seconds
- Click thumbnail: Opens full noVNC session in new tab
<!-- PROJECT_SPECIFIC END: PROJECT_SPECIFIC_GUIDELINES -->

## Environment Variables

<!-- PROJECT_SPECIFIC START: ENVIRONMENT_VARIABLES -->
```bash
# Grid Dashboard
DASHBOARD_PORT=3001  # Assigned dynamically

# Browser Instances (20 total, ports assigned dynamically)
BROWSER_01_PORT=7001  # Example - DO NOT HARDCODE
BROWSER_02_PORT=7002
# ... through BROWSER_20_PORT

# VNC Configuration
VNC_NO_PASSWORD=1  # Or set VNC_PASSWORD for security
SCREEN_WIDTH=1920
SCREEN_HEIGHT=1080

# Monitoring
ENABLE_PROMETHEUS_METRICS=true
GRAFANA_DASHBOARD_ID=browser-farm
```

**Port Assignment**: Generated by `scripts/check-ports.sh` on Beast
<!-- PROJECT_SPECIFIC END: ENVIRONMENT_VARIABLES -->

## Dependencies & Integration

<!-- PROJECT_SPECIFIC START: DEPENDENCIES -->
### External Services
- **Midnight Network**: https://www.midnight.gd/scavenger-mine (target application)
- **Selenium Hub**: Container orchestration for browsers
- **noVNC**: Web-based VNC client for browser access

### Beast Infrastructure Integration
- **Prometheus**: Metrics collection from browser containers
- **Grafana**: Visualization of browser farm metrics
- **Cloudflare Tunnel**: Optional external access (existing on Beast)
- **Docker Network**: Connects to existing `monitoring` network
<!-- PROJECT_SPECIFIC END: DEPENDENCIES -->

## Common Patterns & Examples

<!-- PROJECT_SPECIFIC START: COMMON_PATTERNS -->
### Pattern 1: Accessing Browser Instance

```bash
# Find browser port
grep BROWSER_05_PORT .env

# Open in browser (from Chromebook)
http://192.168.68.100:7005

# SSH to Beast and check container
ssh beast
docker logs browser-05
```

### Pattern 2: Restarting Individual Browser

```bash
# On Beast
cd ~/scavenger-mine
./scripts/restart-browser.sh 5

# Verify
docker ps | grep browser-05
```

### Pattern 3: Clearing Browser Profile

```bash
# On Beast
cd ~/scavenger-mine
docker compose stop browser-05
docker volume rm scavenger-mine_browser-05-data
docker compose up -d browser-05
```
<!-- PROJECT_SPECIFIC END: COMMON_PATTERNS -->

## Troubleshooting

<!-- PROJECT_SPECIFIC START: TROUBLESHOOTING -->
### Common Issues

**Issue**: Browser won't start (OOM error)
**Solution**: Increase memory limit in docker-compose.yml or reduce number of instances

**Issue**: Can't access noVNC web interface
**Solution**: Check port mapping with `docker ps`, verify port is not blocked by firewall

**Issue**: Browser crashes frequently
**Solution**: Increase shm_size to 2gb in docker-compose.yml (Chrome requirement)

**Issue**: Lost browser session after restart
**Solution**: Verify volume is mounted correctly, check docker volume ls
<!-- PROJECT_SPECIFIC END: TROUBLESHOOTING -->

## Resources & References

### Documentation
- [Selenium Docker](https://github.com/SeleniumHQ/docker-selenium)
- [noVNC](https://github.com/novnc/noVNC)
- [Jimmy's Workflow](./JIMMYS-WORKFLOW.md)

### Beast Infrastructure
- [Beast Infrastructure Status](https://github.com/Jimmyh-world/dev-network/blob/main/beast/docs/BEAST-INFRASTRUCTURE-STATUS.md)
- [Monitoring Setup](https://github.com/Jimmyh-world/dev-network/blob/main/beast/docs/MONITORING-INFRASTRUCTURE-SETUP.md)

## Template Version Management

**Current Template Version**: 1.5.0 (see comment at top of file)

This project uses versioned templates from `/home/jimmyb/templates/`

### Check if Templates are Up to Date

```bash
~/templates/tools/check-version.sh
```

### View Template Changelog

```bash
cat ~/templates/CHANGELOG.md
```

### Sync to Latest Version

```bash
~/templates/tools/sync-templates.sh --dry-run   # Preview changes
~/templates/tools/sync-templates.sh             # Apply changes
```

## Important Reminders for AI Assistants

1. **Always use Jimmy's Workflow** for implementation tasks
2. **Follow TDD** - Write tests before implementation
3. **Keep it KISS** - Simplicity over complexity
4. **Apply YAGNI** - Only implement what's needed now
5. **Use GitHub CLI** - Use `gh` for all GitHub operations
6. **Fix Now** - Never defer fixes
7. **Document dates** - Include actual dates in all documentation
8. **Validate explicitly** - Run commands, don't assume
9. **Never skip checkpoints** - Each phase must complete before proceeding
10. **Port Management** - NEVER hardcode ports, always check dynamically on Beast

---

**This document follows the [agents.md](https://agents.md/) standard for AI coding assistants.**

**Template Version**: 1.5.0
**Last Updated**: 2025-10-29
