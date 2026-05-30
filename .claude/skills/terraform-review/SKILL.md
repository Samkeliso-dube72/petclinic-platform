---
name: terraform-review
description: Review Terraform changes in petclinic-platform for safety, correctness, maintainability, and alignment with repository conventions. Use when auditing modules, environment stacks, or AWS infrastructure changes before merge.
---

# Terraform Review

Use this skill when reviewing Terraform changes for correctness, safety, and alignment before merge.

## When to Use

- Auditing module changes or environment stack updates
- Reviewing pull requests with Terraform code changes
- Pre-merge validation of AWS infrastructure changes
- Ensuring code follows `petclinic-platform` conventions and security rules

## Review Priorities

1. **Security first** — secrets, broad access, open networks, missing encryption
2. **Correctness second** — guessed values, broken dependencies, missing outputs
3. **Maintainability third** — module boundaries, naming, clarity, complexity
4. **Alignment last** — convention violations, spec misalignment, validation hygiene

## Security Checklist

- [ ] No hardcoded secrets, API keys, credentials, or sensitive defaults
- [ ] All sensitive outputs use `sensitive = true`
- [ ] No S3 buckets allow public access (block public access enabled)
- [ ] No security groups allow 0.0.0.0/0 ingress except ALB on 80/443
- [ ] All databases encrypted at rest; all buckets use SSE; all EBS encrypted
- [ ] IAM policies follow least privilege: specific actions on specific resources, no `*/*` wildcards
- [ ] AWS Secrets Manager used for runtime secrets, not Terraform state
- [ ] No `.tfvars` or `.env` files committed

## Correctness Checklist

- [ ] No guessed values: CIDRs, ARNs, hosted zones, account IDs, DNS names come from `docs/technical-spec.md`
- [ ] All required outputs exported; downstream modules have what they need
- [ ] Resource dependencies correct (explicit or implicit via references)
- [ ] Module structure matches conventions: reusable in `modules/`, root in `environments/`
- [ ] Provider versions pinned in `versions.tf` (AWS ~> 5.0, Kubernetes ~> 2.0)
- [ ] AWS region consistently us-east-1
- [ ] All resources tagged: `Project=petclinic`, `Environment={dev|prod}`, `ManagedBy=terraform`

## Maintainability Checklist

- [ ] Naming follows pattern: `petclinic-{env}-{resource}`
- [ ] Variables have descriptions and appropriate types/defaults
- [ ] Code formatted with `terraform fmt`
- [ ] Code validates with `terraform validate`
- [ ] No dead code, unused variables, or output spill
- [ ] Modules are reusable; environment-specific logic stays in root stacks
- [ ] Outputs expose only downstream requirements, not internal plumbing

## Alignment Checklist

- [ ] Follows directory structure: `terraform/modules/` for reusable, `terraform/environments/{dev,prod}/` for roots
- [ ] Follows sizing from `docs/technical-spec.md`: instance types, quotas, RDS config, EKS nodes
- [ ] Follows 8-service model: config-server, discovery-server, api-gateway, admin-server, customers-service, visits-service, vets-service, genai-service
- [ ] MySQL correctly backing customers, visits, vets services
- [ ] Respects startup order: config-server and discovery-server must start first

## Petclinic Context

- **Platform repo only:** This repo owns infrastructure; application repo is read-only unless explicitly included
- **Service startup:** config-server first, discovery-server second, then remaining services
- **Database backing:** customers-service, visits-service, vets-service need MySQL; others do not
- **Regional:** All resources in us-east-1
- **Environments:** dev (auto-sync), prod (manual sync); both use single-AZ db.t4g.micro (free tier)

## Findings Rules

1. **Flag guessed values** — any CIDR, ARN, hosted zone, account ID, or DNS name not from spec
2. **Flag broad access** — any IAM `*` actions, `*` resources, or 0.0.0.0/0 access (except documented exceptions)
3. **Flag missing pieces** — missing tags, missing outputs, missing validation, missing security controls
4. **Flag module misuse** — inline resources in root modules, poor separation of concerns, copy-paste logic
5. **Flag validation gaps** — if `terraform fmt` or `terraform validate` not run
6. **No Terraform execution by default** — do not run `terraform init`, `terraform validate`, `terraform plan`, `terraform apply`, or `terraform destroy` unless the user explicitly requests execution

## Output Format

**Lead with findings first.** For each finding:

```
### [Severity] [Category] — [File/Resource]

[Finding description]

- **Current:** [code snippet showing the issue]
- **Issue:** [why this is a problem]
- **Suggested fix:** [concrete action or reference to standard]
```

**Severity levels:** Critical (security/destructive), High (correctness), Medium (maintainability), Low (style)

**If no findings:**

```
✓ No material issues found in [file/scope]
```

**Summary:** Always end with a line summarizing total issues by severity or "no issues."
