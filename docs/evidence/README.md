# Evidence Package Index

This folder captures the deployment evidence for the AiOpsVista Landing Zone dev environment. Use it as the reference set for validation, handoff, or recreating the environment after destroy.

## Summary Artifacts

- [Deployment Summary](deployment-summary.md)
- [Validation Checklist](validation-checklist.md)

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
