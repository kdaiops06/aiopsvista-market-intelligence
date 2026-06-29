# AI Usage Collection Roadmap

## AiOpsVista Intelligence Platform

---

## Purpose

This roadmap describes the phased evolution of the AI Usage Collector from a mock, low-cost Phase 1 implementation into a full AI usage ingestion and analytics capability.

The roadmap is intentionally conservative. It prioritizes architectural learning, low cost, and Terraform-managed governance over feature breadth.

---

## Roadmap Principles

1. **Keep costs near zero until value is proven.**
2. **Validate each provider integration independently.**
3. **Use the Case Study #003 schema as the single destination model.**
4. **Avoid platform complexity that is not justified by Phase 1 requirements.**
5. **Preserve Terraform management for every infrastructure change.**

---

## Phase 1 — Mock Collector

**Status:** Complete

### Objective

Prove the ingestion path by generating sample usage events and inserting them into `ai_finops.ai_usage`.

### Scope

- Cloud Run mock collector
- Sample event generation
- Normalization to the Case Study #003 schema
- BigQuery insert into `ai_usage`
- Terraform-managed deployment

### Exclusions

- No OpenAI API calls
- No Gemini API calls
- No Claude API calls
- No streaming infrastructure
- No dashboards

### Success Criteria

- Sample records are written to BigQuery
- Required attribution and reliability fields are populated
- The deployment is reproducible through Terraform
- Case Study #004 is delivered and documented as complete

---

## Phase 2 — OpenAI Integration

### Objective

Ingest real OpenAI usage events and normalize them into the same schema.

### Scope

- OpenAI usage retrieval or event capture
- Mapping to `ai_usage`
- Provider-specific metadata normalization

### Success Criteria

- OpenAI records can be ingested without schema changes
- Output remains compatible with downstream attribution queries

---

## Phase 3 — Gemini Integration

### Objective

Extend the collector to ingest Gemini usage data.

### Scope

- Gemini event capture or export ingestion
- Normalization to `ai_usage`
- Attribution preservation across team, workflow, and project fields

### Success Criteria

- Gemini records flow into the same BigQuery table
- Provider-specific differences are absorbed in the normalization layer

---

## Phase 4 — Claude Integration

### Objective

Add Claude usage collection without changing the storage model.

### Scope

- Claude event capture or export ingestion
- Normalization to `ai_usage`
- Reliability metadata preservation

### Success Criteria

- Claude data lands in the shared usage table
- Provider divergence remains isolated to the collector logic

---

## Phase 5 — Agent Framework Integration

### Objective

Connect internal agent frameworks and agent operations metadata.

### Scope

- Agent-generated usage events
- `agent_name` and `workflow_name` enrichment
- Reliability and cost attribution for agent workflows

### Success Criteria

- Agent usage can be analyzed separately from human usage
- Agent operations metrics are queryable in BigQuery

---

## Phase 6 — Real-Time Analytics

### Objective

Add near-real-time visibility and operational reporting.

### Scope

- Queryable reporting layer
- Scheduled analytics or lightweight dashboards
- Cost and reliability trends

### Success Criteria

- Leadership can review AI cost and reliability trends without requiring pipeline redesign
- The analytics layer remains downstream of the same normalized dataset

---

## Dependency Chain

| Phase | Depends On | Delivers |
| --- | --- | --- |
| Phase 1 | Case Study #003 data model | Mock collection path |
| Phase 2 | Phase 1 collector scaffold | OpenAI ingestion |
| Phase 3 | Phase 1 collector scaffold | Gemini ingestion |
| Phase 4 | Phase 1 collector scaffold | Claude ingestion |
| Phase 5 | Phase 1 schema and collector | Agent framework integration |
| Phase 6 | Stable collected data | Real-time analytics |

---

## Recommended Implementation Order

The order below keeps implementation risk and cost low:

1. Deploy the mock collector
2. Validate BigQuery writes
3. Add one provider integration at a time
4. Extend agent metadata only after provider ingestion is stable
5. Build analytics only after data quality is proven

---

## Cost Management Approach

This roadmap is designed to avoid unnecessary spend.

- Cloud Run provides pay-per-use execution
- BigQuery stores only the normalized records required for analytics
- No Pub/Sub or Dataflow costs are introduced in Phase 1
- No GKE cluster is required for the collector path
- No Vertex AI services are needed for the roadmap phases described here

---

## Success Pattern

Each phase should be accepted only when:

- the previous phase remains stable,
- the new provider or capability writes to the same schema,
- the architecture remains Terraform-managed,
- the incremental cost remains justified by the value delivered.

Case Study #004 completed Phase 1 and establishes the collector baseline for future provider integrations and Case Study #005 analytics work.

## Related Documentation
- [Documentation Hub](../../README.md)
- [Case Studies](../../case-studies/README.md)
- [Evidence](../../evidence/README.md)
- [AI FinOps Architecture](AI_FINOPS_ARCHITECTURE.md)
- [AI Usage Collector Architecture](AI_USAGE_COLLECTOR_ARCHITECTURE.md)
- [AI Usage Data Model](AI_USAGE_DATA_MODEL.md)
