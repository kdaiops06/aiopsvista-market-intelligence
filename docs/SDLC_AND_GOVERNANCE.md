# SDLC and Governance

## Document Purpose
This document defines the software delivery lifecycle, GitHub governance model, security controls, release strategy, branch protection baseline, CI/CD standards, and GitHub Actions policy framework for the AiOpsVista Market Intelligence Platform.

The standards in this document are production-oriented and intended for platform engineering, SRE, and security teams.

---

## SDLC Philosophy
Delivery and operations decisions must align with the following principles:

- Security First
- Reliability First
- Infrastructure as Code
- GitOps Principles
- Continuous Validation
- Continuous Documentation

Implementation guidance:

- Treat security and reliability requirements as release blockers, not post-release activities.
- Define infrastructure, platform policies, and operational controls as versioned code.
- Keep deployment intent declarative and reviewable.
- Validate every change continuously through automated checks.
- Ensure architecture, runbooks, and standards evolve with implementation changes.

---

## Branching Strategy
### Protected Branches
Current:

- main

Future:

- release/*
- hotfix/*

### Feature Branch Pattern
Pattern:

- feature/<scope>-<description>

Examples:

- feature/private-gke
- feature/shared-vpc
- feature/langfuse-observability

Policy:

- Direct commits to main are prohibited.
- All changes must flow through pull requests.
- Feature branches should be short-lived and rebased/updated frequently.

---

## Branch Protection Rules
### Main Branch Requirements
- Pull Request Required
- At least 1 approval
- All status checks passing
- No force push
- No branch deletion
- Require conversation resolution
- Require signed commits (future)
- Require code owner review (future)

### Recommended GitHub Branch Protection Settings
For branch: main

- Require a pull request before merging: enabled
- Require approvals: minimum 1
- Dismiss stale pull request approvals when new commits are pushed: enabled
- Require review from Code Owners: future enabled
- Require status checks to pass before merging: enabled
- Require branches to be up to date before merging: enabled
- Require conversation resolution before merging: enabled
- Require signed commits: future enabled
- Require linear history: recommended enabled
- Allow force pushes: disabled
- Allow deletions: disabled
- Restrict who can push: enabled (maintainers/admins only)

---

## Pull Request Workflow
### Required Sections
Every PR must include:

- Objective
- Scope
- Architecture Impact
- Reliability Impact
- Security Impact
- Validation Performed
- Rollback Plan
- Definition of Done

### PR Size Guidelines
- Small: focused change set, low risk, fast review
- Medium: multi-file but cohesive change with moderate risk
- Large: broad or cross-cutting changes, high review burden

Guidance:

- Encourage small PRs for faster reviews and lower integration risk.
- Split large changes into sequenced, independently reviewable PRs.

---

## GitHub Actions Standards
### Target Workflows
- terraform-validate
- terraform-plan
- terraform-security-scan
- terraform-apply
- docker-build
- container-security-scan
- helm-validation
- documentation-validation
- markdown-lint
- release

### Standards and Controls
- Prefer reusable workflows for common patterns across services.
- Use composite actions when a repeated step-set is shared and stable.
- Require environment approvals for stage/prod deployment jobs.
- Use secretless authentication with GitHub OIDC + Workload Identity Federation.
- Enforce workflow-level permissions with least privilege.
- Pin third-party actions to immutable versions/SHAs where practical.

---

## Trigger Strategy
### Pull Request Triggers
Run on pull_request:

- lint
- validate
- terraform plan
- security scan

### Main Merge Triggers
Run on push to main:

- build
- package
- publish artifacts

### Release Triggers
Run on release tags and/or workflow_dispatch:

- deployment workflows

### Trigger Matrix
| Event | Pipeline Stage | Required Jobs |
|---|---|---|
| pull_request | Pre-merge quality gate | lint, validate, terraform-plan, security-scan |
| push:main | Post-merge build gate | build, package, publish-artifacts |
| release/tag | Promotion and deploy | deploy-dev/stage/prod workflows |
| workflow_dispatch | Controlled operations | manual plan/apply, rollback, hotfix deploy |

---

## CI/CD Pipeline Strategy
### Environment Promotion Model
Environments:

- Dev
- Stage
- Prod

Future promotion flow:

- Dev -> Stage -> Prod

### Promotion Requirements
Promotion must be blocked unless all are satisfied:

- Validation Passed
- Security Checks Passed
- Observability Configured
- Documentation Updated

Additional governance:

- Stage and Prod promotions require environment approval.
- Rollback procedure must be documented before production promotion.

---

## Release Strategy
### Versioning
Use Semantic Versioning.

Examples:

- v0.1.0
- v0.2.0
- v1.0.0

### Release Types
- Major
- Minor
- Patch

### Release Workflow
1. Validate release candidate in Stage.
2. Confirm change log and release notes are complete.
3. Tag release using semantic version.
4. Publish release artifacts and metadata.
5. Deploy to Prod with approval gates.
6. Verify post-release health and reliability signals.

---

## Infrastructure Delivery Strategy
All infrastructure delivery must be Terraform-based and pass the following before apply:

- terraform fmt
- terraform validate
- terraform plan
- tfsec
- checkov

Policy:

- All infrastructure changes require plan review in PR.
- Apply operations must be auditable and environment-scoped.
- Out-of-band/manual console changes are prohibited except incident break-glass with postmortem follow-up.

---

## Container Security Standards
### Container Requirements
- Minimal base images
- Non-root containers
- Image signing
- Vulnerability scanning

### Tooling
- Trivy
- Grype (optional)

Policy:

- High/Critical vulnerabilities must be triaged before promotion.
- Base images must be refreshed on a defined cadence.

---

## GitHub Security Standards
Enable and enforce:

- Dependabot
- Secret Scanning
- Code Scanning
- Dependency Review
- Security Advisories

Future targets:

- SLSA compliance
- Artifact signing

---

## Secrets Management
Security policy:

- Do not use GitHub repository secrets where Workload Identity Federation is available.
- Prefer GitHub OIDC + Workload Identity Federation + GCP Service Accounts.
- No hardcoded credentials.
- No long-lived service account keys.

Implementation guidance:

- Use short-lived, federated credentials for CI jobs.
- Scope service account permissions to workload responsibilities.

---

## CODEOWNERS Strategy
Define ownership domains for future CODEOWNERS implementation:

- Terraform
- Kubernetes
- Observability
- Documentation
- Security

Future implementation guidance:

- Map critical paths to at least one primary and one backup owner.
- Require CODEOWNERS review for protected branch merges.

---

## Reliability Gates
Before deployment, verify:

- Metrics
- Logs
- Traces
- Alerts
- Dashboards

Policy:

- No service should be promoted without observability coverage.
- Health checks and alert routing must be validated in target environment.

---

## AI Reliability Gates
Before deploying AI services, verify:

- Prompt tracing
- Cost tracking
- Latency tracking
- Failure tracking
- Hallucination monitoring

Use:

- Langfuse
- OpenLIT

Policy:

- AI release readiness must include both system reliability and model/agent reliability signals.

---

## Repository Health Metrics
Track and review:

- PR lead time
- Deployment frequency
- Change failure rate
- Mean time to recovery

These metrics should align with DORA measurement practices and be reviewed in regular engineering governance cadences.

---

## Future GitOps Roadmap
Evaluate the following for deployment automation:

- ArgoCD
- FluxCD

### Evaluation Criteria
- Operational simplicity
- Security model compatibility
- Multi-environment promotion support
- Drift detection and reconciliation behavior
- RBAC and policy integration

### Pros and Cons Snapshot
ArgoCD pros:

- Strong UI and application visibility
- Mature ecosystem and multi-cluster patterns

ArgoCD cons:

- Additional control-plane operational overhead

FluxCD pros:

- Lightweight GitOps controllers
- Strong Git-native workflow alignment

FluxCD cons:

- Less centralized UX compared to ArgoCD

Decision guidance:

- Run a controlled pilot in non-production.
- Select one standard GitOps engine to avoid operational fragmentation.

---

## Documentation Cross References
Related governance and operating references:

- docs/WORKFLOW_CATALOG.md
- docs/ENGINEERING_STANDARDS.md
- docs/ONBOARDING.md
- docs/REPOSITORY_MAP.md
- docs/TRACEABILITY_MATRIX.md
