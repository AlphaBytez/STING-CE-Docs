<div align="center">
  <img src="static/images/sting-logo.webp" alt="STING Logo" width="300"/>
</div>

# STING Documentation Site

This is the official documentation site for STING, built with [Hugo](https://gohugo.io/) and the [Docsy](https://www.docsy.dev/) theme.

## Features

- **Powerful Search**: Full-text search across all documentation
- **Version Support**: Version dropdown for maintaining docs for multiple versions
- **Dark Mode**: Light/dark theme toggle
- **API Reference**: Dedicated section for API documentation with code examples
- **Responsive Design**: Mobile-friendly documentation
- **Fast Build Times**: Hugo generates static HTML for blazing-fast page loads

## Prerequisites

To build the documentation site locally, you need:

- **Hugo Extended**: v0.147.9 or later
  ```bash
  # macOS
  brew install hugo

  # Linux
  snap install hugo
  ```

- **Go**: v1.20 or later (required for Hugo Modules/Docsy theme)
  ```bash
  # macOS
  brew install go

  # Linux
  sudo apt install golang-go
  ```

## Quick Start

### 1. Clone the Repository

```bash
cd docs-site
```

### 2. Install Dependencies

Hugo will automatically download the Docsy theme and dependencies on first build:

```bash
hugo mod get -u
```

### 3. Run the Development Server

```bash
# Run with local baseURL override (fixes navigation)
hugo server -D --baseURL="http://localhost:1313/"
```

The site will be available at **http://localhost:1313/**

**Note**: The `--baseURL` flag is required for local development because `hugo.toml` has the production GitHub Pages URL. This override ensures all navigation links work correctly on localhost.

## Content Organization

The documentation is organized into the following sections:

```
content/en/
├── _index.md                # Homepage
├── about/                   # About STING
├── api/                     # API Reference
│   ├── api-reference.md           # Complete API reference
│   ├── honey-jar-bulk-api.md      # Honey Jar bulk operations
│   ├── pii-detection-api.md       # PII detection endpoints
│   └── public-bee-api.md          # Public Bee API
└── docs/                    # Main documentation
    ├── getting-started/     # Installation and setup
    ├── guides/              # Step-by-step tutorials
    ├── architecture/        # System architecture
    ├── features/            # Feature documentation
    ├── security/            # Security guides
    ├── deployment/          # Deployment guides
    ├── platform/            # Platform-specific docs
    ├── troubleshooting/     # Troubleshooting guides
    └── development/         # Development guides
```

## Syncing Documentation

To sync documentation from the main STING repository:

```bash
./sync-docs.sh
```

This script:
- Copies markdown files from `STING/docs` to `docs-site/content/en/`
- Adds Hugo front matter if not present
- Organizes content by category

## Adding New Documentation

### 1. Create a New Page

```bash
hugo new content/en/docs/guides/my-new-guide.md
```

### 2. Add Front Matter

Every page should have Hugo front matter:

```yaml
---
title: "Page Title"
linkTitle: "Short Title"
weight: 10
description: >
  Brief description of the page content
---
```

### 3. Write Content

Use standard Markdown with Hugo shortcodes for enhanced functionality:

```markdown
# My Page Title

Content goes here...

## Code Examples

\`\`\`bash
./manage_sting.sh start
\`\`\`

## Important Notes

{{< alert title="Note" >}}
This is an important callout.
{{< /alert >}}
```

## Building for Production

### Local Build

```bash
hugo --gc --minify
```

The site will be built to the `public/` directory.

### GitHub Pages Deployment

The site is automatically deployed to GitHub Pages on every push to `main` via GitHub Actions.

#### Setup GitHub Pages

1. Go to repository **Settings** → **Pages**
2. Set **Source** to "GitHub Actions"
3. Push to `main` branch - the workflow will automatically deploy

The GitHub Actions workflow is defined in `.github/workflows/hugo.yml`.

## Configuration

Main configuration is in `hugo.toml`. Key settings:

```toml
baseURL = "https://AlphaBytez.github.io/STING-CE-Docs/"
title = "STING Documentation"

# Enable search
[params]
  offlineSearch = true

# Version dropdown
[[params.versions]]
  version = "v1.0 (latest)"
  url = "https://AlphaBytez.github.io/STING-CE-Docs/"
```

## Search

Search is enabled via offline/local search (Lunr.js). The search index is automatically generated during build.

To use Algolia DocSearch instead:

1. Get Algolia DocSearch API keys
2. Update `hugo.toml`:
   ```toml
   [params.search.algolia]
     appId = "YOUR_APP_ID"
     apiKey = "YOUR_SEARCH_KEY"
     indexName = "sting-docs"
   ```

## Versioning

To add a new version:

1. Update `hugo.toml`:
   ```toml
   [[params.versions]]
     version = "v2.0"
     url = "https://AlphaBytez.github.io/sting-docs/v2.0/"
   ```

2. Create version-specific content in `content/en/v2.0/`

## Troubleshooting

### Build Errors

**"Module not found"**
```bash
hugo mod get -u
hugo mod tidy
```

**"Go not found"**
```bash
# Install Go (required for Docsy theme)
brew install go  # macOS
```

### Preview Issues

**Site not loading at localhost**
- Check that Hugo server is running
- Use `--baseURL="http://localhost:1313/"` flag to override production URL

**Changes not appearing**
```bash
# Clear Hugo cache
hugo --gc
```

## Contributing

To contribute documentation:

1. Fork the repository
2. Create a new branch
3. Add/edit documentation
4. Test locally with `hugo server`
5. Submit a pull request

## Resources

- [Hugo Documentation](https://gohugo.io/documentation/)
- [Docsy Theme Docs](https://www.docsy.dev/docs/)
- [Markdown Guide](https://www.markdownguide.org/)
- [Hugo Shortcodes](https://gohugo.io/content-management/shortcodes/)

## Credits

This documentation site was built with the assistance of:

- **Claude Code** by Anthropic - AI-powered development assistant that helped with:
  - Documentation structure and organization
  - Grammar and punctuation review across 125+ files
  - Visual theme customization and debugging
  - GitHub Actions workflow configuration
  - Quality assurance and redundancy analysis

Special thanks to the open-source community and the tools that made this possible:
- Hugo static site generator
- Docsy documentation theme
- GitHub Pages for hosting

## License

This documentation is licensed under the Apache License 2.0, the same as the STING project.

## Contact

- **General inquiries**: olliec@alphabytez.dev
- **Documentation issues**: [Open an issue](https://github.com/AlphaBytez/STING-CE-Docs/issues)
- **Main STING repo**: https://github.com/AlphaBytez/STING-CE-Public
