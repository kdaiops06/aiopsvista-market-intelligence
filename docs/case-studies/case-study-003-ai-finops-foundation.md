# AiOpsVista Case Study #003

## AI Cost and Usage Observability Foundation

---

### 1. Executive Summary

AiOpsVista implemented a Terraform-managed BigQuery dataset and table as the data foundation for AI cost attribution, AI observability, and AI Reliability Engineering in the `aiopsvista-market-dev` environment.

The implementation established a 17-column schema grouped into five categories: core identifiers, observability fields, attribution dimensions, usage metrics, and reliability metrics. The table is day-partitioned on `event_timestamp` and clustered on `provider`, `project_id`, `environment`, and `team_name` — using all four available BigQuery clustering slots to optimise attribution query performance.

This case study demonstrates how a single, well-designed BigQuery table can serve as the foundation for multiple platform maturity levels simultaneously: AI FinOps, AI Cost Attribution, AI Observability, AI Reliability Engineering, and Agent Operations.

---

### 2. Business Problem

Case Study #001 established the secure cloud foundation: project, Shared VPC, Cloud NAT, Private GKE, and Workload Identity. Case Study #002 established financial governance: budget guardrails and billing alerts. Both created a platform capable of running AI workloads. Neither answered the question that matters most at scale: what are those workloads actually costing, and are they performing reliably?

Without a usage data foundation, AI platform teams face a set of predictable failure modes:

- Token costs are visible in provider billing portals but cannot be attributed to the teams or workflows that generated them
- Failed AI requests consume latency and sometimes partial token costs, but go untracked
- There is no way to calculate an error rate or error budget for AI services
- Agent workflows have no per-agent cost visibility
- As providers and models proliferate, cost fragmentation increases without a central ledger

The business objective for Case Study #003 was to establish the data infrastructure needed to answer attribution, observability, and reliability questions before AI workloads scale to a point where retroactive schema design becomes expensive.

---

### 3. Why This Foundation Matters

A BigQuery usage table is not inherently interesting. What makes this implementation consequential is the deliberate choice to design it as a multi-purpose observability data model rather than a billing ledger.

The distinction is this: a billing ledger records what was spent. An observability data model records what happened, why, what the outcome was, and who was responsible. The `status` column turns the table from a cost report into an error rate source. The `request_id` column turns a cost record into a traceable event. The `team_name` and `workflow_name` columns turn an aggregate spend number into an accountable attribution.

These additions cost nothing at ingestion time. All four columns are nullable. They can be populated incrementally as instrumentation matures. But by reserving them in the schema from day one, the platform avoids the most common and most expensive AI FinOps failure mode: realising that attribution dimensions are missing six months after data collection begins.

---

### 4. Solution Architecture

The implementation used a reusable Terraform module at `platform/terraform/modules/bigquery-ai-finops`, consumed by `platform/terraform/environments/dev`.

**BigQuery Dataset: `ai_finops`**

The dataset is the organisational container for all AI usage data. It carries governance labels applied at creation time: `environment`, `platform`, `managed_by`, and `cost_center`. The `delete_contents_on_destroy` flag is set to `true` in the dev environment to support clean lifecycle management; this is overridden to `false` in production configurations.

**BigQuery Table: `ai_usage`**

The table is the central AI usage ledger. It is day-partitioned on `event_timestamp` and clustered on four columns:

| Clustering Order | Column | Rationale |
| --- | --- | --- |
| 1 | `provider` | Leading filter in nearly every AI FinOps query |
| 2 | `project_id` | Primary cost attribution dimension across projects |
| 3 | `environment` | Isolates prod from dev spend in filter conditions |
| 4 | `team_name` | Team-level attribution appears in the majority of governance queries |

`model` is excluded from clustering because it is an aggregation dimension, not a filter dimension. Teams aggregate cost by model through `GROUP BY`; they do not typically filter with `WHERE model = 'gpt-4o'`.

**Schema Design**

The 17-column schema is designed around five responsibilities:

| Group | Columns | Responsibility |
| --- | --- | --- |
| Core Identifiers | `event_timestamp`, `provider`, `model`, `request_id` | Event identification and traceability |
| Attribution Dimensions | `project_id`, `team_name`, `workflow_name`, `user_id`, `agent_name` | Cost routing and chargeback |
| Usage Metrics | `request_count`, `input_tokens`, `output_tokens`, `total_tokens`, `estimated_cost` | Cost and consumption measurement |
| Reliability Metrics | `latency_ms`, `status` | SLI measurement and error budget tracking |
| Environment | `environment` | Cross-environment cost separation |

---

### 5. Relationship to Previous Case Studies

Each case study in the AiOpsVista series builds directly on the infrastructure and governance established by its predecessor. This is not a coincidence — it reflects a deliberate platform maturity progression.

**Case Study #001 — Secure Cloud Foundation**

Delivered the project, Shared VPC, Cloud NAT, Private GKE cluster, and Workload Identity. This was the operating environment: compute, networking, and identity. Without it, there is nowhere to run AI workloads and no secure network boundary within which to collect usage data.

Case Study #003 depends on this foundation for the GKE cluster that will eventually host the AI usage collectors, the Workload Identity configuration that will allow those collectors to write to BigQuery without service account keys, and the VPC that provides network isolation between components.

**Case Study #002 — FinOps Budget Guardrails**

Delivered billing budget controls, threshold alerts, and forecast alerts with email notification. This established the financial governance layer: spend could be observed and bounded at the billing level before it was observable at the workload level.

Case Study #003 builds downward from the budget guardrail. A monthly budget alert tells you that spending is approaching a threshold. The `ai_usage` table tells you which team, which workflow, and which model drove it there. Budget guardrails provide the alarm. The AI usage foundation provides the diagnosis.

**Case Study #003 — AI Cost and Usage Observability Foundation**

Delivers the usage data model, cost attribution schema, and reliability measurement foundation. This is the analytical layer that makes the compute and governance layers actionable.

Case Study #003 enables Case Study #004 by providing the destination schema that usage collectors will write to. The ingestion pipeline for OpenAI, Gemini, and Claude usage events can be built against a stable, well-defined schema from day one.

---

### 6. Architectural Achievements

This implementation successfully established seven foundational capabilities:

**1. AI FinOps Foundation**
A Terraform-managed BigQuery dataset and table that records provider, model, token consumption, and estimated cost for every AI usage event.

**2. AI Cost Attribution Foundation**
Four attribution dimensions — `team_name`, `workflow_name`, `project_id`, `agent_name` — that enable cost routing to teams, workflows, projects, and agent systems without requiring a separate attribution service in Phase 1.

**3. AI Observability Data Model**
`request_id` enables correlation between BigQuery cost records and distributed traces in Tempo or logs in Cloud Logging. The same request can be located across cost, latency, and error data.

**4. AI Reliability Data Model**
`status` and `latency_ms` enable error rate calculation, error budget tracking, and latency SLI measurement directly from the usage table. No separate reliability database is required.

**5. Agent Operations Foundation**
`agent_name` and `workflow_name` together provide the per-agent cost and attribution data required for Agent Operations governance. When multiple agents share a provider account, costs can be attributed by agent name and workflow.

**6. Terraform-managed Governance**
The entire data infrastructure is version-controlled and reproducible. Schema changes, label updates, and configuration drift are managed through pull requests, not manual console operations.

**7. BigQuery Analytics Foundation**
Day partitioning and four-column clustering ensure that attribution queries, time-series analysis, and reliability calculations are cost-efficient from the first record.

---

### 7. Business Outcomes

| Outcome | Evidence |
| --- | --- |
| AI FinOps foundation established | `google_bigquery_dataset.ai_finops` confirmed in Terraform state |
| Cost attribution model implemented | `team_name`, `workflow_name`, `project_id`, `agent_name` columns in deployed schema |
| Reliability metrics foundation implemented | `status` and `latency_ms` columns in deployed schema |
| AI observability schema implemented | `request_id` column enables distributed trace correlation |
| Governance controls validated | Labels `environment`, `platform`, `managed_by`, `cost_center` confirmed on dataset |
| Terraform-managed deployment validated | 22 resources confirmed in state; `terraform plan` shows 0 changes after apply |
| Cost-efficient analytics architecture implemented | DAY partitioning + 4-column clustering reduces bytes scanned on attribution queries |
| Future AI Operations platform enabled | Schema forward-compatible with Case Study #004 usage collectors |

---

### 8. Lessons Learned

**Design attribution dimensions before ingestion begins.**
Retrofitting team and workflow attribution into an existing schema with months of data requires backfilling pipelines, schema migrations, and cross-team coordination. Nullable columns reserved in the initial schema cost nothing but enable everything.

**AI FinOps and AI Reliability should share a common data model.**
The cost of a failed AI request is real. A schema that cannot join cost to reliability outcome forces a join at query time that is expensive and operationally fragile. The `status` column in the same table as `estimated_cost` is the correct design.

**Governance labels should be applied from day one.**
Labels applied after resource creation require Terraform plan updates and create gaps in billing export data. Labels present at `terraform apply` are reflected in every billing report from the first invoice.

**BigQuery partitioning and clustering decisions significantly impact long-term cost efficiency.**
Partition pruning and clustering column order determine how many bytes every attribution query scans. These decisions should be validated against anticipated query patterns before the table is created. Changing clustering on a live table requires recreation.

**Terraform provides repeatable governance patterns.**
Schema changes reviewed in pull requests are auditable, reversible, and consistent across environments. Manual schema changes through the GCP console are not.

**AI observability requires metadata, not just token counts.**
Token count and cost data answer "how much?" Metadata — `request_id`, `status`, `latency_ms`, `agent_name` — answers "why?", "what happened?", and "who is responsible?". A data model that captures only billing signals cannot support production AI operations.

---

### 9. Next Phase: Case Study #004 — AI Usage Collector

Case Study #003 established the destination. Case Study #004 will establish the pipeline.

The AI Usage Collector will ingest real usage events from OpenAI, Gemini, and Claude, normalise them to the `ai_usage` schema, attribute them using `team_name`, `workflow_name`, and `project_id`, and write them to `aiopsvista-market-dev.ai_finops.ai_usage`.

Case Study #003 enables Case Study #004 in the following ways:

| Case Study #003 Deliverable | Case Study #004 Dependency |
| --- | --- |
| Stable 17-column `ai_usage` schema | Collector output schema is defined before the first pipeline is written |
| `request_id` column | Collector generates and attaches a trace ID to every usage event at source |
| `team_name` and `workflow_name` columns | Collector reads attribution context from request metadata or configuration |
| `status` column | Collector writes outcome status alongside token counts |
| Terraform-managed dataset and table | Collector deployment references dataset ID through Terraform output |
| GKE cluster from Case Study #001 | Collector workload runs on the existing private GKE cluster |
| Workload Identity from Case Study #001 | Collector writes to BigQuery without service account keys |

The Case Study #003 schema was deliberately designed with Case Study #004 in mind. Every nullable column that appears unused in Phase 1 is a contract with the next phase of the platform.

---

### 10. Technical Appendix

**Module reference:** `platform/terraform/modules/bigquery-ai-finops`

**Terraform state resources (Case Study #003 scope):**

```
module.bigquery_ai_finops.google_bigquery_dataset.ai_finops
module.bigquery_ai_finops.google_bigquery_table.ai_usage
```

**Full platform state at time of validation:** 22 resources across 6 modules.

**Branch:** `feature/terraform-ai-finops-foundation`

**Pull Request:** #15

**Evidence documents:**
- `docs/evidence/case-study-003/IMPLEMENTATION.md`
- `docs/evidence/case-study-003/VALIDATION.md`
- `docs/evidence/case-study-003/LESSONS_LEARNED.md`
