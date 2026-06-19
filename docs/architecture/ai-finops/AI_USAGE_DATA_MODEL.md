# AI Usage Data Model

## AiOpsVista Market Intelligence Platform

---

## Purpose

The `ai_usage` table is the central cost and usage ledger for the AiOpsVista AI FinOps platform. It stores normalized records of AI consumption events from any supported provider or internal agent.

The design goals are:

- **Provider agnosticism.** A single schema supports OpenAI, Gemini, Claude, GitHub Copilot, Cursor, Windsurf, and internal agents.
- **Attribution readiness.** Every record carries enough context to answer cost attribution questions by team, project, agent, model, and environment.
- **Analytics readiness.** The schema supports time-series queries, aggregations, and cost trend analysis without transformation.
- **Extensibility.** Additional providers or metric dimensions can be added without breaking existing queries.

---

## Dataset Design

| Property | Value |
| --- | --- |
| Dataset ID | `ai_finops` |
| Project | `aiopsvista-market-dev` |
| Location | `us-central1` |
| Purpose | AI cost and usage observability |
| Access Model | Least privilege per service account |
| Labels | `environment=dev`, `platform=aiopsvista`, `managed_by=terraform`, `cost_center=demo` |

---

## Table Design

| Property | Value |
| --- | --- |
| Table ID | `ai_usage` |
| Dataset | `ai_finops` |
| Partition | By `event_timestamp` (DAY) |
| Clustering | By `provider`, `project_id`, `environment`, `team_name` |
| Retention | 90 days (Phase 1) |

Partitioning by `event_timestamp` enables partition pruning on time-bounded queries. Clustering uses all four available BigQuery slots:

1. **`provider`** — leading filter in almost every AI FinOps query
2. **`project_id`** — primary cost attribution dimension across projects
3. **`environment`** — prod vs dev spend separation
4. **`team_name`** — team-level cost attribution

`model` is retained as a `GROUP BY`/aggregation dimension. It is not included in clustering because it is rarely an equality filter in production queries — teams ask "what did gpt-4o cost?" through aggregation, not partition scanning.

---

## Column Definitions

### Core Identifiers

| Column | Type | Nullable | Description |
| --- | --- | --- | --- |
| `event_timestamp` | `TIMESTAMP` | No | UTC timestamp when the AI usage event occurred |
| `provider` | `STRING` | No | AI provider name, e.g. `openai`, `gemini`, `anthropic`, `github-copilot` |
| `model` | `STRING` | No | Model name, e.g. `gpt-4o`, `gemini-1.5-pro`, `claude-3-5-sonnet` |
| `request_id` | `STRING` | Yes | Unique request identifier for distributed tracing and audit correlation |

### Attribution Dimensions

| Column | Type | Nullable | Description |
| --- | --- | --- | --- |
| `user_id` | `STRING` | Yes | Identifier of the user or service that initiated the request |
| `project_id` | `STRING` | Yes | GCP project or internal project identifier for cost attribution |
| `team_name` | `STRING` | Yes | Engineering team or business unit, e.g. `platform-team`, `sre-team`, `data-team` |
| `workflow_name` | `STRING` | Yes | Workflow or use-case identifier, e.g. `incident-analysis`, `rag-search`, `customer-support` |
| `agent_name` | `STRING` | Yes | Name of the AI agent if the request originated from an agent workflow |

### Usage Metrics

| Column | Type | Nullable | Description |
| --- | --- | --- | --- |
| `request_count` | `INTEGER` | No | Number of API requests in this record |
| `input_tokens` | `INTEGER` | Yes | Number of input tokens consumed |
| `output_tokens` | `INTEGER` | Yes | Number of output tokens generated |
| `total_tokens` | `INTEGER` | Yes | Total token count (input + output) |
| `estimated_cost` | `FLOAT64` | Yes | Estimated cost in USD based on provider pricing at time of recording |

### Reliability Dimensions

| Column | Type | Nullable | Description |
| --- | --- | --- | --- |
| `latency_ms` | `INTEGER` | Yes | End-to-end request latency in milliseconds |
| `status` | `STRING` | Yes | Request outcome: `success`, `error`, `timeout`, `rate_limited`, `cancelled` |
| `environment` | `STRING` | No | Deployment environment: `dev`, `staging`, or `prod` |

---

## Example Records

**Successful agent workflow (Gemini, SRE team):**
```json
{
  "event_timestamp": "2026-06-19T09:00:00Z",
  "provider": "gemini",
  "model": "gemini-1.5-pro",
  "request_id": "req-a1b2c3d4",
  "user_id": "service-account-sre-agent",
  "project_id": "aiopsvista-market-dev",
  "team_name": "sre-team",
  "workflow_name": "incident-analysis",
  "agent_name": "incident-triage-agent",
  "request_count": 3,
  "input_tokens": 6200,
  "output_tokens": 1800,
  "total_tokens": 8000,
  "estimated_cost": 0.024,
  "latency_ms": 3100,
  "status": "success",
  "environment": "prod"
}
```

**Failed request with rate limiting (OpenAI, platform team):**
```json
{
  "event_timestamp": "2026-06-19T09:05:00Z",
  "provider": "openai",
  "model": "gpt-4o",
  "request_id": "req-e5f6g7h8",
  "user_id": "engineer-001",
  "project_id": "aiopsvista-market-dev",
  "team_name": "platform-team",
  "workflow_name": "copilot-assistance",
  "agent_name": null,
  "request_count": 1,
  "input_tokens": null,
  "output_tokens": null,
  "total_tokens": null,
  "estimated_cost": 0.0,
  "latency_ms": 450,
  "status": "rate_limited",
  "environment": "dev"
}
```

**Batch RAG search (Anthropic, data team):**
```json
{
  "event_timestamp": "2026-06-19T08:30:00Z",
  "provider": "anthropic",
  "model": "claude-3-5-sonnet",
  "request_id": "req-i9j0k1l2",
  "user_id": "service-account-rag-runner",
  "project_id": "aiopsvista-market-dev",
  "team_name": "data-team",
  "workflow_name": "rag-search",
  "agent_name": "market-intelligence-agent",
  "request_count": 12,
  "input_tokens": 28400,
  "output_tokens": 6200,
  "total_tokens": 34600,
  "estimated_cost": 0.1038,
  "latency_ms": 8700,
  "status": "success",
  "environment": "prod"
}
```

---

## Cost Attribution Strategy

### Attribution Dimensions

| Dimension | Column | Attribution Question |
| --- | --- | --- |
| By team | `team_name` | Which team is spending the most on AI? |
| By workflow | `workflow_name` | Which workflow or use-case drives the most cost? |
| By project | `project_id` | Which project has the highest AI cost? |
| By provider | `provider` | Which AI provider is most expensive? |
| By model | `model` | Which model drives the most cost? |
| By agent | `agent_name` | Which agent consumes the most tokens? |
| By user | `user_id` | Which engineer or service account is the top consumer? |
| By environment | `environment` | How does prod AI spend compare to dev? |
| By time | `event_timestamp` | How is AI consumption trending over time? |

### Multi-Level Attribution

The four new columns enable a three-level attribution hierarchy:

```
Organization
  └── team_name         (e.g. sre-team)
        └── workflow_name   (e.g. incident-analysis)
              └── agent_name    (e.g. incident-triage-agent)
```

`request_id` enables tracing individual requests across logs, traces, and cost records — the foundation of AI observability.

`status` enables error budget tracking — the foundation of AI reliability engineering.

---

## Reliability Strategy

The `status` field moves the schema from pure cost tracking into AI Reliability Engineering territory:

| Status Value | Reliability Signal | Use Case |
| --- | --- | --- |
| `success` | Baseline SLI measurement | Success rate calculation |
| `error` | Error budget consumption | Error rate SLO alerting |
| `timeout` | Latency SLO violation evidence | Latency budget tracking |
| `rate_limited` | Provider capacity risk | Quota management alerts |
| `cancelled` | Client-side reliability signal | Retry storm detection |

**Error budget query pattern:**
```sql
-- AI API success rate (SLI) over the last 24 hours
SELECT
  provider,
  model,
  environment,
  COUNTIF(status = 'success') AS successful_requests,
  COUNT(*) AS total_requests,
  ROUND(COUNTIF(status = 'success') / COUNT(*) * 100, 2) AS success_rate_pct
FROM `aiopsvista-market-dev.ai_finops.ai_usage`
WHERE
  event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)
GROUP BY provider, model, environment
ORDER BY success_rate_pct ASC;
```

---

## Retention Strategy

| Phase | Retention |
| --- | --- |
| Phase 1 (Foundation) | 90 days |
| Phase 3 (Attribution) | 365 days |
| Phase 5+ (Reliability) | Configurable per environment |

---

## Query Examples

**Cost by team (this month):**
```sql
SELECT
  team_name,
  SUM(estimated_cost) AS total_cost_usd,
  SUM(total_tokens) AS total_tokens,
  SUM(request_count) AS total_requests
FROM `aiopsvista-market-dev.ai_finops.ai_usage`
WHERE
  DATE(event_timestamp) >= DATE_TRUNC(CURRENT_DATE(), MONTH)
  AND status = 'success'
GROUP BY team_name
ORDER BY total_cost_usd DESC;
```

**Cost by workflow (last 30 days):**
```sql
SELECT
  workflow_name,
  team_name,
  SUM(estimated_cost) AS total_cost_usd,
  SUM(request_count) AS total_requests,
  ROUND(AVG(latency_ms), 0) AS avg_latency_ms
FROM `aiopsvista-market-dev.ai_finops.ai_usage`
WHERE
  event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  AND workflow_name IS NOT NULL
GROUP BY workflow_name, team_name
ORDER BY total_cost_usd DESC;
```

**Cost by project (this month):**
```sql
SELECT
  project_id,
  provider,
  SUM(estimated_cost) AS total_cost_usd,
  SUM(total_tokens) AS total_tokens
FROM `aiopsvista-market-dev.ai_finops.ai_usage`
WHERE
  DATE(event_timestamp) >= DATE_TRUNC(CURRENT_DATE(), MONTH)
GROUP BY project_id, provider
ORDER BY total_cost_usd DESC;
```

**Cost by provider (this month):**
```sql
SELECT
  provider,
  SUM(estimated_cost) AS total_cost_usd,
  SUM(total_tokens) AS total_tokens
FROM `aiopsvista-market-dev.ai_finops.ai_usage`
WHERE
  DATE(event_timestamp) >= DATE_TRUNC(CURRENT_DATE(), MONTH)
GROUP BY provider
ORDER BY total_cost_usd DESC;
```

**Failed request cost analysis (last 7 days):**
```sql
SELECT
  provider,
  model,
  team_name,
  workflow_name,
  status,
  COUNT(*) AS failed_requests,
  SUM(estimated_cost) AS wasted_cost_usd,
  ROUND(AVG(latency_ms), 0) AS avg_latency_ms
FROM `aiopsvista-market-dev.ai_finops.ai_usage`
WHERE
  event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
  AND status != 'success'
GROUP BY provider, model, team_name, workflow_name, status
ORDER BY wasted_cost_usd DESC;
```

**Daily token consumption by model:**
```sql
SELECT
  DATE(event_timestamp) AS usage_date,
  model,
  SUM(input_tokens) AS input_tokens,
  SUM(output_tokens) AS output_tokens,
  SUM(total_tokens) AS total_tokens
FROM `aiopsvista-market-dev.ai_finops.ai_usage`
WHERE
  event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
GROUP BY usage_date, model
ORDER BY usage_date DESC, total_tokens DESC;
```

**Top AI agents by cost:**
```sql
SELECT
  agent_name,
  team_name,
  SUM(estimated_cost) AS total_cost_usd,
  SUM(request_count) AS total_requests,
  ROUND(AVG(latency_ms), 0) AS avg_latency_ms
FROM `aiopsvista-market-dev.ai_finops.ai_usage`
WHERE
  agent_name IS NOT NULL
  AND event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
GROUP BY agent_name, team_name
ORDER BY total_cost_usd DESC;
```

**Cost per engineer over the last 30 days:**
```sql
SELECT
  user_id,
  team_name,
  COUNT(DISTINCT DATE(event_timestamp)) AS active_days,
  SUM(request_count) AS total_requests,
  SUM(total_tokens) AS total_tokens,
  SUM(estimated_cost) AS total_cost_usd
FROM `aiopsvista-market-dev.ai_finops.ai_usage`
WHERE
  event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
GROUP BY user_id, team_name
ORDER BY total_cost_usd DESC;
```

---

## From AI FinOps to AI Reliability Engineering

This schema evolution is a deliberate architectural progression:

| Maturity Level | Columns Enabling It | Capability |
| --- | --- | --- |
| **AI FinOps** | `provider`, `model`, `estimated_cost`, `total_tokens` | Cost visibility and spend tracking |
| **AI Cost Attribution** | `team_name`, `workflow_name`, `project_id` | Chargeback and showback by team and use-case |
| **AI Observability** | `request_id`, `latency_ms`, `status` | Trace correlation, latency analysis, error visibility |
| **AI Reliability Engineering** | `status`, `latency_ms` + SLO queries | Error budgets, SLI measurement, reliability scoring |
| **Agent Operations** | `agent_name`, `workflow_name`, `request_id` | Per-agent cost tracking, workflow attribution, agent tracing |

Every column added in this iteration serves multiple maturity levels simultaneously. The schema is intentionally forward-compatible: Phase 1 writes only require `event_timestamp`, `provider`, `model`, `request_count`, and `environment`. All other columns are nullable and can be populated incrementally as observability instrumentation matures.

