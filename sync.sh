#!/bin/bash
#
# Sync script for Claude Code agents
# Pulls latest changes and updates installation
# Usage: ./sync.sh
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
AGENTS_DIR="$CLAUDE_DIR/agents"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

info() {
    echo -e "${BLUE}[NOTE]${NC} $1"
}

echo "🔄 Syncing Claude Code agents..."
echo ""

# Check if we're in a git repository
if [ ! -d "$SCRIPT_DIR/.git" ]; then
    warn "Not a git repository. Skipping git pull."
    warn "If you installed via git clone, make sure you're in the repo directory."
else
    log "Pulling latest changes from repository..."
    cd "$SCRIPT_DIR"
    git pull
    echo ""
fi

# Check if agents directory exists
if [ ! -d "$AGENTS_DIR" ]; then
    warn "Agents directory not found: $AGENTS_DIR"
    info "Run ./install.sh first to set up agents"
    exit 1
fi

# Detect installation method (symlink or copy)
if [ -L "$AGENTS_DIR"/*.md ] 2>/dev/null; then
    log "Symlink installation detected"
    info "Agents are already up-to-date (symlinked to repo)"
else
    log "Copy installation detected"
    log "Updating agent files..."

    if [ -d "$SCRIPT_DIR/agents" ] && [ "$(ls -A $SCRIPT_DIR/agents/*.md 2>/dev/null)" ]; then
        # Backup existing agents
        backup_dir="$AGENTS_DIR/backup-$(date +%Y%m%d-%H%M%S)"
        mkdir -p "$backup_dir"
        if ls "$AGENTS_DIR"/*.md 1> /dev/null 2>&1; then
            cp "$AGENTS_DIR"/*.md "$backup_dir/"
            log "Backed up existing agents to: $backup_dir"
        fi

        # Copy updated agents
        cp "$SCRIPT_DIR/agents"/*.md "$AGENTS_DIR/"

        agent_count=0
        for agent in "$SCRIPT_DIR/agents"/*.md; do
            log "  Updated: $(basename "$agent")"
            ((agent_count++))
        done

        echo ""
        log "✅ Synced $agent_count agent(s)"
    else
        warn "No agents found in $SCRIPT_DIR/agents/"
    fi
fi

echo ""
info "Restart Claude Code to reload agents"
echo ""
