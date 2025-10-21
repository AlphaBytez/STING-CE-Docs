# STING-CE-Docs Repository Split Guide

## Overview

This guide walks you through splitting the STING-CE-Docs repository into:
- **STING-CE-Docs-Internal** (Private) - Contains all documentation including internal/planning docs
- **STING-CE-Docs** (Public) - Clean public documentation only

## Files to be Removed from Public Repo

### High Confidence Internal (7 files)
- `docs/features/chatbot-implementation-progress.md` - Implementation tracking
- `docs/features/report-system-implementation.md` - Feature roadmap
- `docs/features/bee-agentic-capabilities.md` - Planned capabilities
- `docs/features/bee-swarm-networking.md` - Enterprise+ feature
- `docs/features/bee-dances-enterprise.md` - Enterprise feature
- `docs/architecture/honeycomb-vault-architecture.md` - Unreleased feature
- `docs/architecture/sting-chatbot-integration.md` - Planning document

### Medium Confidence Internal (3 files)
- `docs/architecture/worker-bee-connector-framework.md` - Enterprise features
- `docs/architecture/native-dashboard-integration.md` - Advanced features
- `docs/features/beeacon-log-monitoring.md` - Enterprise features

### Draft/Uncertain (7 files)
- `docs/troubleshooting/email-verification-status.md` - Draft
- `docs/troubleshooting/installation-reliability-fix.md` - Draft
- `docs/troubleshooting/restart-reliability-fix.md` - Draft
- `docs/troubleshooting/login-ui-fixes-summary.md` - Draft
- `docs/security/hybrid-passwordless-aal2-solution.md` - Draft
- `docs/authentication/auth-testing-guide.md` - Draft
- `docs/bee-features/bee-implementation-guide.md` - Draft

**Total: 17 files to remove**

## Step-by-Step Execution Plan

### Phase 1: Prepare Internal Repository (Original)

```bash
# 1. Current directory becomes INTERNAL repo
cd /mnt/c/DevWorld/STING-CE-Docs

# 2. Commit any pending changes
git add -A
git commit -m "Final state before split - internal docs"

# 3. Create new private repo on GitHub
# Go to GitHub → Create new repository → "STING-CE-Docs-Internal"
# Make it PRIVATE
# Do NOT initialize with README

# 4. Update remote to point to internal repo
git remote rename origin origin-old
git remote add origin https://github.com/AlphaBytez/STING-CE-Docs-Internal.git

# 5. Push everything to internal repo
git push -u origin main

# 6. Verify on GitHub that all files are there
```

### Phase 2: Create Clean Public Repository

```bash
# 1. Create a copy for public repo
cd /mnt/c/DevWorld/
cp -r STING-CE-Docs STING-CE-Docs-Public
cd STING-CE-Docs-Public

# 2. Make scripts executable
chmod +x cleanup-for-public.sh
chmod +x cleanup-git-history.sh

# 3. Run the cleanup script
bash cleanup-for-public.sh
# Follow prompts, confirm you're in a COPY

# 4. Review what was removed
cat cleanup-log.txt
cat removed-internal-docs-backup/ -R | less

# 5. Test the site
hugo server
# Visit http://localhost:1313/STING-CE-Docs/
# Verify internal docs are gone
# Verify site still works

# 6. Commit the cleanup
git add -A
git commit -m "Remove internal documentation for public release"

# 7. Clean git history (DESTRUCTIVE!)
bash cleanup-git-history.sh
# Type "DELETE HISTORY" to confirm

# 8. Create new PUBLIC repo on GitHub
# Go to GitHub → Create new repository → "STING-CE-Docs"
# Make it PUBLIC
# Do NOT initialize with README

# 9. Set remote to new public repo
git remote remove origin
git remote add origin https://github.com/AlphaBytez/STING-CE-Docs.git

# 10. Force push to new public repo
git push -u origin main --force

# 11. Enable GitHub Pages
# GitHub repo → Settings → Pages
# Source: Deploy from branch "main"
# Directory: / (root)
```

### Phase 3: Verification

```bash
# 1. Verify internal files are gone from history
cd /mnt/c/DevWorld/STING-CE-Docs-Public
git log --all -- content/en/docs/features/chatbot-implementation-progress.md
# Should show: no commits

# 2. Verify site builds
hugo
# Should complete without errors

# 3. Check file count
find content/en -name "*.md" | wc -l
# Should be ~101 files (was ~118)

# 4. Search for sensitive keywords
grep -r "implementation progress" content/ || echo "Clean!"
grep -r "Enterprise+" content/ || echo "Clean!"
grep -r "planned SDK" content/ || echo "Clean!"
grep -r "coming soon" content/ || echo "Clean!"

# 5. Verify backups exist
ls -la removed-internal-docs-backup/
# Should contain all 17 removed files
```

### Phase 4: Ongoing Maintenance

#### For Internal Documentation (Private Repo)
```bash
cd /mnt/c/DevWorld/STING-CE-Docs

# Regular development work here
# Push planning docs, enterprise features, etc.
git push origin main
```

#### For Public Documentation (Public Repo)
```bash
cd /mnt/c/DevWorld/STING-CE-Docs-Public

# Only push released features
# Remove any "planned" or "coming soon" language
git push origin main

# Syncing released features from internal to public:
# 1. Copy specific files from internal repo
# 2. Remove any internal notes/TODOs
# 3. Commit and push
```

## Safety Checklist

Before making public repository public:

- [ ] All 17 internal files removed
- [ ] Git history cleaned (no traces of internal files)
- [ ] "Planned" SDK references removed from API docs
- [ ] "Coming soon" references removed
- [ ] Enterprise+ features removed
- [ ] Draft implementation guides removed
- [ ] Site builds successfully with Hugo
- [ ] All links work (no broken references to removed files)
- [ ] README updated for public audience
- [ ] License appropriate for public release
- [ ] No sensitive API keys, tokens, or credentials in history
- [ ] No internal email addresses or slack references
- [ ] GitHub Actions workflow appropriate for public

## Rollback Plan

If something goes wrong:

```bash
# In public repo copy
git checkout backup-before-history-cleanup-<timestamp>

# Or start over from internal repo
cd /mnt/c/DevWorld/
rm -rf STING-CE-Docs-Public
cp -r STING-CE-Docs STING-CE-Docs-Public
```

## File Structure After Split

### Internal Repo (Private)
```
STING-CE-Docs-Internal/
├── content/en/
│   ├── docs/
│   │   ├── features/ (ALL features including planned)
│   │   ├── architecture/ (ALL architecture docs)
│   │   ├── troubleshooting/ (ALL including drafts)
│   │   └── ... (everything)
│   ├── api/ (including planned SDKs)
│   └── about/
└── ... (all files preserved)
```

### Public Repo (Public)
```
STING-CE-Docs/
├── content/en/
│   ├── docs/
│   │   ├── features/ (only released CE features)
│   │   ├── architecture/ (general architecture only)
│   │   ├── troubleshooting/ (published guides only)
│   │   └── ... (public docs)
│   ├── api/ (released APIs only)
│   └── about/
└── ... (cleaned history)
```

## Post-Split Workflow

### When a Feature is Released

1. **In Internal Repo**: Document feature fully with all details
2. **Review**: Decide what's public-appropriate
3. **Copy to Public**: Copy file to public repo
4. **Clean**: Remove internal notes, enterprise features, roadmap items
5. **Commit**: Push to public repo

### Managing Enterprise Features

- Keep in internal repo only
- Add "Enterprise" or "Enterprise+" label in docs
- Include pricing/licensing info internally
- Public docs can mention feature exists but link to sales

## Support & Questions

- Internal docs questions: Use internal Slack/email
- Public docs questions: Use GitHub Issues on public repo
- Uncertain about classification: Default to INTERNAL (safer)

---

**Created**: 2025-10-20
**Last Updated**: 2025-10-20
**Maintained by**: AlphaBytez
