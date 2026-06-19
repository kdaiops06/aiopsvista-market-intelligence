# Case Study #003 — Implementation Record

## AI Cost and Usage Observability Foundation

---

### Environment

| Property | Value |
| --- | --- |
| Project | `aiopsvista-market-dev` |
| Region | `us-central1` |
| BigQuery Location | `US` |
| Dataset | `ai_finops` |
| Table | `ai_usage` |
| Terraform Version | `1.15.6` |
| Google Provider | `~> 7.35` |
| Branch | `feature/terraform-ai-finops-foundation` |

### Terraform Resources Deployed (Confirmed State)

The following 22 resources were confirmed in Terraform state after `terraform apply`:

**BigQuery — AI FinOps Foundation:**

| Resource | Module |
| --- | --- |
| `google_bigquery_dataset.ai_finops` | `module.bigquery_ai_finops` |
| `google_bigquery_table.ai_usage` | `module.bigquery_ai_finops` |

**Previously Deployed — Case Study #001 (GKE Landing Zone):**

| Resource | Module |
| --- | --- |
| `google_compute_network.this` | `module.shared_vpc` |
| `google_compute_subnetwork.subnets["gke-subnet"]` | `module.shared_vpc` |
| `google_compute_subnetwork.subnets["services-subnet"]` | `module.shared_vpc` |
| `google_compute_router.this` | `module.cloud_nat` |
| `google_compute_router_nat.this` | `module.cloud_nat` |
| `google_container_cluster.this` | `module.gke` |
| `google_container_node_pool.system` | `module.gke` |
| `google_service_account.gke_nodes` | `module.project` |

**Previously Deployed — Case Study #002 (FinOps Budget Guardrails):**

| Resource | Module |
| --- | --- |
| `google_billing_budget.this` | `module.budget` |
| `google_monitoring_notification_channel.budget_email` | `module.budget` |

**Project Foundation:**

| Resource | Module |
| --- | --- |
| `google_project.this` | `module.project` |
| `google_project_service.enabled["artifactregistry.googleapis.com"]` | `module.project` |
| `google_project_service.enabled["bigquery.googleapis.com"]` | `module.project` |
| `google_project_service.enabled["billingbudgets.googleapis.com"]` | `module.project` |
| `google_project_service.enabled["cloudresourcemanager.googleapis.com"]` | `module.project` |
| `google_project_service.enabled["compute.googleapis.com"]` | `module.project` |
| `google_project_service.enabled["container.googleapis.com"]` | `module.project` |
| `google_project_service.enabled["iam.googleapis.com"]` | `module.project` |
| `google_project_service.enabled["monitoring.googleapis.com"]` | `module.project` |
| `google_project_service.enabled["serviceusage.googleapis.com"]` | `module.project` |

---

### Terraform Resources Created

| Resource | Type |
| --- | --- |
| `module.bigquery_ai_finops` | `bigquery-ai-finops` module |
| `google_bigquery_dataset.ai_finops` | BigQuery dataset |
| `google_bigquery_table.ai_usage` | BigQuery table |

### Module Location

```
platform/terraform/modules/bigquery-ai-finops/
  main.tf        — dataset, table, schema, partitioning, clustering
  variables.tf   — project_id, dataset_id, location, labels, delete_contents_on_destroy
  outputs.tf     — dataset_id, dataset_self_link, table_id, table_self_link
  versions.tf    — Terraform >= 1.5.0, google >= 5.30.0
  README.md      — module documentation
```

---

  main.tf
  variables.tf
  outputs.tf
  versions.tf
  README.md
```

### Dev Environment Changes

| File | Change |
| --- | --- |
| `environments/dev/main.tf` | Added `bigquery.googleapis.com` to `activate_apis`; added `module.bigquery_ai_finops` block |
| `environments/dev/variables.tf` | Added `ai_finops_dataset_id`, `ai_finops_location`, `ai_finops_delete_contents_on_destroy`, `ai_finops_labels` |
| `environments/dev/outputs.tf` | Added `ai_finops_dataset_id` and `ai_finops_table_id` outputs |
| `environments/dev/terraform.tfvars.example` | Added AI FinOps variable examples |
| `platform/terraform/.gitignore` | Added `**/.terraform.lock.hcl` exclusion |

---

### Labels Applied

| Label | Value | Purpose |
| --- | --- | --- |
| `environment` | `dev` | Environment identification |
| `platform` | `aiopsvista` | Platform ownership |
| `managed_by` | `terraform` | IaC governance signal |
| `cost_center` | `ai-finops` | Cost attribution routing |
| `goog-terraform-provisioned` | `true` | GCP-managed label (auto-applied) |

---

### Table Schema

**Required Fields (Core Identifiers):**

| Column | Type | Mode | Purpose |
| --- | --- | --- | --- |
| `event_timestamp` | `TIMESTAMP` | `REQUIRED` | UTC event time; partition key |
| `provider` | `STRING` | `REQUIRED` | AI provider: openai, gemini, anthropic |
| `model` | `STRING` | `REQUIRED` | Model identifier |
| `request_count` | `INTEGER` | `REQUIRED` | API requests in this record |
| `environment` | `STRING` | `REQUIRED` | dev, staging, prod |

**Observability Fields:**

| Column | Type | Mode | Purpose |
| --- | --- | --- | --- |
| `request_id` | `STRING` | `NULLABLE` | Distributed tracing and audit correlation |

**Attribution Fields:**

| Column | Type | Mode | Purpose |
| --- | --- | --- | --- |
| `project_id` | `STRING` | `NULLABLE` | GCP project or internal project identifier |
| `team_name` | `STRING` | `NULLABLE` | Engineering team or business unit |
| `workflow_name` | `STRING` | `NULLABLE` | Workflow or use-case identifier |
| `user_id` | `STRING` | `NULLABLE` | User or service account identifier |
| `agent_name` | `STRING` | `NULLABLE` | AI agent name for agent workflow attribution |

**Usage Metrics:**

| Column | Type | Mode | Purpose |
| --- | --- | --- | --- |
| `input_tokens` | `INTEGER` | `NULLABLE` | Input tokens consumed |
| `output_tokens` | `INTEGER` | `NULLABLE` | Output tokens generated |
| `total_tokens` | `INTEGER` | `NULLABLE` | Total tokens (input + output) |
| `estimated_cost` | `FLOAT64` | `NULLABLE` | Estimated cost in USD |

**Reliability Metrics:**

| Column | Type | Mode | Purpose |
| --- | --- | --- | --- |
| `latency_ms` | `INTEGER` | `NULLABLE` | End-to-end request latency in milliseconds |
| `status` | `STRING` | `NULLABLE` | success, error, timeout, rate_limited, cancelled |

---

### Partitioning and Clustering

| Property | Value | Rationale |
| --- | --- | --- |
| Partition type | `DAY` | Enables partition pruning for time-bounded queries |
| Partition field | `event_timestamp` | UTC event time drives all time-series analysis |
| Clustering columns | `provider`, `project_id`, `environment`, `team_name` | All four BigQuery clustering slots used for attribution query optimisation |

`model` is intentionally excluded from clustering — it is a `GROUP BY` aggregation dimension, not an equality filter.

---

### Security Controls

- No service account keys; ADC-based authentication
- Terraform-managed lifecycle for all resources
- Labels applied at both dataset and table level
- `deletion_protection = false` scoped to dev only; production configurations use `true`
- `delete_contents_on_destroy = true` scoped to dev for clean lifecycle management
- BigQuery API enabled through the project service management module with `depends_on` ordering
| `environments/dev/main.tf` | Added `bigquery.googleapis.com` API and `module.bigquery_ai_finops` block |
| `environments/dev/variables.tf` | Added `ai_finops_*` variables |
| `environments/dev/outputs.tf` | Added `ai_finops_dataset_id` and `ai_finops_table_id` outputs |
| `environments/dev/terraform.tfvars.example` | Added AI FinOps example values |

### Labels Applied

| Label | Value |
| --- | --- |
| `environment` | `dev` |
| `platform` | `aiopsvista` |
| `managed_by` | `terraform` |
| `cost_center` | `ai-finops` |

### Table Schema

| Column | Type | Mode |
| --- | --- | --- |
| `event_timestamp` | `TIMESTAMP` | `REQUIRED` |
| `provider` | `STRING` | `REQUIRED` |
| `model` | `STRING` | `REQUIRED` |
| `user_id` | `STRING` | `NULLABLE` |
| `project_id` | `STRING` | `NULLABLE` |
| `agent_name` | `STRING` | `NULLABLE` |
| `request_count` | `INTEGER` | `REQUIRED` |
| `input_tokens` | `INTEGER` | `NULLABLE` |
| `output_tokens` | `INTEGER` | `NULLABLE` |
| `total_tokens` | `INTEGER` | `NULLABLE` |
| `estimated_cost` | `FLOAT64` | `NULLABLE` |
| `latency_ms` | `INTEGER` | `NULLABLE` |
| `environment` | `STRING` | `REQUIRED` |

### Partitioning and Clustering

- Partitioned by `event_timestamp` (DAY)
- Clustered by `provider`, `model`, `environment`

### Security Controls

- No service account keys.
- Terraform-managed dataset and table.
- Labels applied at dataset and table level.
- `delete_contents_on_destroy = true` for dev lifecycle management.
- BigQuery API enabled through the project service management module.
