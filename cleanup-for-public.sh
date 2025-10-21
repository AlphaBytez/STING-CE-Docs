#!/bin/bash
set -e

# STING-CE-Docs Public Repository Cleanup Script
# This script removes internal documentation to prepare for public release
#
# USAGE: Run this in a COPY of the repository, not the original!
#
# Author: Claude Code
# Date: 2025-10-20

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTENT_DIR="$SCRIPT_DIR/content/en"
BACKUP_DIR="$SCRIPT_DIR/removed-internal-docs-backup"
LOG_FILE="$SCRIPT_DIR/cleanup-log.txt"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================"
echo "STING-CE-Docs Public Repository Cleanup"
echo "================================================"
echo ""

# Safety check
echo -e "${YELLOW}WARNING: This script will DELETE internal documentation files.${NC}"
echo -e "${YELLOW}Make sure you are running this in a COPY of the repository!${NC}"
echo ""
echo "Current directory: $SCRIPT_DIR"
echo ""
read -p "Are you in a COPY of the repo (not the original)? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo -e "${RED}Aborted. Please run in a copy of the repository.${NC}"
    exit 1
fi

# Create backup directory
echo -e "${GREEN}Creating backup directory...${NC}"
mkdir -p "$BACKUP_DIR"

# Initialize log
echo "STING-CE-Docs Cleanup Log - $(date)" > "$LOG_FILE"
echo "==========================================" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Array of HIGH CONFIDENCE INTERNAL files to remove
declare -a HIGH_CONFIDENCE_INTERNAL=(
    "docs/features/chatbot-implementation-progress.md"
    "docs/features/report-system-implementation.md"
    "docs/features/bee-agentic-capabilities.md"
    "docs/features/bee-swarm-networking.md"
    "docs/features/bee-dances-enterprise.md"
    "docs/architecture/honeycomb-vault-architecture.md"
    "docs/architecture/sting-chatbot-integration.md"
)

# Array of MEDIUM CONFIDENCE INTERNAL files to remove
declare -a MEDIUM_CONFIDENCE_INTERNAL=(
    "docs/architecture/worker-bee-connector-framework.md"
    "docs/architecture/native-dashboard-integration.md"
    "docs/features/beeacon-log-monitoring.md"
)

# Array of UNCERTAIN/DRAFT files to remove (internal testing/unfinished)
declare -a DRAFT_INTERNAL=(
    "docs/troubleshooting/email-verification-status.md"
    "docs/troubleshooting/installation-reliability-fix.md"
    "docs/troubleshooting/restart-reliability-fix.md"
    "docs/troubleshooting/login-ui-fixes-summary.md"
    "docs/security/hybrid-passwordless-aal2-solution.md"
    "docs/authentication/auth-testing-guide.md"
    "docs/bee-features/bee-implementation-guide.md"
)

# Function to backup and remove file
backup_and_remove() {
    local file_path="$1"
    local full_path="$CONTENT_DIR/$file_path"

    if [ -f "$full_path" ]; then
        # Create backup directory structure
        local backup_path="$BACKUP_DIR/$file_path"
        local backup_dir=$(dirname "$backup_path")
        mkdir -p "$backup_dir"

        # Copy to backup
        cp "$full_path" "$backup_path"
        echo "  ✓ Backed up: $file_path"
        echo "Backed up: $file_path" >> "$LOG_FILE"

        # Remove from repo
        rm "$full_path"
        echo "  ✓ Removed: $file_path"
        echo "Removed: $file_path" >> "$LOG_FILE"

        return 0
    else
        echo "  ⚠ Not found: $file_path"
        echo "Not found: $file_path" >> "$LOG_FILE"
        return 1
    fi
}

# Remove HIGH CONFIDENCE INTERNAL files
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Removing HIGH CONFIDENCE INTERNAL files${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "HIGH CONFIDENCE INTERNAL FILES" >> "$LOG_FILE"
echo "------------------------------" >> "$LOG_FILE"

removed_count=0
for file in "${HIGH_CONFIDENCE_INTERNAL[@]}"; do
    if backup_and_remove "$file"; then
        ((removed_count++))
    fi
done

echo ""
echo "Removed $removed_count high confidence internal files."
echo "" >> "$LOG_FILE"

# Remove MEDIUM CONFIDENCE INTERNAL files
echo ""
echo -e "${GREEN}===========================================${NC}"
echo -e "${GREEN}Removing MEDIUM CONFIDENCE INTERNAL files${NC}"
echo -e "${GREEN}===========================================${NC}"
echo ""
echo "MEDIUM CONFIDENCE INTERNAL FILES" >> "$LOG_FILE"
echo "--------------------------------" >> "$LOG_FILE"

medium_removed=0
for file in "${MEDIUM_CONFIDENCE_INTERNAL[@]}"; do
    if backup_and_remove "$file"; then
        ((medium_removed++))
    fi
done

echo ""
echo "Removed $medium_removed medium confidence internal files."
echo "" >> "$LOG_FILE"

# Remove DRAFT/UNCERTAIN files
echo ""
echo -e "${GREEN}==============================${NC}"
echo -e "${GREEN}Removing DRAFT/INTERNAL files${NC}"
echo -e "${GREEN}==============================${NC}"
echo ""
echo "DRAFT/UNCERTAIN INTERNAL FILES" >> "$LOG_FILE"
echo "------------------------------" >> "$LOG_FILE"

draft_removed=0
for file in "${DRAFT_INTERNAL[@]}"; do
    if backup_and_remove "$file"; then
        ((draft_removed++))
    fi
done

echo ""
echo "Removed $draft_removed draft/uncertain files."
echo "" >> "$LOG_FILE"

# Clean up "planned" references from API index
echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Cleaning API documentation${NC}"
echo -e "${GREEN}================================${NC}"
echo ""

API_INDEX="$CONTENT_DIR/api/_index.md"
if [ -f "$API_INDEX" ]; then
    # Backup original
    cp "$API_INDEX" "$BACKUP_DIR/api/_index.md.original"

    # Remove lines mentioning "planned" SDKs
    echo "Cleaning $API_INDEX..."
    sed -i '/Python SDK (planned)/d' "$API_INDEX"
    sed -i '/JavaScript\/TypeScript SDK (planned)/d' "$API_INDEX"
    sed -i '/Go SDK (planned)/d' "$API_INDEX"
    sed -i '/(planned)/d' "$API_INDEX"

    echo "  ✓ Removed 'planned' SDK references from API index"
    echo "Cleaned: api/_index.md (removed planned SDK references)" >> "$LOG_FILE"
fi

# Clean "coming soon" from admin guide
ADMIN_GUIDE="$CONTENT_DIR/docs/administration/admin-guide.md"
if [ -f "$ADMIN_GUIDE" ]; then
    cp "$ADMIN_GUIDE" "$BACKUP_DIR/docs/administration/admin-guide.md.original"

    echo "Cleaning $ADMIN_GUIDE..."
    # Remove "coming soon" sections
    sed -i '/Coming Soon/d' "$ADMIN_GUIDE"
    sed -i '/coming soon/d' "$ADMIN_GUIDE"

    echo "  ✓ Removed 'coming soon' references from admin guide"
    echo "Cleaned: docs/administration/admin-guide.md (removed 'coming soon' references)" >> "$LOG_FILE"
fi

# Clean up empty directories
echo ""
echo -e "${GREEN}===========================${NC}"
echo -e "${GREEN}Cleaning empty directories${NC}"
echo -e "${GREEN}===========================${NC}"
echo ""

find "$CONTENT_DIR" -type d -empty -delete
echo "  ✓ Removed empty directories"

# Generate summary
total_removed=$((removed_count + medium_removed + draft_removed))

echo ""
echo "========================================="
echo "SUMMARY"
echo "========================================="
echo ""
echo "Summary" >> "$LOG_FILE"
echo "-------" >> "$LOG_FILE"

echo -e "${GREEN}✓ High confidence internal files removed: $removed_count${NC}"
echo "High confidence internal files removed: $removed_count" >> "$LOG_FILE"

echo -e "${GREEN}✓ Medium confidence internal files removed: $medium_removed${NC}"
echo "Medium confidence internal files removed: $medium_removed" >> "$LOG_FILE"

echo -e "${GREEN}✓ Draft/uncertain files removed: $draft_removed${NC}"
echo "Draft/uncertain files removed: $draft_removed" >> "$LOG_FILE"

echo -e "${GREEN}✓ Total files removed: $total_removed${NC}"
echo "Total files removed: $total_removed" >> "$LOG_FILE"

echo ""
echo -e "${GREEN}✓ API documentation cleaned${NC}"
echo -e "${GREEN}✓ Admin guide cleaned${NC}"
echo ""

echo ""
echo "All removed files backed up to: $BACKUP_DIR"
echo "Full log saved to: $LOG_FILE"
echo ""

echo ""
echo "========================================="
echo "NEXT STEPS"
echo "========================================="
echo ""
echo "1. Review the cleanup log: cat $LOG_FILE"
echo "2. Verify the changes: git status"
echo "3. Test the site: hugo server"
echo "4. If satisfied, commit changes: git add -A && git commit -m 'Remove internal documentation'"
echo ""
echo -e "${YELLOW}5. CLEAN GIT HISTORY (removes all traces):${NC}"
echo "   Run: bash cleanup-git-history.sh"
echo ""
echo -e "${YELLOW}6. For the INTERNAL repo:${NC}"
echo "   - Rename this original repo to STING-CE-Docs-Internal"
echo "   - Make it private on GitHub"
echo "   - Keep all files and history intact"
echo ""
echo -e "${GREEN}Cleanup complete!${NC}"
