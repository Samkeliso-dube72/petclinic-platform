---
name: terraform-module-authoring
description: Create or update Terraform modules and environment stacks in petclinic-platform. Use when the task involves adding AWS infrastructure, wiring reusable modules under terraform/modules, or connecting dev and prod root stacks under terraform/environments.
---

# Terraform Module Authoring

Use this skill when authoring Terraform code for Spring Petclinic Microservices infrastructure.

## When to Use

- Adding new AWS resources (VPC, EKS, RDS, ECR, security groups, IAM roles, etc.)
- Creating or updating reusable modules in `terraform/modules`
- Connecting modules in root stacks under `terraform/environments/{dev,prod}`
- Refactoring existing infrastructure while preserving behavior

## Scope

- **In scope:** AWS infrastructure in eu-central-1, Kubernetes-related AWS resources, supporting 8 services
- **Out of scope:** Application code, Kubernetes manifests (use Helm/K8s), container image builds, Spring Petclinic app repo

## Before You Start

1. **Read the spec:** Check `docs/technical-spec.md` for infrastructure dimensions (VPC CIDR, subnet CIDRs, instance sizes, resource quotas)
2. **Understand service dependencies:** Services need specific startup order (config-server → discovery-server → others) and MySQL backing (customers-service, visits-service, vets-service)
3. **Know your layout:** Reusable code → `terraform/modules/`, environment entry points → `terraform/environments/{dev,prod}/`

## Module Structure

```
terraform/modules/{module-name}/
├── main.tf              # Resource definitions
├── variables.tf         # Input variables with descriptions and types
├── outputs.tf          # Exported values for downstream modules
└── versions.tf         # Provider constraints (AWS ~> 5.0, Kubernetes ~> 2.0)
```

Keep modules small and single-purpose. Environment-specific logic goes in root stacks, not modules.

## Required Conventions

### Naming
- Resource names: `petclinic-{env}-{resource}` (e.g., `petclinic-dev-vpc`, `petclinic-prod-eks`)
- Use `var.environment` and `var.project` consistently across all modules

### Tagging
Every supported resource must have tags:
```hcl
tags = {
  Project     = "petclinic"
  Environment = var.environment
  ManagedBy   = "terraform"
}
```

### Variables & Outputs
- Every variable must have a `description` and `type`
- Export only outputs needed downstream; don't expose internal plumbing
- Mark outputs with secret data using `sensitive = true`
- Prefer variable defaults for non-sensitive common values

### Security
- No hardcoded secrets, credentials, API keys, or sensitive defaults
- Use AWS Secrets Manager for runtime secrets; never store in Terraform state
- No public S3 buckets; all buckets block public access
- No open security groups (0.0.0.0/0 except ALB on 80/443)
- All databases encrypted at rest; all buckets use SSE; all EBS encrypted
- IAM: specific actions on specific resources, never `*/*` or `arn:aws:*`

### Validation
- Format: recommend `terraform fmt -recursive` before commit
- Validate: recommend `terraform validate` after edits
- Test: recommend `terraform plan -out plan.out` to review changes locally

## Do Not Guess

❌ CIDRs, subnet ranges, port numbers  
❌ AWS account IDs or ARNs  
❌ Route53 hosted zones or DNS names  
❌ Secrets or credentials  

**If a value is missing:** Leave a clear TODO comment or use a variable instead of inventing.

## Workflow

1. **Design:** Decide whether the change is a new module or an update to existing code
2. **Author:** Write `.tf` files following the structure above
3. **Format:** Run `terraform fmt -recursive` from repo root
4. **Validate:** Run `terraform validate` from the affected environment directory
5. **Test:** Run `terraform plan` to review changes
6. **Commit:** Small, reviewable change set with clear commit message
7. **Review:** Have the `terraform-review` skill audit the code

Do not execute `terraform init`, `terraform validate`, `terraform plan`, `terraform apply`, or `terraform destroy` automatically. Use these commands as reference unless the user explicitly requests execution.

### Example Command Sequence
```bash
# Update a module
cd terraform/modules/vpc
# ... edit main.tf, variables.tf, outputs.tf ...
terraform fmt -recursive
cd /path/to/repo/terraform/environments/dev
terraform validate
terraform plan -out plan.out
# Review plan.out, then commit
```

## Quality Checklist

- [ ] Code is ready to be formatted with `terraform fmt`
- [ ] Code is ready to validate with `terraform validate`
- [ ] All resources tagged with Project, Environment, ManagedBy
- [ ] Resource names follow `petclinic-{env}-{resource}` pattern
- [ ] All variables have descriptions and types
- [ ] All sensitive outputs use `sensitive = true`
- [ ] No guessed values; all dimensions from `docs/technical-spec.md`
- [ ] No hardcoded secrets or credentials
- [ ] Module is reusable; environment logic in root stacks only
- [ ] Commit message explains the why, not the what
