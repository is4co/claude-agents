#!/bin/bash
#
# Claude Code Agents Configuration Template
# Copy this to ~/.claude/config.sh and customize
#

# Project Configuration
export PROJECT_NAME="your-project"
export ENVIRONMENT="production"  # production, staging, development

# Common Paths (customize for your system)
export PROJECT_ROOT="/path/to/your/project"
export BACKUP_DIR="/path/to/backups"
export LOGS_DIR="/var/log/your-app"

# Development Tools
export EDITOR="nano"  # or vim, code, etc.
export PYTHON_VERSION="3.11"
export NODE_VERSION="20"

# Notification Settings
export ADMIN_EMAIL="admin@example.com"
export SLACK_WEBHOOK_URL=""  # Optional

# Agent-Specific Settings

# For deployment agents
export DEPLOY_METHOD="git"  # git, rsync, docker, etc.
export DEPLOY_TARGET="user@server:/path"

# For database agents
export DB_TYPE="postgresql"  # postgresql, mysql, mongodb, etc.
export DB_HOST="localhost"
export DB_PORT="5432"
export DB_NAME="your_database"
# Note: Never store passwords here! Use environment variables or .env files

# For monitoring agents
export MONITORING_ENABLED="true"
export ALERT_THRESHOLD_CPU="80"
export ALERT_THRESHOLD_MEMORY="85"
export ALERT_THRESHOLD_DISK="90"

# Platform-Specific Settings
case "$OSTYPE" in
    darwin*)
        # macOS specific
        export PACKAGE_MANAGER="brew"
        ;;
    linux*)
        # Linux specific
        export PACKAGE_MANAGER="apt"  # or yum, dnf, pacman, etc.
        ;;
esac

# Custom Functions (optional)
notify() {
    local message="$1"
    # Add your notification logic here
    # e.g., send email, Slack message, etc.
    echo "[NOTIFICATION] $message"
}

# Load environment-specific config if exists
ENV_CONFIG="$HOME/.claude/config.$ENVIRONMENT.sh"
if [ -f "$ENV_CONFIG" ]; then
    source "$ENV_CONFIG"
fi
