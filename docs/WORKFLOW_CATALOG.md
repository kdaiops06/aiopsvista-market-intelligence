# Workflow Catalog

## Purpose
This catalog documents repository workflows for maintainability, discoverability, and onboarding. It is the primary reference for understanding workflow intent, trigger model, and governance expectations.

## Related Documentation
- docs/SDLC_AND_GOVERNANCE.md
- docs/ONBOARDING.md

| Workflow Name | File Name | Purpose | Trigger | Dependencies | Success Criteria | Future Enhancements |
|---|---|---|---|---|---|---|
| CI | .github/workflows/ci.yml | Baseline repository validation and policy checks for main and PR paths. | pull_request, push | actions/checkout, shell checks | Required docs and baseline checks complete with zero failures. | Replace shell checks with reusable policy workflows and markdown lint. |
| Deploy | .github/workflows/deploy.yml | Controlled deployment entry point for main and manual production operations. | push:main, workflow_dispatch | actions/checkout, deployment environment config | Deployment prechecks pass and deployment command path succeeds. | Add environment promotion gates and OIDC-based cloud authentication. |
| Terraform Validate | .github/workflows/terraform-validate.yml | Validate Terraform formatting and configuration correctness pre-merge. | pull_request | hashicorp/setup-terraform, terraform CLI | Terraform fmt and validate succeed for discovered Terraform modules. | Add reusable module matrix and strict fmt enforcement. |
| Terraform Plan | .github/workflows/terraform-plan.yml | Provide preview of infrastructure changes for reviewer visibility. | pull_request | hashicorp/setup-terraform, terraform CLI | Plan execution succeeds for target module and output is reviewable. | Publish plan artifacts/comments directly to PR for traceability. |
| Terraform Security Scan | .github/workflows/terraform-security.yml | Run Terraform security checks before merge. | pull_request | tfsec action, checkov action | Security scans complete and findings are visible for triage. | Introduce severity gates and suppression management policy. |
| Build | .github/workflows/build.yml | Ensure main branch remains buildable and package-ready. | push:main | actions/checkout, build toolchain | Build stage succeeds with no regressions on main. | Add multi-service build matrix and artifact retention. |
| Release | .github/workflows/release.yml | Coordinate semantic tag release and release note publication flow. | push:tags, workflow_dispatch | actions/checkout, softprops/action-gh-release | Release notes and release metadata publish successfully. | Add signed artifacts, changelog validation, and release provenance. |
| Docs Validation | .github/workflows/docs-validation.yml | Enforce documentation integrity and core docs availability. | pull_request, push:main | actions/checkout, shell checks | Required docs exist and architecture document quality baseline passes. | Add markdown lint, link checks, and docs completeness score. |
