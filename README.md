# Odoo Visual Emotion

Production-ready Odoo 18 deployment with custom advertising subscription management module for shopping centers.

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Makefile Commands](#makefile-commands)
- [CI/CD Pipeline](#cicd-pipeline)
- [Contributors](#contributors)
- [Documentation](#documentation)
- [License](#license)

## Features

- **Subscription Management**: Full lifecycle (draft → active → expired)
- **Dynamic Pricing Engine**: Base price + prestige surcharges by location
- **Multi-location Support**: 5 shopping centers with configurable rates
- **Art Approval Workflow**: Pending → Received → Approved states
- **Payment Flexibility**: Cash, advance + balance, or installments
- **Automated Invoicing**: Integration with Odoo Accounting

## Project Structure

```
├── addons/
│   └── publicidad_emocion_visual/    # Custom advertising module
│       ├── models/                   # Business logic
│       ├── views/                    # UI definitions
│       ├── security/                 # Access control
│       └── data/                     # Default data
├── config/
│   ├── nginx.conf                    # Reverse proxy config
│   └── odoo.conf                     # Odoo server config
├── docs/
│   ├── ARCHITECTURE.md               # System architecture
│   ├── CHANGELOG.md                  # Version history
│   ├── CONTRIBUTING.md               # Contribution guide
│   └── DEVELOPMENT.md                # Developer setup
├── .github/workflows/
│   ├── deploy.yaml                   # CD: Deploy to VPS
│   └── quality-checks.yaml           # CI: Auto-format PRs
├── docker-compose.yaml               # Container orchestration
├── Makefile                          # Remote management commands
└── pyproject.toml                    # Python tooling config
```

## Requirements

- Docker >= 20.10
- Docker Compose >= 2.0
- Git
- (Optional) Make

## Quick Start

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-org/Odoo-Visual-Emotion.git
   cd Odoo-Visual-Emotion
   ```

2. **Configure environment**

   ```bash
   cp .env.example .env
   # Edit .env with your values
   ```

3. **Start services**

   ```bash
   docker compose up -d
   ```

4. **Access Odoo**

   Open `http://localhost` (redirects to HTTPS if SSL configured)

## Configuration

### Environment Variables (.env)

| Variable | Description | Example |
|----------|-------------|---------|
| `DB_NAME` | PostgreSQL database | `postgres` |
| `DB_USER` | Database user | `odoo` |
| `DB_PASSWORD` | Database password | `strong_password` |
| `DOMAIN` | Public domain | `odoo.example.com` |
| `SSL_CERT_PATH` | SSL certificate path | `/path/to/fullchain.pem` |
| `SSL_KEY_PATH` | SSL private key path | `/path/to/privkey.pem` |

### Odoo Configuration

Server settings are defined in `config/odoo.conf`:

- Workers: 2 (adjust based on server resources)
- Proxy mode: Enabled (required behind Nginx)
- Log level: info

## Makefile Commands

| Command | Description |
|---------|-------------|
| `make ssh` | Connect to VPS via SSH |
| `make up` | Start containers on VPS |
| `make rest` | Restart containers on VPS |
| `make logs` | View Odoo logs (follow mode) |
| `make status` | Check container status |

## CI/CD Pipeline

### Pull Requests → `quality-checks.yaml`

- Auto-formats YAML, Nginx, and Python files
- Commits formatting changes back to PR
- Runs on PRs to `main` and `develop`

### Push to main → `deploy.yaml`

- Deploys to VPS via SSH
- Restarts Docker containers
- Syncs `main` → `develop` after successful deploy

## Contributors

This project was built by a team of 6 people:

| Role | Count | Responsibilities |
|------|-------|------------------|
| Product Owner | 1 | Project vision, requirements, feature prioritization |
| Developers | 4 | Odoo addon development, business logic, UI/UX |
| DevOps Engineer | 1 | Infrastructure, CI/CD, deployment, server config |

See [CODEOWNERS](.github/CODEOWNERS) for code review assignments.

## Documentation

| Document | Description |
|----------|-------------|
| [Architecture](docs/ARCHITECTURE.md) | System design and diagrams |
| [Changelog](docs/CHANGELOG.md) | Version history |
| [Contributing](docs/CONTRIBUTING.md) | How to contribute |
| [Development](docs/DEVELOPMENT.md) | Local development setup |

## License

LGPL-3.0 - See [LICENSE](LICENSE) for details.
