# Changelog

All notable changes to this project will be documented in this file.

## [1.0.2] - 2026-02-03

### Fixed
- Fixed nginxfmt command syntax error (`-s` flag removed, corrected parameter order).
- Fixed yamlfmt configuration to target specific files and preserve YAML structure.

### Added
- Ruff linter and formatter for Python custom addons.
- pyproject.toml with Odoo-compatible Ruff configuration.
- Python linting job in CI pipeline for custom addons.

## [1.0.1] - 2026-02-02

### Added
- Comprehensive GitHub Actions pipeline (`quality-checks.yaml`).
- Automated code formatting for YAML and Nginx configuration.
- Branch synchronization workflow (`main` -> `develop`).
- Project-wide English documentation standards.

### Fixed
- Nginx infinite redirect loop on port 80/443.
- Docker Compose service dependencies and healthcheck timing.
- Environment variable fallbacks in `docker-compose.yaml`.
- Connection host variable in `Makefile`.

### Changed
- Flattened configuration directory structure.
- Updated `.env.example` with comprehensive deployment variables.
- Standardized all comments to concise English (3-5 words).
- Replaced generic VPS connection test with actual CI validation.
