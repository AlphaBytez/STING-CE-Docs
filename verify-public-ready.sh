#!/bin/bash

# STING-CE-Docs Public Readiness Verification Script
# Checks if repository is ready for public release

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

echo "================================================"
echo "STING-CE-Docs Public Readiness Verification"
echo "================================================"
echo ""

# Check 1: Internal files removed
echo "Checking for internal files..."
INTERNAL_FILES=(
    "content/en/docs/features/chatbot-implementation-progress.md"
    "content/en/docs/features/report-system-implementation.md"
    "content/en/docs/features/bee-agentic-capabilities.md"
    "content/en/docs/features/bee-swarm-networking.md"
    "content/en/docs/features/bee-dances-enterprise.md"
    "content/en/docs/architecture/honeycomb-vault-architecture.md"
    "content/en/docs/architecture/sting-chatbot-integration.md"
    "content/en/docs/architecture/worker-bee-connector-framework.md"
    "content/en/docs/architecture/native-dashboard-integration.md"
    "content/en/docs/features/beeacon-log-monitoring.md"
)

for file in "${INTERNAL_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "  ${RED}✗ INTERNAL FILE FOUND: $file${NC}"
        ((ERRORS++))
    fi
done

if [ $ERRORS -eq 0 ]; then
    echo -e "  ${GREEN}✓ No internal files found${NC}"
fi

# Check 2: Draft files removed
echo ""
echo "Checking for draft files..."
DRAFT_COUNT=$(find content/en -name "*.md" -exec grep -l "draft: true" {} \; | wc -l)
if [ $DRAFT_COUNT -gt 0 ]; then
    echo -e "  ${YELLOW}⚠ Found $DRAFT_COUNT files marked as draft:${NC}"
    find content/en -name "*.md" -exec grep -l "draft: true" {} \;
    ((WARNINGS++))
else
    echo -e "  ${GREEN}✓ No draft files found${NC}"
fi

# Check 3: Sensitive keywords
echo ""
echo "Checking for sensitive keywords..."

if grep -r "implementation progress" content/ 2>/dev/null; then
    echo -e "  ${RED}✗ Found 'implementation progress' references${NC}"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓ No 'implementation progress' found${NC}"
fi

if grep -r "Enterprise+" content/ 2>/dev/null; then
    echo -e "  ${RED}✗ Found 'Enterprise+' references${NC}"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓ No 'Enterprise+' found${NC}"
fi

PLANNED_COUNT=$(grep -r "planned" content/en/api/ 2>/dev/null | wc -l)
if [ $PLANNED_COUNT -gt 0 ]; then
    echo -e "  ${RED}✗ Found $PLANNED_COUNT 'planned' references in API docs${NC}"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓ No 'planned' references in API docs${NC}"
fi

COMING_COUNT=$(grep -ri "coming soon" content/ 2>/dev/null | wc -l)
if [ $COMING_COUNT -gt 0 ]; then
    echo -e "  ${YELLOW}⚠ Found $COMING_COUNT 'coming soon' references${NC}"
    ((WARNINGS++))
else
    echo -e "  ${GREEN}✓ No 'coming soon' found${NC}"
fi

# Check 4: Git history
echo ""
echo "Checking git history for internal files..."
if git log --all -- content/en/docs/features/chatbot-implementation-progress.md 2>/dev/null | grep -q commit; then
    echo -e "  ${RED}✗ Internal files still in git history!${NC}"
    echo -e "  ${RED}  Run: bash cleanup-git-history.sh${NC}"
    ((ERRORS++))
else
    echo -e "  ${GREEN}✓ Git history clean${NC}"
fi

# Check 5: Hugo build
echo ""
echo "Testing Hugo build..."
if command -v hugo &> /dev/null; then
    if hugo > /tmp/hugo-build.log 2>&1; then
        echo -e "  ${GREEN}✓ Hugo builds successfully${NC}"
    else
        echo -e "  ${RED}✗ Hugo build failed${NC}"
        echo -e "  ${RED}  See: /tmp/hugo-build.log${NC}"
        ((ERRORS++))
    fi
else
    echo -e "  ${YELLOW}⚠ Hugo not found, skipping build test${NC}"
    ((WARNINGS++))
fi

# Check 6: File count
echo ""
echo "Checking file count..."
TOTAL_FILES=$(find content/en -name "*.md" | wc -l)
echo "  Total markdown files: $TOTAL_FILES"
if [ $TOTAL_FILES -gt 105 ]; then
    echo -e "  ${YELLOW}⚠ Expected ~101 files after cleanup, found $TOTAL_FILES${NC}"
    ((WARNINGS++))
else
    echo -e "  ${GREEN}✓ File count looks good${NC}"
fi

# Check 7: Backup exists
echo ""
echo "Checking for backup directory..."
if [ -d "removed-internal-docs-backup" ]; then
    BACKUP_COUNT=$(find removed-internal-docs-backup -name "*.md" | wc -l)
    echo -e "  ${GREEN}✓ Backup exists with $BACKUP_COUNT files${NC}"
else
    echo -e "  ${YELLOW}⚠ No backup directory found${NC}"
    ((WARNINGS++))
fi

# Check 8: Remote repository
echo ""
echo "Checking git remote..."
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "none")
if [[ "$REMOTE_URL" == *"Internal"* ]]; then
    echo -e "  ${RED}✗ Still pointing to internal repo!${NC}"
    echo -e "  ${RED}  Current: $REMOTE_URL${NC}"
    ((ERRORS++))
else
    echo "  Current remote: $REMOTE_URL"
    if [ "$REMOTE_URL" != "none" ]; then
        echo -e "  ${GREEN}✓ Remote configured${NC}"
    else
        echo -e "  ${YELLOW}⚠ No remote configured${NC}"
        ((WARNINGS++))
    fi
fi

# Summary
echo ""
echo "========================================="
echo "VERIFICATION SUMMARY"
echo "========================================="
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ ALL CHECKS PASSED!${NC}"
    echo ""
    echo "Repository is ready for public release!"
    echo ""
    echo "Next steps:"
    echo "  1. Create new public GitHub repository"
    echo "  2. git remote add origin <public-repo-url>"
    echo "  3. git push -u origin main --force"
    echo "  4. Enable GitHub Pages"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ PASSED WITH WARNINGS${NC}"
    echo ""
    echo -e "Errors: ${GREEN}$ERRORS${NC}"
    echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"
    echo ""
    echo "Review warnings above. Repository may be ready for public release."
    exit 0
else
    echo -e "${RED}✗ VERIFICATION FAILED${NC}"
    echo ""
    echo -e "Errors: ${RED}$ERRORS${NC}"
    echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"
    echo ""
    echo "Fix errors above before making repository public!"
    exit 1
fi
