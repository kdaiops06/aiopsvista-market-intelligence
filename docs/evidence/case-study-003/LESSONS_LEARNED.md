# Case Study #003 — Lessons Learned

## AI Cost and Usage Observability Foundation

---

### Lesson 1: Design Attribution Dimensions Before Ingestion Begins

The most expensive mistake in AI FinOps is collecting usage data without defining attribution dimensions first.

Token counts and cost estimates are easy to collect. Connecting those costs back to the teams, workflows, and projects that drove them is hard to retrofit after the fact.

This implementation reserved `team_name`, `workflow_name`, `project_id`, and `agent_name` as nullable columns in the initial schema. That decision costs nothing at ingestion time — all four columns are optional — but it creates the hooks needed for multi-team governance, chargeback models, and workflow-level attribution before any real data flows.

**Practice:** Define attribution columns before the first record is written. Retrofitting attribution dimensions into an existing schema with months of data already in it requires backfilling, pipeline changes, and cost coordination across teams.

---

### Lesson 2: AI FinOps and AI Reliability Should Share a Common Data Model

AI FinOps measures cost. AI Reliability Engineering measures service quality. In most early implementations these are treated as separate concerns with separate pipelines.

This creates a blind spot: failed requests cost money too.

By including `status` (success, error, timeout, rate_limited, cancelled) and `latency_ms` in the same table as token counts and estimated cost, the schema enables a category of query that neither a pure FinOps model nor a pure SRE model can answer alone: the cost of unreliability.

**Practice:** Build a single data model that serves both cost observability and reliability observability. Separating them requires a join later that is expensive at query time and operationally fragile.

---

### Lesson 3: Governance Labels Should Be Applied from Day One

Labels added after resources are created require targeted Terraform updates, potential plan noise, and manual reconciliation in billing exports. Labels that were present from the first `terraform apply` are automatically reflected in all cost reports, budget breakdowns, and governance audits.

This implementation applied `environment`, `platform`, `managed_by`, and `cost_center` at both dataset and table level on day one. The `goog-terraform-provisioned` label is added automatically by the Google provider.

**Practice:** Define your labelling taxonomy before writing the first Terraform resource. Cost centre tags in billing exports are only useful if they were applied before the first invoice.

---

### Lesson 4: BigQuery Partitioning and Clustering Decisions Significantly Impact Long-Term Cost Efficiency

BigQuery charges for bytes scanned. Without partitioning and clustering, every query against the `ai_usage` table scans the full table regardless of filter conditions.

Partitioning by `event_timestamp` (DAY) ensures that time-bounded queries — which represent the majority of cost attribution and reliability queries — scan only the relevant day partitions.

Clustering by `provider`, `project_id`, `environment`, and `team_name` uses all four available BigQuery clustering slots. This order was selected to match the filter sequence of the most common attribution query patterns.

The decision to exclude `model` from clustering (placing it in `GROUP BY` instead) was deliberate: `model` is almost never used as an equality filter. Teams ask "what did gpt-4o cost?" through aggregation across rows, not through partition scanning.

**Practice:** Validate your clustering column choices against your anticipated query patterns before the table is created. Changing clustering on a live table requires recreation.

---

### Lesson 5: Terraform Provides Repeatable Governance Patterns

Every resource in this case study was managed through Terraform. The dataset, the table, the schema, the labels, the partitioning, the clustering, the API enablement — all of it is version-controlled, reviewable, and reproducible.

This paid dividends immediately: when a `terraform plan` revealed that `model` was still in the clustering definition after the schema refactor, the fix was a one-line change reviewed in a pull request rather than a manual GCP Console operation with no audit trail.

**Practice:** Apply Terraform not just to compute and networking, but to data infrastructure from the start. A BigQuery schema that lives outside of IaC is technical debt from day one.

---

### Lesson 6: AI Observability Requires Metadata, Not Just Token Counts

The initial schema collected provider, model, token counts, and cost. That is sufficient for a billing dashboard. It is insufficient for operational observability.

Operational AI observability requires context: who triggered the request, what workflow it was part of, what agent called the model, whether it succeeded, and how long it took. Without `request_id`, there is no way to correlate a BigQuery cost record with a trace in Tempo or a log in Cloud Logging. Without `status`, there is no way to measure reliability or detect degradation.

**Practice:** Treat the AI usage schema as an observability data model, not a billing ledger. Every field that answers a debugging or reliability question has more operational value than its storage cost.
