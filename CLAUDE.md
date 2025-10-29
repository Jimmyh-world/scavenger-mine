# Claude AI Assistant Instructions - Scavenger Mine

<!--
TEMPLATE_VERSION: 1.4.2
TEMPLATE_SOURCE: /home/jimmyb/templates/CLAUDE.md.template
-->

Please refer to **AGENTS.md** for complete development guidelines and project context.

This project follows the [agents.md](https://agents.md/) standard for AI coding assistants.

## Quick Reference

### Project Purpose
Deploy 20 VNC-accessible browser instances on Beast for Midnight Network scavenger mining.

### Machine Roles
- **Chromebook** (this machine): Orchestrator, planning, specs, code review
- **Beast** (192.168.68.100): Executor, Docker deployment, heavy workloads
- **GitHub**: Single source of truth for coordination

### Core Development Principles
1. **KISS** - Keep It Simple, Stupid
2. **TDD** - Test-Driven Development
3. **SOC** - Separation of Concerns
4. **DRY** - Don't Repeat Yourself
5. **Documentation Standards** - Factual, dated, objective
6. **Jimmy's Workflow** - Red/Green Checkpoints (MANDATORY)
7. **YAGNI** - You Ain't Gonna Need It
8. **Fix Now** - Never defer known issues

### Jimmy's Workflow
Use for all tasks:
- 🔴 **RED**: IMPLEMENT (write specs, plan, design)
- 🟢 **GREEN**: VALIDATE (review specs, check completeness)
- 🔵 **CHECKPOINT**: GATE (commit, push to GitHub)

**Invoke**: *"Let's use Jimmy's Workflow to execute this plan"*

**Reference**: See **JIMMYS-WORKFLOW.md** for complete system

### Critical Rules
- ✅ **NEVER hardcode ports** - Always use dynamic port checking on Beast
- ✅ Create detailed execution specs for Beast
- ✅ Use environment variables for all port assignments
- ✅ Document rollback procedures
- ✅ Push specs to GitHub before Beast execution
- ✅ Review Beast's implementation results
- ✅ Use `gh` CLI for all GitHub operations
- ❌ Never execute heavy operations on Chromebook - delegate to Beast
- ❌ Never skip validation phases
- ❌ Never assume - always verify

### Common Commands (Chromebook - Orchestrator)
```bash
# Start planning session
cd ~/scavenger-mine
claude

# Push specifications to GitHub
git add .
git commit -m "spec: [description]"
git push origin main

# Pull results from Beast
git pull origin main

# Review Beast's work
git log --oneline -5
git diff HEAD~1
```

### Common Commands (Beast - Executor)
```bash
# Pull latest specs
cd ~/scavenger-mine
git pull origin main

# Check available ports (REQUIRED before deployment)
bash scripts/check-ports.sh

# Deploy
docker compose up -d

# Verify
docker compose ps
bash scripts/status.sh
```

### GitHub Operations
```bash
# Create repository
gh repo create Jimmyh-world/scavenger-mine --public --description "Browser farm for Midnight Network mining"

# Issues
gh issue create --title "Bug" --body "Description"
gh issue list

# Pull Requests
gh pr create --title "feat: deployment spec" --body "Description"
gh pr checks
```

### Port Management (CRITICAL)
```bash
# On Beast BEFORE creating docker-compose.yml
bash scripts/check-ports.sh > .env

# Verify generated .env file
cat .env | grep BROWSER

# docker-compose.yml MUST use env vars
# BAD:  ports: ["7001:7900"]
# GOOD: ports: ["${BROWSER_01_PORT}:7900"]
```

---

*Last updated: 2025-10-29*
*Template Version: 1.4.2*
