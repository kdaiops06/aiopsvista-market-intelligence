# Deployment Summary

## 1. Architecture Overview

The AiOpsVista Landing Zone dev deployment runs in the `aiopsvista-market-dev` project on a Shared VPC with a private GKE cluster named `aiopsvista-dev-gke`. The cluster is zonal in `us-central1-a`, uses Workload Identity, and routes outbound traffic through Cloud NAT. Managed Service for Prometheus is enabled for cluster-level observability.

## 2. Security Controls Implemented

- Private GKE control plane with private nodes enabled.
- Workload Identity enabled with workload pool `aiopsvista-market-dev.svc.id.goog`.
- Master Authorized Networks enabled with a single trusted client CIDR.
- Dedicated Terraform-managed node service account: `gke-nodes@aiopsvista-market-dev.iam.gserviceaccount.com`.
- Kubernetes API access verified with `kubectl cluster-info`.

## 3. FinOps Optimizations Applied

- GKE boot disks and node disks set to `pd-standard`.
- Disk size reduced to 30 GB.
- Application node pool disabled for phase 1.
- System node pool constrained to a single `e2-small` node.
- Cluster autoscaling removed to keep the demo footprint fixed and predictable.

## 4. Reliability Features Enabled

- Managed Prometheus is enabled.
- Core system pods are running and Ready.
- GKE metadata server and DNS components are healthy.
- Node auto-repair and auto-upgrade remain enabled on the system node pool.

## 5. Deployment Challenges Encountered

The initial GKE create attempt failed because SSD_TOTAL_GB quota in `us-central1` was exceeded. The cluster configuration was reduced to match the dev/demo use case and avoid SSD-backed boot disk pressure.

## 6. Root Cause Analysis

The default GKE node boot disk profile consumed more SSD quota than the project could allocate for the intended rollout. The original sizing was also larger than needed for a learning and showcase environment.

## 7. SSD Quota Issue Resolution

- Switched node boot disks to `pd-standard`.
- Reduced disk size to 30 GB.
- Kept the environment to one small system node.
- Disabled the application pool for phase 1.

## 8. Master Authorized Network Validation

The cluster control plane shows `authorizedNetworksConfig` enabled and includes the trusted source CIDR used for the demo environment. This limits API access to the approved client network and keeps the control plane exposure narrow.

## 9. Lessons Learned

- GKE defaults are too large for a quota-constrained dev/demo environment unless they are explicitly overridden.
- Zonal GKE simplifies the footprint for a demo cluster and reduces resource spread.
- Saving evidence before destroy is essential when the environment is expected to be recreated for consulting demos.

## 10. Recommendations for Next Sprint

- Re-enable the application pool only when a workload needs it.
- Keep the dev cluster zonal unless a regional footprint is required for a specific demo.
- Consider adding a scheduled maintenance window and cost allocation export if the environment remains active for longer.
- Preserve this evidence package alongside future deployment evidence so the cluster can be recreated with the same controls.

