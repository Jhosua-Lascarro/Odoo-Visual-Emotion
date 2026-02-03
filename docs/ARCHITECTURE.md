# Architecture

## Overview

Odoo Visual Emotion uses a three-tier containerized architecture deployed via Docker Compose.

```
┌─────────────────────────────────────────────────────────────┐
│                      Docker Network                         │
│                                                             │
│  ┌──────────┐    ┌──────────┐    ┌──────────────────────┐  │
│  │  Nginx   │───▶│   Odoo   │───▶│     PostgreSQL       │  │
│  │  :80/443 │    │  :8069   │    │       :5432          │  │
│  │          │    │  :8072   │    │                      │  │
│  └──────────┘    └──────────┘    └──────────────────────┘  │
│       ▲                                                     │
└───────│─────────────────────────────────────────────────────┘
        │
    Clients (HTTPS)
```

## Services

### database (PostgreSQL 16)

| Property | Value |
|----------|-------|
| Image | `postgres:16` |
| Port | 5432 (internal) |
| Healthcheck | `pg_isready` |
| Volume | `database_data` |

Stores all Odoo data including users, products, and subscriptions.

### odoo (Odoo 18.0)

| Property | Value |
|----------|-------|
| Image | `odoo:18.0` |
| Ports | 8069 (web), 8072 (longpolling) |
| Depends on | database (healthy) |
| Volume | `odoo_data` |

Application server running the ERP with custom addons mounted at `/mnt/extra-addons`.

### nginx (Alpine)

| Property | Value |
|----------|-------|
| Image | `nginx:alpine` |
| Ports | 80, 443 (exposed) |
| Depends on | odoo (healthy) |

Reverse proxy handling SSL termination and static file caching.

## Network Flow

```
1. Client Request
   └── :443 (HTTPS) ──▶ Nginx

2. Application Traffic
   └── Nginx ──▶ :8069 ──▶ Odoo Backend

3. Real-time Updates (Longpolling)
   └── Nginx ──▶ :8072 ──▶ Odoo Chat

4. Database Queries
   └── Odoo ──▶ :5432 ──▶ PostgreSQL
```

## Volumes

| Volume | Purpose | Container Path |
|--------|---------|----------------|
| `database_data` | PostgreSQL persistence | `/var/lib/postgresql/data` |
| `odoo_data` | Filestore and sessions | `/var/lib/odoo` |

## Configuration Files

| File | Purpose |
|------|---------|
| `config/odoo.conf` | Odoo server settings (workers, ports, logging) |
| `config/nginx.conf` | Reverse proxy rules, SSL, caching |
| `.env` | Environment variables for all services |

## Custom Addon: publicidad_emocion_visual

### Purpose

Manages advertising subscriptions for digital billboards in shopping centers.

### Models

| Model | Description |
|-------|-------------|
| `publicidad.suscripcion` | Advertising subscriptions with pricing and workflow |
| `contrato.marco` | Master contracts grouping multiple subscriptions |
| `product.template` (ext) | Extended with advertising asset attributes |
| `account.move` (ext) | Invoice extensions for subscription billing |

### Dependencies

```
base ─┬─ product
      ├─ account
      ├─ sale
      └─ mail
```

### Security Groups

| Group | Access Level |
|-------|--------------|
| `group_publicidad_user` | View and create subscriptions |
| `group_publicidad_operaciones` | Manage art approval and activation |
| `group_publicidad_finanzas` | Payment validation and invoicing |

## Deployment Flow

```
Developer                    GitHub                         VPS
    │                           │                            │
    ├── Push to develop ───────▶│                            │
    │                           │                            │
    ├── Create PR ─────────────▶│                            │
    │                           ├── quality-checks.yaml      │
    │                           │   (auto-format)            │
    │                           │                            │
    ├── Merge to main ─────────▶│                            │
    │                           ├── deploy.yaml ────────────▶│
    │                           │                            ├── git pull
    │                           │                            ├── docker compose up
    │                           │                            │
    │                           ├── sync main → develop      │
    │                           │                            │
```
