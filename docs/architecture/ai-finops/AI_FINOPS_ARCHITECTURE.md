# AI FinOps Architecture

## AiOpsVista Intelligence Platform

---

## Executive Summary

AI consumption in modern engineering organizations is growing faster than visibility into what is being consumed, by whom, and at what cost.

This document defines the foundational architecture for AI Cost and Usage Observability within the AiOpsVista platform. The objective is not to build a dashboard or an ingestion pipeline. The objective is to establish the data model, storage strategy, and governance baseline that makes future AI FinOps, AI Reliability Engineering, and AI Observability capabilities possible.

Phase 1 intentionally keeps infrastructure minimal and costs near zero while establishing the structural foundation required for all subsequent phases.

---

## Business Problem

Organizations are increasingly consuming AI services from multiple providers simultaneously. Spend is distributed across OpenAI, Gemini, Claude, GitHub Copilot, Cursor, Windsurf, and internally developed AI agents. Despite the scale of this spend, most organizations cannot answer basic operational questions:

- Which team is spending the most on AI?
- Which model or provider is the most expensive?
- Which AI agent consumes the most tokens?
- What is the cost per engineer or per AI workflow?
- How is AI consumption trending over time?
- Where is overspend occurring?

Without a structured approach to AI cost attribution, organizations face compounding financial and operational risk as AI adoption scales.

AiOpsVista addresses this by establishing a governed, extensible foundation for AI cost and usage observability before scale makes it expensive to retrofit.

---

## Architecture Goals

The architecture is designed around six goals:

1. **Governance before scale.** Establish cost attribution infrastructure before workload volume makes it impractical.
2. **Provider agnosticism.** Support OpenAI, Gemini, Claude, GitHub Copilot, and future providers without schema changes.
3. **Cost efficiency.** Minimize infrastructure cost during foundational phases using pay-per-query BigQuery storage.
4. **Extensibility.** Allow future phases to add ingestion pipelines, dashboards, and reliability metrics without redesigning the core model.
5. **Security by design.** Apply least privilege access controls, project-level isolation, and no long-lived credentials from the beginning.
6. **Consulting readiness.** Produce an architecture that can be demonstrated to clients and adapted to their specific AI cost attribution needs.

---

## High Level Architecture

```
AI Providers
  OpenAI  ·  Gemini  ·  Claude  ·  GitHub Copilot  ·  Internal Agents
         │
         ▼
  [Future] Usage Collection Layer
         │
         ▼
  BigQuery Dataset: ai_finops
  Table: ai_usage
         │
         ▼
  [Future] Cost Attribution Engine
         │
         ▼
  [Future] Dashboards & Alerts
         │
         ▼
  AI Reliability Engineering  ·  AI FinOps  ·  Agent Operations
```

Phase 1 establishes the `ai_finops` dataset and `ai_usage` table. Everything upstream and downstream is designed but not implemented until the relevant phase.

---

## GCP Components

### Phase 1 Components (This Document)

| Component | Purpose |
| --- | --- |
| GCP Project (`aiopsvista-market-dev`) | Existing project for dev and demo deployments |
| BigQuery Dataset (`ai_finops`) | Container for all AI cost and usage tables |
| BigQuery Table (`ai_usage`) | Stores normalized AI consumption records |

### Future Components (Later Phases)

| Component | Purpose |
| --- | --- |
| Cloud Storage | Raw log staging and archive |
| Pub/Sub | Real-time usage event ingestion |
| Cloud Run | Usage normalization and transformation |
| Looker Studio / Grafana | FinOps dashboards |
| Vertex AI Workbench | Advanced cost attribution analysis |

---

## Security Model

The following security controls apply to the AI FinOps foundation:

- **Project isolation.** The `ai_finops` dataset lives within the existing project where IAM, audit logging, and billing controls are already established.
- **Least privilege access.** BigQuery dataset and table access follows the principle of least privilege. Future service accounts used for ingestion will receive `bigquery.dataEditor` only on the `ai_finops` dataset.
- **No long-lived credentials.** Where automation is required, Workload Identity Federation will be used instead of service account keys.
- **Audit logging.** BigQuery data access logging is available through Cloud Audit Logs without additional configuration.
- **Data governance labels.** The dataset uses the same governance labels applied to all AiOpsVista resources: `environment`, `platform`, `managed_by`, `cost_center`.

---

## Cost Model

Phase 1 cost is near zero.

BigQuery storage pricing applies only to data stored. An empty or lightly populated `ai_usage` table in a development environment generates negligible storage cost.

BigQuery query pricing applies only to bytes processed. Ad hoc queries for validation and demonstration purposes at this stage will cost a fraction of a dollar.

Phase 1 does not include streaming ingestion, reserved slots, or BI Engine reservations. All of those decisions are deferred to later phases when actual query volume and data volume justify them.

---

## Future Evolution

The architecture is designed to evolve in defined phases:

- **Phase 2** adds usage collection by connecting AI providers to the ingestion layer.
- **Phase 3** adds cost attribution logic that maps usage records to teams, projects, agents, and workflows.
- **Phase 4** adds dashboards for FinOps and engineering leadership consumption.
- **Phase 5** adds AI Reliability Engineering metrics, SLI/SLO tracking, and incident response patterns for AI workloads.
- **Phase 6** adds Agent Operations monitoring, including agent cost governance, latency tracking, and tool call success rates.

The `ai_usage` table schema is designed to support all of these phases without requiring structural changes to the base table.

---

## Success Criteria

Phase 1 is complete when:

- The `ai_finops` BigQuery dataset exists in the dev project.
- The `ai_usage` table exists with the correct schema.
- The table can receive test records.
- The table schema is documented and validated.
- The architecture is reviewed and accepted as the foundation for future phases.

## Related Documentation
- [Documentation Hub](../../README.md)
- [Case Studies](../../case-studies/README.md)
- [Evidence](../../evidence/README.md)
- [AI Usage Data Model](AI_USAGE_DATA_MODEL.md)
- [AI Usage Collector Architecture](AI_USAGE_COLLECTOR_ARCHITECTURE.md)
- [AI Usage Collection Roadmap](AI_USAGE_COLLECTION_ROADMAP.md)
