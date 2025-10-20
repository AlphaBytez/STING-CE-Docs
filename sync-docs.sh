#!/bin/bash

# STING Documentation Sync Script
# Syncs markdown files from STING/docs to docs-site/content/en/
# Adds Hugo front matter if not present

set -e

STING_DOCS="../STING/docs"
DOCS_SITE_CONTENT="content/en/docs"
API_CONTENT="content/en/api"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}STING Documentation Sync Tool${NC}"
echo "================================"
echo ""

# Check if source directory exists
if [ ! -d "$STING_DOCS" ]; then
    echo -e "${YELLOW}Warning: STING docs directory not found at $STING_DOCS${NC}"
    exit 1
fi

# Function to add front matter if not present
add_front_matter() {
    local file="$1"
    local title="$2"
    local weight="${3:-10}"

    # Check if file already has front matter
    if head -n 1 "$file" | grep -q "^---$"; then
        echo -e "${GREEN}✓${NC} Front matter already present: $file"
        return
    fi

    # Create temporary file with front matter
    local temp_file=$(mktemp)

    cat > "$temp_file" <<EOF
---
title: "$title"
linkTitle: "$title"
weight: $weight
description: >
  Documentation for $title
---

EOF

    # Append original content
    cat "$file" >> "$temp_file"

    # Replace original file
    mv "$temp_file" "$file"

    echo -e "${GREEN}✓${NC} Added front matter: $file"
}

# Function to generate title from filename
generate_title() {
    local filename="$1"
    # Remove extension and convert underscores/hyphens to spaces
    # Capitalize first letter of each word
    echo "$filename" | sed 's/\.[^.]*$//' | sed 's/[_-]/ /g' | sed 's/\b\(.\)/\u\1/g'
}

# Sync guides
echo -e "${BLUE}Syncing Guides...${NC}"
if [ -d "$STING_DOCS/platform/guides" ]; then
    mkdir -p "$DOCS_SITE_CONTENT/guides"
    for file in "$STING_DOCS/platform/guides"/*.md; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            lowercase_filename=$(echo "$filename" | tr '[:upper:]' '[:lower:]' | tr '_' '-')
            dest="$DOCS_SITE_CONTENT/guides/$lowercase_filename"

            cp "$file" "$dest"
            title=$(generate_title "$filename")
            add_front_matter "$dest" "$title"
        fi
    done
fi

# Sync API docs
echo -e "${BLUE}Syncing API Documentation...${NC}"
if [ -d "$STING_DOCS/api" ]; then
    mkdir -p "$API_CONTENT"
    for file in "$STING_DOCS/api"/*.md; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            lowercase_filename=$(echo "$filename" | tr '[:upper:]' '[:lower:]' | tr '_' '-')
            dest="$API_CONTENT/$lowercase_filename"

            cp "$file" "$dest"
            title=$(generate_title "$filename")
            add_front_matter "$dest" "$title"
        fi
    done
fi

# Sync architecture docs
echo -e "${BLUE}Syncing Architecture Documentation...${NC}"
if [ -d "$STING_DOCS/platform/architecture" ]; then
    mkdir -p "$DOCS_SITE_CONTENT/architecture"
    for file in "$STING_DOCS/platform/architecture"/*.md; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            lowercase_filename=$(echo "$filename" | tr '[:upper:]' '[:lower:]' | tr '_' '-')
            dest="$DOCS_SITE_CONTENT/architecture/$lowercase_filename"

            cp "$file" "$dest"
            title=$(generate_title "$filename")
            add_front_matter "$dest" "$title"
        fi
    done
fi

# Sync security docs
echo -e "${BLUE}Syncing Security Documentation...${NC}"
if [ -d "$STING_DOCS/platform/security" ]; then
    mkdir -p "$DOCS_SITE_CONTENT/security"
    for file in "$STING_DOCS/platform/security"/*.md; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            lowercase_filename=$(echo "$filename" | tr '[:upper:]' '[:lower:]' | tr '_' '-')
            dest="$DOCS_SITE_CONTENT/security/$lowercase_filename"

            cp "$file" "$dest"
            title=$(generate_title "$filename")
            add_front_matter "$dest" "$title"
        fi
    done
fi

# Sync troubleshooting docs
echo -e "${BLUE}Syncing Troubleshooting Documentation...${NC}"
if [ -d "$STING_DOCS/platform/troubleshooting" ]; then
    mkdir -p "$DOCS_SITE_CONTENT/troubleshooting"
    for file in "$STING_DOCS/platform/troubleshooting"/*.md; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            lowercase_filename=$(echo "$filename" | tr '[:upper:]' '[:lower:]' | tr '_' '-')
            dest="$DOCS_SITE_CONTENT/troubleshooting/$lowercase_filename"

            cp "$file" "$dest"
            title=$(generate_title "$filename")
            add_front_matter "$dest" "$title"
        fi
    done
fi

# Sync features docs
echo -e "${BLUE}Syncing Features Documentation...${NC}"
if [ -d "$STING_DOCS/platform/features" ]; then
    mkdir -p "$DOCS_SITE_CONTENT/features"
    for file in "$STING_DOCS/platform/features"/*.md; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            lowercase_filename=$(echo "$filename" | tr '[:upper:]' '[:lower:]' | tr '_' '-')
            dest="$DOCS_SITE_CONTENT/features/$lowercase_filename"

            cp "$file" "$dest"
            title=$(generate_title "$filename")
            add_front_matter "$dest" "$title"
        fi
    done
fi

echo ""
echo -e "${GREEN}Documentation sync complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Review the synced files in content/en/"
echo "  2. Adjust front matter as needed (title, weight, description)"
echo "  3. Run 'hugo server' to preview the site"
echo "  4. Commit and push to deploy via GitHub Actions"
