# AI Usage Collector Deployment and Troubleshooting Runbook

## Purpose

Use this runbook to deploy, validate, and troubleshoot the Case Study #004 AI Usage Collector platform.

## Related Documentation
- [Case Study #004 - AI Usage Collector Platform](../docs/case-studies/case-study-004-ai-usage-collector-platform.md)
- [AI Usage Collector Architecture](../docs/architecture/ai-finops/AI_USAGE_COLLECTOR_ARCHITECTURE.md)
- [AI Usage Data Model](../docs/architecture/ai-finops/AI_USAGE_DATA_MODEL.md)
- [Evidence Package](../docs/evidence/case-study-004/README.md)
- [Roadmap](../roadmap/README.md)

## Deployment Steps

1. Ensure the dev project, BigQuery foundation, and Artifact Registry repository exist.
2. Build and push the collector image.
3. Update `terraform.tfvars` with the published image URI.
4. Apply Terraform in the dev environment.
5. Confirm the Cloud Run service URL and service account.
6. Validate `/healthz`, `/readyz`, `/generate`, and `/stats`.

## Validation Checks

- Terraform applies without error
- Cloud Build completes successfully
- Artifact Registry contains the collector image
- Cloud Run service exists and uses the intended image
- BigQuery accepts inserts into `ai_finops.ai_usage`
- Endpoint access is authenticated unless `public_access = true` is explicitly enabled

## Troubleshooting Findings

### 1. Cloud Build source fetch failure

Symptom: `storage.objects.get denied`

Cause: build execution identity cannot read the Cloud Build staging bucket.

Fix: grant the required bucket access to the compute service account used for the build.

### 2. Artifact Registry push failure

Symptom: `artifactregistry.repositories.uploadArtifacts denied`

Cause: the build identity lacks writer access to the repository.

Fix: grant `roles/artifactregistry.writer`.

### 3. Cloud Run service not created

Symptom: Terraform apply succeeds but no service exists.

Cause: `container_image` is empty, so the service resource count resolves to zero.

Fix: publish the image, set the image URI in `terraform.tfvars`, and re-apply Terraform.

### 4. HTTP 403 on the service endpoint

Symptom: endpoint returns 403 Forbidden.

Cause: service is intentionally private and has no `allUsers` binding.

Fix: use authenticated access or explicitly set `public_access = true` only when public access is intentionally required.

### 5. Terraform destroy fails

Symptom: Cloud Run deletion protection blocks teardown.

Cause: deletion protection was enabled on the service.

Fix: set `deletion_protection = false`, apply the change, and re-run destroy.

## Rollback

1. Revert the last Terraform change if the deployment state is incorrect.
2. Remove or replace the collector image tag if a bad revision was published.
3. Destroy the dev environment only after evidence is captured.
