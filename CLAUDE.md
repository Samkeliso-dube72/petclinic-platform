# Petclinic Platform - Claude Code Instructions

## Project

`petclinic-platform` is the infrastructure and deployment repository for Spring Petclinic Microservices.
It owns Terraform, Kubernetes, Helm, platform documentation, scripts, and Claude configuration for this project.

The application repository is `spring-petclinic-microservices`.
Treat the application repository as read-only from this repository unless explicitly instructed otherwise.

## Current Repository Layout

| Path | Purpose |
|---|---|
| `terraform/environments/{dev,prod}` | Environment root stacks |
| `terraform/modules` | Reusable infrastructure modules |
| `helm/petclinic-service` | Shared Helm chart |
| `helm-values` | Environment and service values |
| `k8s/base` | Common Kubernetes manifests |
| `k8s/overlays/{dev,prod}` | Environment-specific Kubernetes overlays |
| `.github/workflows` | CI workflow definitions |
| `scripts` | Operational helper scripts |
| `docs` | ADRs, runbooks, and supporting documentation |
| `.claude` | Claude agents, skills, hooks, and rules |

Only describe what actually exists in the repository. Do not describe planned infrastructure as if it is already implemented.

## Core Conventions

### Terraform

- Keep reusable infrastructure code in `terraform/modules`.
- Keep environment entry points in `terraform/environments/{dev,prod}`.
- Follow the naming format `petclinic-{env}-{resource}` where applicable.
- Use `main.tf`, `variables.tf`, `outputs.tf`, and `versions.tf` consistently where appropriate.
- Never hardcode secrets, credentials, or unknown environment-specific values.
- Use `sensitive = true` for sensitive outputs.
- Run `terraform fmt`, `terraform validate`, and `terraform plan` before apply when Terraform execution is explicitly requested.

Required tags:

```hcl
tags = {
  Project     = "petclinic"
  Environment = var.environment
  ManagedBy   = "terraform"
}
```

### Kubernetes and Helm

- Use `petclinic-dev` and `petclinic-prod` namespaces.
- Keep secrets out of committed YAML and values files.
- Use Helm for service deployment assets.
- Use verified application health endpoints from the application repository.
- Use commit-based image tags, not `latest`.

### Delivery Workflow

- Build `dev` first.
- Add `prod` only after the `dev` design is proven.
- Keep CI and CD responsibilities separate.
- Keep infrastructure changes small, reviewable, and scoped.

## Guardrails

- Do not modify the application repository unless explicitly asked.
- Do not invent unknown values such as CIDRs, account IDs, ARNs, hosted zones, passwords, or DNS names.
- Do not hardcode secrets or credentials.
- Do not run destructive actions without explicit user intent.
- Do not describe unfinished infrastructure as already complete.

## Current State

This repository is scaffolded and is being built incrementally.
Treat it as a platform skeleton until real infrastructure modules, manifests, and workflows are implemented.
