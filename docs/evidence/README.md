# Evidence Package Index

## Purpose
This folder captures deployment evidence for the platform foundation and the completed case studies. Use it as the reference set for validation, handoff, or recreating the environment after destroy.

## Start Here
- [Case Studies](../case-studies/README.md)
- [Architecture Blueprint](../ARCHITECTURE.md)
- [Runbooks](../../runbooks/README.md)

## Summary Artifacts
- [Deployment Summary](deployment-summary.md)
- [Validation Checklist](validation-checklist.md)

## Case Study Evidence
- [Case Study #002 Evidence Package](case-study-002/README.md)
- [Case Study #003 Evidence Package](case-study-003/README.md)
- [Case Study #004 Evidence Package](case-study-004/README.md)

## Raw Evidence
- [cluster-info.txt](cluster-info.txt)
- [cluster-namespaces.txt](cluster-namespaces.txt)
- [cluster-nodes.txt](cluster-nodes.txt)
- [cluster-pods.txt](cluster-pods.txt)
- [cluster-services.txt](cluster-services.txt)
- [gcp-enabled-apis.txt](gcp-enabled-apis.txt)
- [gcp-gke-details.txt](gcp-gke-details.txt)
- [gcp-iam-policy.txt](gcp-iam-policy.txt)
- [gcp-network-details.txt](gcp-network-details.txt)
- [gcp-project-details.txt](gcp-project-details.txt)
- [gcp-service-accounts.txt](gcp-service-accounts.txt)
- [terraform-outputs.txt](terraform-outputs.txt)
- [terraform-providers.txt](terraform-providers.txt)
- [terraform-state.txt](terraform-state.txt)
- [terraform-version.txt](terraform-version.txt)

## Notes
- The cluster is zonal in `us-central1-a`.
- The environment uses a private GKE control plane, Shared VPC, Cloud NAT, and Workload Identity.
- Managed Prometheus is enabled for cluster observability.
- Case study evidence packages are maintained alongside the landing zone evidence so platform and AI FinOps handoffs stay traceable.
