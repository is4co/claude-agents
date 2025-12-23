#!/bin/bash
# Safe Claude Agents Sync Script
# Shows changes for review before applying

set -e

REPO_DIR="$HOME/repos/claude-agents"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Claude Agents Safe Sync                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

cd "$REPO_DIR" || { echo -e "${RED}ERROR: Repo not found at $REPO_DIR${NC}"; exit 1; }

# Fetch without merging
echo -e "${YELLOW}Fetching remote changes...${NC}"
git fetch origin main

# Check if there are changes
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" = "$REMOTE" ]; then
    echo -e "${GREEN}✓ Already up to date. No changes to review.${NC}"
    exit 0
fi

# Show what changed
echo ""
echo -e "${YELLOW}═══ CHANGES PENDING ═══${NC}"
echo ""
echo -e "${BLUE}Commits:${NC}"
git log --oneline HEAD..origin/main
echo ""

echo -e "${BLUE}Files changed:${NC}"
git diff --stat HEAD..origin/main
echo ""

echo -e "${BLUE}Detailed diff (agents only):${NC}"
git diff HEAD..origin/main -- agents/
echo ""

# Security check - look for suspicious patterns
echo -e "${YELLOW}═══ SECURITY SCAN ═══${NC}"
SUSPICIOUS=$(git diff HEAD..origin/main -- agents/ | grep -iE "(curl|wget|nc |netcat|/dev/tcp|eval|exec|base64|python -c|bash -c|rm -rf|chmod 777|>>" || true)

if [ -n "$SUSPICIOUS" ]; then
    echo -e "${RED}⚠️  SUSPICIOUS PATTERNS DETECTED:${NC}"
    echo "$SUSPICIOUS"
    echo ""
    echo -e "${RED}Review carefully before proceeding!${NC}"
else
    echo -e "${GREEN}✓ No obviously suspicious patterns detected${NC}"
fi
echo ""

# Ask for confirmation
echo -e "${YELLOW}═══ CONFIRM UPDATE ═══${NC}"
read -p "Apply these changes? (y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Applying changes...${NC}"
    git merge origin/main
    echo -e "${GREEN}✓ Sync complete!${NC}"
    echo ""
    echo "Updated agents:"
    ls -la ~/.claude/agents/
else
    echo -e "${YELLOW}Sync cancelled. No changes applied.${NC}"
fi
