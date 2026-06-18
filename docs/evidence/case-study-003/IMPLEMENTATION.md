# Case Study #003 — Implementation Record

## AI FinOps Foundation: BigQuery Dataset and Table

### Environment

| Property | Value |
| --- | --- |
| Project | `aiopsvista-market-dev` |
| Region | `us-central1` |
| BigQuery Location | `US` |
| Dataset | `ai_finops` |
| Table | `ai_usage` |

### Terraform Resources Created

| Resource | Type |
| --- | --- |
| `module.bigquery_ai_finops` | `bigquery-ai-finops` module |
| `google_bigquery_dataset.ai_finops` | BigQuery dataset |
| `google_bigquery_table.ai_usage` | BigQuery table |

### Module Location

```
platform/terraform/modules/bigquery-ai-finops/
  main.tf
  variables.tf
  outputs.tf
  versions.tf
  README.md
```

### Dev Environment Changes

| File | Change |
| --- | --- |
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
