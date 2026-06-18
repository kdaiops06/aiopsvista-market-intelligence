# BigQuery AI FinOps Module

## Purpose

Creates the BigQuery dataset and table required for the AiOpsVista AI Cost and Usage Observability foundation.

## Resources Created

- `google_bigquery_dataset.ai_finops` — Dataset for all AI FinOps tables.
- `google_bigquery_table.ai_usage` — Normalized AI usage and cost records table.

## Features

- Day-based partitioning on `event_timestamp`.
- Clustering on `provider`, `model`, `environment`.
- Standard governance labels on dataset and table.
- 90-day partition expiration (configurable).
- `deletion_protection = false` for dev/demo environments.

## Inputs

See `variables.tf` for configurable values.

## Outputs

- `dataset_id`
- `dataset_self_link`
- `table_id`
- `table_self_link`
