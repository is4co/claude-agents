# Quick Setup Guide

Instructions for setting up claude-agents on any new system.

## One-Line Setup

```bash
git clone https://github.com/is4co/claude-agents.git && cd claude-agents && chmod +x install.sh sync.sh && ./install.sh
```

## Step-by-Step Setup

### 1. On Any New System (macOS, Ubuntu, Raspberry Pi, etc.)

```bash
# Clone the repository
git clone https://github.com/is4co/claude-agents.git

# Navigate to directory
cd claude-agents

# Make scripts executable
chmod +x install.sh sync.sh

# Install agents
./install.sh
```

**Choose installation method:**

- **Copy mode** (default) - Stable, requires `./sync.sh` to update
  ```bash
  ./install.sh
  ```

- **Symlink mode** - Auto-updates with `git pull`
  ```bash
  ./install.sh --symlink
  ```

### 2. Restart Claude Code

Exit and restart Claude Code to load the new agents.

## Platform-Specific Notes

### macOS
```bash
# Standard installation
git clone https://github.com/is4co/claude-agents.git
cd claude-agents
chmod +x *.sh
./install.sh
```

### Ubuntu/Debian
```bash
# May need to install git first
sudo apt update && sudo apt install -y git

# Then standard installation
git clone https://github.com/is4co/claude-agents.git
cd claude-agents
chmod +x *.sh
./install.sh
```

### Raspberry Pi
```bash
# Same as Ubuntu/Debian
sudo apt update && sudo apt install -y git
git clone https://github.com/is4co/claude-agents.git
cd claude-agents
chmod +x *.sh
./install.sh
```

### VPS (Remote Server)
```bash
# SSH into your server
ssh user@your-server

# Install git if needed
sudo apt update && sudo apt install -y git

# Clone and install
git clone https://github.com/is4co/claude-agents.git
cd claude-agents
chmod +x *.sh
./install.sh
```

## Keeping Agents in Sync

### If you used copy mode:
```bash
cd ~/claude-agents
git pull
./sync.sh
```

### If you used symlink mode:
```bash
cd ~/claude-agents
git pull
# Agents auto-update, just restart Claude Code
```

## Adding New Agents

### On your development machine:
```bash
cd ~/claude-agents

# Create new agent
cp templates/agent-template.md agents/my-new-agent.md

# Edit the agent
nano agents/my-new-agent.md

# Commit and push
git add agents/my-new-agent.md
git commit -m "Add my-new-agent"
git push
```

### On other systems:
```bash
cd ~/claude-agents
git pull
./sync.sh  # If using copy mode
# Restart Claude Code
```

## Troubleshooting

### "Permission denied" when running scripts
```bash
chmod +x install.sh sync.sh
```

### "git: command not found"
```bash
# Ubuntu/Debian/Raspberry Pi
sudo apt install -y git

# macOS
xcode-select --install
```

### Agents not appearing
```bash
# Check installation
ls -la ~/.claude/agents/

# Verify files exist
cat ~/.claude/agents/your-agent.md

# Restart Claude Code
exit
claude
```

### Git authentication issues
```bash
# Use HTTPS (no auth needed for public repo)
git clone https://github.com/is4co/claude-agents.git

# Or set up SSH keys for private repos
```

## Uninstalling

To remove all agents:
```bash
rm -rf ~/.claude/agents/*
```

To remove the repository:
```bash
rm -rf ~/claude-agents
```

## Verification

After installation, verify with:

```bash
# Check agents directory
ls -la ~/.claude/agents/

# Verify installation
cd ~/claude-agents
./install.sh  # Should show installed agents
```

## Next Steps

1. Create your first custom agent
2. Test it in Claude Code
3. Commit and sync to other systems
4. Read `docs/CREATING-AGENTS.md` for advanced techniques

---

**Need help?** Check README.md or open an issue on GitHub.
