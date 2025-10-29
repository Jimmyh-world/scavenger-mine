# Scavenger Mine - Browser Farm for Midnight Network

**Status**: In Development
**Created**: 2025-10-29
**Target**: Beast (192.168.68.100)

Deploy 20 VNC-accessible browser instances for Midnight Network scavenger mining operations.

---

## Quick Start

### For Beast (Executor)

```bash
# Clone repository
git clone git@github.com:Jimmyh-world/scavenger-mine.git
cd scavenger-mine

# Follow deployment spec
cat docs/BEAST-DEPLOYMENT-SPEC.md

# Execute with Claude Code (Haiku 4.5 recommended)
claude
# Say: "Execute the deployment spec in docs/BEAST-DEPLOYMENT-SPEC.md using Jimmy's Workflow"
```

### For Chromebook (Orchestrator)

```bash
# Clone repository
git clone git@github.com:Jimmyh-world/scavenger-mine.git
cd scavenger-mine

# Review status
cat AGENTS.md

# Create new specifications or review Beast's work
claude
```

---

## Architecture

```
┌─────────────────────────────────────────┐
│  Grid Dashboard (Web UI)                │
│  http://192.168.68.100:${DASHBOARD_PORT}│
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│  20 Browser Instances (Selenium Chrome) │
│  Each with noVNC web interface          │
│  http://192.168.68.100:${BROWSER_XX_PORT}│
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│  Persistent Browser Profiles            │
│  Docker volumes: browser-01-data, etc.  │
└─────────────────────────────────────────┘
```

---

## Key Features

- ✅ 20 concurrent browser instances
- ✅ VNC access via web browser (noVNC)
- ✅ Persistent browser profiles (cookies, sessions)
- ✅ Grid dashboard for easy navigation
- ✅ Dynamic port allocation (no conflicts)
- ✅ Resource limits per container
- ✅ Integrated with Beast monitoring (Prometheus/Grafana)
- ✅ Management scripts for operations

---

## Resource Usage

| Component | RAM | CPU | Disk |
|-----------|-----|-----|------|
| Per Browser | ~600MB | 0.5 core | ~500MB |
| Total (20) | ~12GB | ~10 cores | ~10GB |
| Beast Capacity | 96GB | TBD | 2TB |
| Usage % | 12.5% | TBD | 0.5% |

**Conclusion**: Plenty of headroom on Beast

---

## Documentation

- **[AGENTS.md](./AGENTS.md)** - AI assistant guidelines, project context
- **[CLAUDE.md](./CLAUDE.md)** - Quick reference for Claude Code
- **[JIMMYS-WORKFLOW.md](./JIMMYS-WORKFLOW.md)** - Complete workflow system
- **[docs/BEAST-DEPLOYMENT-SPEC.md](./docs/BEAST-DEPLOYMENT-SPEC.md)** - Haiku 4.5 optimized deployment plan

---

## Machine Roles

### Chromebook (Orchestrator)
- Create deployment specifications
- Review Beast's implementation
- Code review and approval
- Planning and architecture

### Beast (Executor)
- Execute deployment specs
- Run Docker containers
- Heavy workloads
- Report results to GitHub

### GitHub (Coordination)
- Single source of truth
- Specs pushed by Chromebook
- Results pushed by Beast
- Pull requests for review

---

## Critical Rules

1. **NEVER hardcode ports** - Always use dynamic port checking
2. **Use Jimmy's Workflow** - RED → GREEN → CHECKPOINT
3. **Push specs to GitHub** - Before Beast execution
4. **Review results** - Chromebook audits Beast's work
5. **Document everything** - With actual dates

---

## Development Status

**Phase 1: Planning & Specification** - ✅ Complete (2025-10-29)
- Repository initialized
- AGENTS.md created
- Deployment spec created (Haiku 4.5 optimized)

**Phase 2: Infrastructure Setup** - ⚪ Pending
- Port discovery script
- Docker Compose configuration
- Grid dashboard
- Browser containers

**Phase 3: Deployment & Validation** - ⚪ Pending
- Deploy to Beast
- Validate all instances
- Resource usage check

**Phase 4: Operations** - ⚪ Pending
- Management scripts
- Documentation
- Monitoring integration

---

## Contributing

This project follows the [agents.md](https://agents.md/) standard for AI coding assistants.

All contributions must use **Jimmy's Workflow** (RED → GREEN → CHECKPOINT).

See [AGENTS.md](./AGENTS.md) for complete guidelines.

---

## License

Private project - All rights reserved

---

**Project follows**: Three-machine architecture (Chromebook-Guardian-Beast)
**Coordination**: GitHub single source of truth
**Workflow**: Jimmy's Workflow (RED→GREEN→CHECKPOINT)
**Last Updated**: 2025-10-29
