# Claude Code Agents Repository

Personal collection of Claude Code CLI agents for use across multiple systems and platforms.

## 📋 Overview

This repository contains custom Claude Code agents for specialized development tasks. Agents are portable across different systems (macOS, Ubuntu, Raspberry Pi, VPS) and help maintain consistent AI assistance patterns.

**Compatible Platforms:**
- macOS (Intel & Apple Silicon)
- Ubuntu/Debian Linux
- Raspberry Pi (Raspbian)
- Other Linux distributions

## 🚀 Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/is4co/claude-agents.git

# Navigate to the directory
cd claude-agents

# Make scripts executable
chmod +x install.sh sync.sh

# Install agents (copy mode - stable)
./install.sh

# Or use symlink mode (auto-updates with git pull)
./install.sh --symlink
```

### Syncing Updates

After making changes or pulling updates:

```bash
cd claude-agents
git pull
./sync.sh
```

## 📁 Repository Structure

```
claude-agents/
├── README.md              # This file
├── install.sh            # Cross-platform installation script
├── sync.sh               # Sync/update script
├── agents/               # Your custom agent definitions (.md files)
│   ├── example-agent.md
│   └── ...
├── templates/            # Templates for creating new agents
│   ├── agent-template.md
│   └── config.template.sh
├── docs/                 # Extended documentation
│   └── CREATING-AGENTS.md
└── .gitignore

```

## 📚 What are Claude Code Agents?

Claude Code agents are specialized AI assistants that activate automatically based on task context. Each agent is defined in a markdown file with:

- **YAML frontmatter** - Configuration (name, description, tools, color)
- **System prompt** - Detailed instructions defining agent behavior
- **Examples** - Context showing when the agent should activate

### Example Agent Structure

```markdown
---
name: my-specialized-agent
description: Use this agent when [scenario]
color: blue
tools: Read, Write, Bash, Grep, Glob
---

You are a [role] specializing in [domain]...
```

## 🎯 Installation Methods

### Method 1: Copy (Recommended for Production)

Copies agent files to `~/.claude/agents/` - stable but requires manual updates.

```bash
./install.sh
```

**Pros:**
- Stable - changes to repo won't affect running system
- Clean separation between repo and active agents

**Cons:**
- Must run `./sync.sh` to update

### Method 2: Symlink (Recommended for Development)

Creates symlinks from `~/.claude/agents/` to repo files - auto-updates with git pull.

```bash
./install.sh --symlink
```

**Pros:**
- Automatic updates when you `git pull`
- Great for active development

**Cons:**
- Repo changes immediately affect Claude Code
- Must keep repo directory intact

## 🔧 Creating Custom Agents

### Quick Start

```bash
# Copy template
cp templates/agent-template.md agents/my-new-agent.md

# Edit the agent
nano agents/my-new-agent.md

# Install
./install.sh

# Restart Claude Code
```

### Agent Template

See `templates/agent-template.md` for the complete structure. Key sections:

1. **Name** - Unique identifier (kebab-case)
2. **Description** - When to use + 2-4 examples with context
3. **Tools** - Which Claude Code tools the agent can access
4. **System Prompt** - Detailed role, responsibilities, and behavior

### Tool Access

Common tool combinations:

- **Read-only**: `Read, Grep, Glob` - Code exploration
- **Basic editing**: `Read, Write, Edit` - File modifications
- **Full access**: `Read, Write, Edit, Bash, Grep, Glob` - Complete control
- **Development**: `Read, Write, MultiEdit, Bash, Grep, Glob` - Multi-file changes

## 🔄 Multi-System Workflow

### Initial Setup on New System

```bash
# On any system (macOS, Linux, Raspberry Pi, etc.)
git clone https://github.com/is4co/claude-agents.git
cd claude-agents
chmod +x install.sh sync.sh
./install.sh
```

### Making Changes

```bash
# On system A - create new agent
cd ~/claude-agents
cp templates/agent-template.md agents/database-optimizer.md
# Edit the agent...
git add agents/database-optimizer.md
git commit -m "Add database optimizer agent"
git push

# On system B - sync the change
cd ~/claude-agents
git pull
./sync.sh
# Restart Claude Code
```

### Platform-Specific Agents

You can create platform-specific agents:

```bash
agents/
├── deploy-macos.md      # macOS specific
├── deploy-ubuntu.md     # Ubuntu specific
└── deploy-raspi.md      # Raspberry Pi specific
```

Then selectively install:

```bash
# On macOS
cp agents/deploy-macos.md ~/.claude/agents/deploy.md

# On Ubuntu
cp agents/deploy-ubuntu.md ~/.claude/agents/deploy.md
```

## 🛡️ Security Best Practices

### What NOT to Include in This Repo

❌ **Never commit:**
- API keys or tokens
- Passwords or credentials
- SSH private keys
- System-specific IP addresses
- Production secrets

### Safe Patterns

✅ **Use placeholders:**
```bash
API_KEY="${API_KEY:-REPLACE_ME}"
DB_PASSWORD="${DB_PASSWORD}"  # From environment
```

✅ **Reference external configs:**
```bash
source ~/.secrets/api_keys.sh  # Not in repo
```

✅ **Document required environment variables:**
```markdown
## Required Environment Variables
- `GITHUB_TOKEN` - GitHub API access
- `DEPLOY_KEY` - SSH key path
```

## 📦 Version Management

### Semantic Versioning

Tag releases for stable checkpoints:

```bash
git tag -a v1.0.0 -m "Initial agent collection"
git push origin v1.0.0
```

### Installing Specific Versions

```bash
# Clone specific version
git clone --branch v1.0.0 https://github.com/is4co/claude-agents.git

# Or switch existing repo
cd claude-agents
git checkout v1.0.0
./install.sh
```

## 🔍 Testing Agents

Before committing new agents:

1. **Test locally** - Use the agent in real scenarios
2. **Verify activation** - Confirm agent triggers correctly
3. **Check tools** - Ensure agent has necessary tool access
4. **Document examples** - Add clear usage examples
5. **Test cross-platform** - If possible, test on multiple systems

## 🆘 Troubleshooting

### Agents not appearing in Claude Code

```bash
# Verify installation
ls -la ~/.claude/agents/

# Check agent format
head -10 ~/.claude/agents/your-agent.md
# Should start with:
# ---
# name: agent-name
# ...

# Restart Claude Code
exit
claude
```

### Symlinks broken after moving repo

```bash
# Reinstall with new path
cd /new/path/to/claude-agents
./install.sh --symlink
```

### Platform-specific issues

**macOS:**
```bash
# If permission denied
chmod +x install.sh sync.sh
```

**Linux/Ubuntu:**
```bash
# If bash not found
sudo apt install bash
```

**Raspberry Pi:**
```bash
# If low on space
df -h
# Clean up if needed
```

## 📖 Documentation

Additional documentation in `docs/`:
- `CREATING-AGENTS.md` - Comprehensive agent creation guide
- `EXAMPLES.md` - Real-world agent examples
- `TROUBLESHOOTING.md` - Common issues and solutions

## 🤝 Contributing

This is a personal repository, but the structure and templates are useful references for others building their own agent collections.

### Sharing Agents

To share an agent with others:

1. Ensure no sensitive info is included
2. Add clear documentation and examples
3. Test on multiple platforms if possible
4. Consider extracting to a separate public repo

## 📞 Support

For issues specific to Claude Code:
- [Claude Code Documentation](https://docs.anthropic.com/claude/docs/claude-code)
- [Claude Code GitHub Issues](https://github.com/anthropics/claude-code/issues)

For issues with this repository:
- Open an issue in this repo
- Include platform, Claude Code version, and error details

## 📄 License

MIT License - See LICENSE file for details

## 🗺️ Roadmap

- [ ] Create example agents for common tasks
- [ ] Add testing framework for agents
- [ ] Create platform-specific agent collections
- [ ] Add agent performance metrics
- [ ] Create agent documentation generator

## 💡 Tips

**Development Workflow:**
- Use `--symlink` for active development
- Create feature branches for experimental agents
- Tag stable versions for production systems

**Organization:**
- Use descriptive agent names (e.g., `deploy-to-production`, `analyze-logs`)
- Group related agents with prefixes (e.g., `deploy-*`, `test-*`)
- Keep agent prompts focused on single responsibilities

**Multi-System Management:**
- Keep a `SYSTEMS.md` file documenting which systems use which agents
- Use branches for system-specific configurations
- Tag versions when deploying to production systems

---

**Questions?** Check the [Claude Code documentation](https://docs.anthropic.com/claude/docs/claude-code) or open an issue.
