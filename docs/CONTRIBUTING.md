# Contributing Guide

Thank you for your interest in contributing to Odoo Visual Emotion.

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a feature branch from `develop`

```bash
git clone https://github.com/YOUR_USERNAME/Odoo-Visual-Emotion.git
cd Odoo-Visual-Emotion
git checkout -b feature/your-feature develop
```

## Development Workflow

### Branch Strategy

| Branch | Purpose |
|--------|---------|
| `main` | Production-ready code |
| `develop` | Integration branch |
| `feature/*` | New features |
| `fix/*` | Bug fixes |
| `docs/*` | Documentation updates |

### Pull Request Process

1. Create PR targeting `develop` branch
2. CI automatically formats your code
3. Request review from maintainers
4. Address feedback if any
5. Squash merge after approval

## Code Standards

### Comments

- **Language**: English only
- **Length**: 3-5 words maximum
- **Style**: Concise and direct

```python
# Good
def calculate_price(self):
    base = self.product_id.lst_price  # Base product price
    
# Bad
def calculate_price(self):
    base = self.product_id.lst_price  # This gets the base price from the product
```

### Python (Odoo Addons)

| Rule | Value |
|------|-------|
| Formatter | Ruff |
| Line length | 88 characters |
| Import sorting | Automatic |

Follow Odoo naming conventions:
- Methods: `snake_case` or `mixedCase` for API methods
- Models: `module.model_name`
- Fields: `snake_case`

### YAML Files

| Rule | Value |
|------|-------|
| Formatter | yamlfmt |
| Indentation | 2 spaces |

### Nginx Configuration

| Rule | Value |
|------|-------|
| Formatter | nginxfmt |
| Indentation | 4 spaces |

## Commit Messages

Use conventional commits format:

```
<type>: <description>

[optional body]
```

### Types

| Prefix | Usage |
|--------|-------|
| `feat:` | New feature |
| `fix:` | Bug fix |
| `docs:` | Documentation only |
| `style:` | Formatting, no logic change |
| `refactor:` | Code restructure |
| `test:` | Adding tests |
| `chore:` | Maintenance tasks |

### Examples

```
feat: add subscription pause workflow
fix: resolve pricing calculation for video content
docs: update installation guide
style: format Python files with Ruff
chore: update Docker base images
```

## Running Formatters Locally

Before pushing, run formatters to avoid CI auto-commits:

```bash
# Python (Odoo addons)
ruff format addons
ruff check --fix addons

# YAML files
yamlfmt -w docker-compose.yaml .github/workflows/*.yaml

# Nginx configuration
nginxfmt -i 4 config/nginx.conf
```

## Testing Changes

### Local Docker Setup

```bash
# Start services
docker compose up -d

# View logs
docker compose logs -f odoo

# Restart after addon changes
docker compose restart odoo
```

### Odoo Module Updates

After modifying addon files:

1. Restart Odoo container
2. Enable developer mode in Odoo
3. Go to Apps → Update Apps List
4. Upgrade the module

## Reporting Issues

When opening an issue, include:

- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Environment details (OS, Docker version)

## Questions?

Open a discussion issue before making large changes. This helps ensure your contribution aligns with project goals.
