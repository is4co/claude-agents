#!/bin/bash
#
# Installation script for Claude Code agents
# Compatible with: macOS, Ubuntu, Raspberry Pi (Raspbian/Debian)
# Usage: ./install.sh [--symlink] [--config]
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
AGENTS_DIR="$CLAUDE_DIR/agents"
CONFIG_FILE="$CLAUDE_DIR/config.sh"

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

# Detect platform
detect_platform() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            if [[ "$ID" == "raspbian" ]] || [[ "$ID" == "debian" ]]; then
                if grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
                    echo "Raspberry Pi"
                else
                    echo "Debian/Ubuntu"
                fi
            elif [[ "$ID" == "ubuntu" ]]; then
                echo "Ubuntu"
            else
                echo "Linux"
            fi
        else
            echo "Linux"
        fi
    else
        echo "Unknown"
    fi
}

PLATFORM=$(detect_platform)
log "Detected platform: $PLATFORM"

# Create Claude directory if it doesn't exist
if [ ! -d "$CLAUDE_DIR" ]; then
    log "Creating Claude Code directory: $CLAUDE_DIR"
    mkdir -p "$CLAUDE_DIR"
fi

# Create agents directory
if [ ! -d "$AGENTS_DIR" ]; then
    log "Creating agents directory: $AGENTS_DIR"
    mkdir -p "$AGENTS_DIR"
else
    warn "Agents directory already exists: $AGENTS_DIR"
fi

# Install agents
log "Installing Claude Code agents..."

if [ "$1" = "--symlink" ] || [ "$2" = "--symlink" ]; then
    # Use symlinks (updates automatically when repo changes)
    log "Creating symlinks for dynamic updates..."
    if [ -d "$SCRIPT_DIR/agents" ] && [ "$(ls -A $SCRIPT_DIR/agents/*.md 2>/dev/null)" ]; then
        for agent in "$SCRIPT_DIR/agents"/*.md; do
            agent_name=$(basename "$agent")
            # Remove existing file/symlink if present
            [ -e "$AGENTS_DIR/$agent_name" ] && rm "$AGENTS_DIR/$agent_name"
            ln -sf "$agent" "$AGENTS_DIR/$agent_name"
            log "  Linked: $agent_name"
        done
        info "Agents linked! Changes to the repo will be reflected automatically."
    else
        warn "No agents found in $SCRIPT_DIR/agents/"
        info "Add your agent files (.md) to the agents/ directory"
    fi
else
    # Copy files (static installation)
    log "Copying agent files..."
    if [ -d "$SCRIPT_DIR/agents" ] && [ "$(ls -A $SCRIPT_DIR/agents/*.md 2>/dev/null)" ]; then
        cp "$SCRIPT_DIR/agents"/*.md "$AGENTS_DIR/"
        for agent in "$SCRIPT_DIR/agents"/*.md; do
            log "  Installed: $(basename "$agent")"
        done
        info "Static installation complete. Run 'git pull && ./install.sh' to update."
    else
        warn "No agents found in $SCRIPT_DIR/agents/"
        info "Add your agent files (.md) to the agents/ directory"
    fi
fi

# Handle configuration (optional)
if [ "$1" = "--config" ] || [ "$2" = "--config" ]; then
    if [ ! -f "$CONFIG_FILE" ]; then
        log "Creating configuration file from template..."
        if [ -f "$SCRIPT_DIR/templates/config.template.sh" ]; then
            cp "$SCRIPT_DIR/templates/config.template.sh" "$CONFIG_FILE"
            log "Configuration created at: $CONFIG_FILE"
            warn "⚠️  IMPORTANT: Edit $CONFIG_FILE to customize for your system!"
            echo ""
            read -p "Open config file now for editing? (y/n): " open_config
            if [ "$open_config" = "y" ]; then
                ${EDITOR:-nano} "$CONFIG_FILE"
            fi
        else
            warn "Template file not found: $SCRIPT_DIR/templates/config.template.sh"
        fi
    else
        log "Configuration file already exists: $CONFIG_FILE"
    fi
fi

echo ""
log "✅ Installation complete!"
echo ""
echo "Platform: $PLATFORM"
echo "Claude Code directory: $CLAUDE_DIR"
echo "Agents installed to: $AGENTS_DIR"
echo ""

# Count installed agents
agent_count=$(ls -1 "$AGENTS_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
if [ "$agent_count" -gt 0 ]; then
    echo "Installed agents ($agent_count):"
    for agent in "$AGENTS_DIR"/*.md; do
        agent_name=$(basename "$agent" .md)
        # Try to extract description from YAML frontmatter
        description=$(grep "^description:" "$agent" 2>/dev/null | head -1 | sed 's/description: //' | cut -c1-60)
        if [ -n "$description" ]; then
            echo "  • $agent_name - $description"
        else
            echo "  • $agent_name"
        fi
    done
else
    warn "No agents installed yet!"
    info "Add agent files (.md) to $SCRIPT_DIR/agents/ and run install again"
fi

echo ""
echo "📖 Next steps:"
echo "  1. Restart Claude Code to load new agents"
echo "  2. Agents will be available automatically when needed"
echo "  3. Check README.md for usage examples"
echo ""
echo "💡 Tips:"
echo "  • Use --symlink for development (auto-updates)"
echo "  • Use copy mode for production (stable)"
echo "  • Run 'git pull && ./install.sh' to update"
echo ""
