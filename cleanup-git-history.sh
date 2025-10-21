#!/bin/bash
set -e

# STING-CE-Docs Git History Cleanup Script
# This script completely removes all traces of internal files from git history
#
# WARNING: This is DESTRUCTIVE and IRREVERSIBLE!
# Only run this on the PUBLIC copy of the repository!
#
# Author: Claude Code
# Date: 2025-10-20

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================"
echo "STING-CE-Docs Git History Cleanup"
echo "================================================"
echo ""

# Safety checks
echo -e "${RED}⚠️  WARNING: This script will COMPLETELY REWRITE git history!${NC}"
echo -e "${RED}⚠️  This action is IRREVERSIBLE!${NC}"
echo ""
echo -e "${YELLOW}Prerequisites:${NC}"
echo "  1. You must have already run cleanup-for-public.sh"
echo "  2. You must be in the PUBLIC copy of the repository"
echo "  3. You must have committed the file removals"
echo "  4. You should have pushed the original to STING-CE-Docs-Internal first"
echo ""
echo "Current directory: $SCRIPT_DIR"
echo ""

read -p "Have you completed all prerequisites? (yes/no): " prereq_check
if [ "$prereq_check" != "yes" ]; then
    echo -e "${RED}Aborted. Complete prerequisites first.${NC}"
    exit 1
fi

read -p "Are you CERTAIN you want to rewrite git history? (type 'DELETE HISTORY'): " confirm
if [ "$confirm" != "DELETE HISTORY" ]; then
    echo -e "${RED}Aborted. Confirmation did not match.${NC}"
    exit 1
fi

# Check if git-filter-repo is available
if ! command -v git-filter-repo &> /dev/null; then
    echo ""
    echo -e "${YELLOW}git-filter-repo not found. Installing...${NC}"
    echo ""
    echo "Installing git-filter-repo via pip..."

    if command -v pip3 &> /dev/null; then
        pip3 install git-filter-repo
    elif command -v pip &> /dev/null; then
        pip install git-filter-repo
    else
        echo -e "${RED}Error: pip not found. Please install git-filter-repo manually:${NC}"
        echo "  pip install git-filter-repo"
        echo "  or download from: https://github.com/newren/git-filter-repo"
        exit 1
    fi
fi

# Verify we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}Error: Not in a git repository!${NC}"
    exit 1
fi

# Create list of files to remove from history
echo ""
echo -e "${GREEN}Creating filter list...${NC}"

cat > /tmp/paths-to-remove.txt << 'EOF'
# HIGH CONFIDENCE INTERNAL
content/en/docs/features/chatbot-implementation-progress.md
content/en/docs/features/report-system-implementation.md
content/en/docs/features/bee-agentic-capabilities.md
content/en/docs/features/bee-swarm-networking.md
content/en/docs/features/bee-dances-enterprise.md
content/en/docs/architecture/honeycomb-vault-architecture.md
content/en/docs/architecture/sting-chatbot-integration.md

# MEDIUM CONFIDENCE INTERNAL
content/en/docs/architecture/worker-bee-connector-framework.md
content/en/docs/architecture/native-dashboard-integration.md
content/en/docs/features/beeacon-log-monitoring.md

# DRAFT/UNCERTAIN INTERNAL
content/en/docs/troubleshooting/email-verification-status.md
content/en/docs/troubleshooting/installation-reliability-fix.md
content/en/docs/troubleshooting/restart-reliability-fix.md
content/en/docs/troubleshooting/login-ui-fixes-summary.md
content/en/docs/security/hybrid-passwordless-aal2-solution.md
content/en/docs/authentication/auth-testing-guide.md
content/en/docs/bee-features/bee-implementation-guide.md
EOF

echo "  ✓ Filter list created at /tmp/paths-to-remove.txt"

# Backup current state
echo ""
echo -e "${GREEN}Creating safety backup...${NC}"
BACKUP_BRANCH="backup-before-history-cleanup-$(date +%Y%m%d-%H%M%S)"
git branch "$BACKUP_BRANCH"
echo "  ✓ Created backup branch: $BACKUP_BRANCH"

# Show current size
echo ""
echo -e "${GREEN}Current repository size:${NC}"
du -sh .git

# Run git-filter-repo to remove files from history
echo ""
echo -e "${GREEN}Removing files from git history...${NC}"
echo -e "${YELLOW}This may take a few minutes...${NC}"
echo ""

git-filter-repo --invert-paths --paths-from-file /tmp/paths-to-remove.txt --force

echo ""
echo -e "${GREEN}✓ Git history rewritten successfully!${NC}"

# Show new size
echo ""
echo -e "${GREEN}New repository size:${NC}"
du -sh .git

# Clean up
echo ""
echo -e "${GREEN}Running garbage collection...${NC}"
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo ""
echo -e "${GREEN}Final repository size:${NC}"
du -sh .git

# Summary
echo ""
echo "========================================="
echo "GIT HISTORY CLEANUP COMPLETE"
echo "========================================="
echo ""
echo -e "${GREEN}✓ All internal files removed from git history${NC}"
echo -e "${GREEN}✓ Repository size optimized${NC}"
echo -e "${GREEN}✓ Backup branch created: $BACKUP_BRANCH${NC}"
echo ""
echo -e "${YELLOW}IMPORTANT NEXT STEPS:${NC}"
echo ""
echo "1. Verify the cleanup:"
echo "   git log --all --oneline | head -20"
echo "   git log --all -- content/en/docs/features/chatbot-implementation-progress.md"
echo "   (should show no commits)"
echo ""
echo "2. Test the repository:"
echo "   hugo server"
echo ""
echo "3. If everything looks good, set up as new public repo:"
echo "   git remote remove origin"
echo "   git remote add origin <new-public-repo-url>"
echo "   git push -u origin main --force"
echo ""
echo "4. For the original/internal repo:"
echo "   - Use the original directory (not this one)"
echo "   - Rename to STING-CE-Docs-Internal"
echo "   - Make repository private on GitHub"
echo "   - git remote set-url origin <internal-repo-url>"
echo "   - git push -u origin main"
echo ""
echo -e "${RED}⚠️  Do NOT push to the original GitHub repo after running this script!${NC}"
echo -e "${RED}⚠️  Create a NEW public repository instead.${NC}"
echo ""
echo -e "${GREEN}Cleanup complete!${NC}"
