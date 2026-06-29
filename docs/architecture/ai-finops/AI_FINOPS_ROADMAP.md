# AI FinOps Roadmap

## AiOpsVista Intelligence Platform

---

## Overview

This roadmap defines the phased evolution of the AiOpsVista AI Cost and Usage Observability platform. Each phase builds on the previous one. The objective is to deliver a production-grade AI FinOps and AI Reliability Engineering capability through incremental, validated steps.

Phases are not time-boxed by calendar dates. Each phase is complete when its success criteria are met.

---

## Phase 1 — Foundation

**Status:** Complete

**Objective:**

Establish the BigQuery schema and dataset required to store normalized AI usage and cost records.

**Components:**

- GCP Project (`aiopsvista-market-dev`)
- BigQuery Dataset (`ai_finops`)
- BigQuery Table (`ai_usage`)

**Activities:**

- Design and document the `ai_usage` data model.
- Create the BigQuery dataset and table.
- Validate the table schema with test records.
- Establish data governance labels and retention policy.
- Deliver Case Study #003 as the completed AI FinOps data model foundation.

**Success Criteria:**

- `ai_finops` dataset exists in the dev project.
- `ai_usage` table exists with the correct schema.
- The table is queryable.
- Architecture and data model are documented.
- Case Study #003 is complete and serves as the storage foundation for Case Study #004.

**Cost Impact:**

Near zero. BigQuery storage and ad hoc query costs at this data volume are negligible.

---

## Phase 2 — Usage Collection

**Status:** Complete

**Objective:**

Connect AI provider APIs and internal agent systems to the `ai_usage` table so that usage events flow into the data model automatically.

**Components:**

- Cloud Pub/Sub (usage event ingestion)
- Cloud Run (usage normalization and enrichment)
- Provider-specific integrations (OpenAI, Gemini, Claude, GitHub Copilot)
- Internal agent instrumentation
- Mock AI Usage Collector delivery in Cloud Run and Terraform

**Activities:**

- Design the event collection schema for each provider.
- Build normalization logic to map provider-specific fields to the `ai_usage` schema.
- Implement streaming ingestion into BigQuery.
- Validate end-to-end record delivery.

**Success Criteria:**

- Usage events from at least one provider land in the `ai_usage` table.
- Record latency from event creation to BigQuery availability is measured.
- Data quality is validated for required fields.
- Case Study #004 is complete and demonstrates the collection path.

**Cost Impact:**

Low. Pub/Sub and Cloud Run costs depend on event volume. Development and demo environments will remain minimal.

---

## Phase 3 — Cost Attribution

**Status:** Planned

**Objective:**

Build logic that attributes AI costs to teams, projects, agents, and workflows.

**Components:**

- Cost Attribution Service
- Team and project mapping configuration
- Attribution queries and views in BigQuery
- Cost summary tables

**Activities:**

- Define the attribution hierarchy (organization → team → project → agent → user).
- Implement attribution mapping as structured configuration.
- Create BigQuery views that pre-aggregate cost by each attribution dimension.
- Validate attribution accuracy against provider billing data.

**Success Criteria:**

- Every usage record in `ai_usage` can be attributed to at least one team or project.
- Cost by team, provider, model, and agent is queryable.
- Attribution configuration is version-controlled and Terraform-managed.

**Cost Impact:**

Low to moderate, depending on BigQuery query volume and Cloud Run processing frequency.

---

## Phase 4 — Dashboards

**Status:** Planned

**Objective:**

Expose AI cost and usage data through dashboards for FinOps, engineering, and executive audiences.

**Components:**

- Looker Studio or Grafana connected to BigQuery
- Pre-built dashboard templates for:
  - Cost by provider
  - Cost by team
  - Token consumption trend
  - Agent cost comparison
  - Engineer productivity metrics

**Activities:**

- Design dashboard layouts aligned to FinOps and executive audiences.
- Implement pre-built views in BigQuery to support fast dashboard queries.
- Configure scheduled refreshes.
- Validate dashboard accuracy against known usage records.

**Success Criteria:**

- At least one FinOps dashboard is operational.
- Dashboard reflects data from the current billing period.
- Data refresh latency is under 24 hours for batch use cases.

**Cost Impact:**

Low. Looker Studio is free with BigQuery integration. Grafana uses existing observability infrastructure.

---

## Phase 5 — AI Reliability Engineering

**Status:** Planned

**Objective:**

Extend the AI FinOps foundation with reliability metrics, SLI/SLO tracking, and incident response patterns for AI workloads.

**Components:**

- SLI definitions for AI services (latency, availability, error rate)
- SLO targets per model and provider
- Error budget tracking
- Alert policies for AI reliability degradation
- Incident response runbooks for AI workload failures

**Activities:**

- Define SLIs for each supported AI provider and model.
- Set SLO targets appropriate for the environment and use case.
- Implement error budget tracking using `latency_ms` and error rate fields.
- Create alert policies for budget burn rate and reliability degradation.
- Author incident response runbooks for common AI failure scenarios.

**Success Criteria:**

- At least one AI service has a defined SLI and SLO.
- Error budget is tracked and reported.
- At least one alert policy is active and validated.
- At least one AI incident runbook exists.

**Cost Impact:**

Low. Reliability metrics use existing Cloud Monitoring and BigQuery resources.

---

## Phase 6 — Agent Operations

**Status:** Planned

**Objective:**

Extend the platform to support operational monitoring, cost governance, and reliability for AI agents running in production or demo environments.

**Components:**

- Agent registry (name, version, owner, cost center)
- Per-agent cost tracking using the `agent_name` column
- Tool call success rate monitoring
- Agent latency and reliability SLIs
- Agent incident response runbooks
- Cost governance policies for agent budgets

**Activities:**

- Define the agent registry model.
- Implement per-agent attribution using the existing `ai_usage` schema.
- Build agent-specific dashboards and alerts.
- Create agent reliability SLIs aligned with Phase 5 patterns.
- Author agent operations runbooks.

**Success Criteria:**

- All active agents are registered and tracked in the agent registry.
- Per-agent cost is queryable from the `ai_usage` table.
- At least one agent has a defined SLI and alert policy.
- Agent operations runbooks are present for common failure modes.

**Cost Impact:**

Low to moderate, depending on agent volume and monitoring alert density.

---

## AiOpsVista Consulting Value

This roadmap is not only a development plan. It is a demonstration of how a mature AI operations practice is built incrementally with discipline and governance at each stage.

The progression shows:

- **Cloud Governance** — Cost controls and governance labels are established in Phase 1 before any workload runs.
- **Platform Engineering** — Infrastructure is code-managed, repeatable, and version-controlled at every phase.
- **FinOps** — Cost visibility and attribution are built into the platform before dashboards are introduced.
- **Reliability Engineering** — SLIs, SLOs, and error budgets are applied to AI workloads the same way they are applied to traditional services.
- **AI Observability** — Usage, cost, latency, and reliability signals are collected and correlated from a single data model.
- **Agent Operations** — Agents are treated as first-class operational entities with cost governance and reliability controls.

Organizations that implement this pattern gain the ability to answer questions about AI cost and reliability that most organizations cannot answer today.

## Related Documentation
- [Documentation Hub](../../README.md)
- [Case Studies](../../case-studies/README.md)
- [Evidence](../../evidence/README.md)
- [AI FinOps Architecture](AI_FINOPS_ARCHITECTURE.md)
- [AI Usage Data Model](AI_USAGE_DATA_MODEL.md)
- [AI Usage Collection Roadmap](AI_USAGE_COLLECTION_ROADMAP.md)
