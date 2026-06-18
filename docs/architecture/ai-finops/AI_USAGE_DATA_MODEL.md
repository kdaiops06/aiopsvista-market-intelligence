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
| Clustering | By `provider`, `model`, `environment` |
| Retention | 90 days (Phase 1) |

Partitioning by `event_timestamp` keeps query costs low by enabling partition pruning. Clustering by `provider`, `model`, and `environment` reduces bytes scanned on the most common filter patterns.

---

## Column Definitions

| Column | Type | Nullable | Description |
| --- | --- | --- | --- |
| `event_timestamp` | `TIMESTAMP` | No | UTC timestamp when the AI usage event occurred |
| `provider` | `STRING` | No | AI provider name, e.g. `openai`, `gemini`, `anthropic`, `github-copilot` |
| `model` | `STRING` | No | Model name, e.g. `gpt-4o`, `gemini-1.5-pro`, `claude-3-5-sonnet` |
| `user_id` | `STRING` | Yes | Identifier of the user or service that initiated the request |
| `project_id` | `STRING` | Yes | GCP project or internal project identifier for attribution |
| `agent_name` | `STRING` | Yes | Name of the AI agent if the request originated from an agent workflow |
| `request_count` | `INTEGER` | No | Number of API requests in this record |
| `input_tokens` | `INTEGER` | Yes | Number of input tokens consumed |
| `output_tokens` | `INTEGER` | Yes | Number of output tokens generated |
| `total_tokens` | `INTEGER` | Yes | Total token count (input + output) |
| `estimated_cost` | `FLOAT64` | Yes | Estimated cost in USD based on provider pricing at time of recording |
| `latency_ms` | `INTEGER` | Yes | End-to-end request latency in milliseconds |
| `environment` | `STRING` | No | Deployment environment, e.g. `dev`, `staging`, `prod` |

---

## Example Records

```json
{
  "event_timestamp": "2026-06-18T10:00:00Z",
  "provider": "openai",
  "model": "gpt-4o",
  "user_id": "engineer-001",
  "project_id": "aiopsvista-market-dev",
  "agent_name": null,
  "request_count": 1,
  "input_tokens": 1200,
  "output_tokens": 340,
  "total_tokens": 1540,
  "estimated_cost": 0.0154,
  "latency_ms": 1820,
  "environment": "dev"
}
```

```json
{
  "event_timestamp": "2026-06-18T10:05:00Z",
  "provider": "gemini",
  "model": "gemini-1.5-pro",
  "user_id": "service-account-agent-runner",
  "project_id": "aiopsvista-market-dev",
  "agent_name": "market-intelligence-agent",
  "request_count": 5,
  "input_tokens": 8400,
  "output_tokens": 2100,
  "total_tokens": 10500,
  "estimated_cost": 0.0315,
  "latency_ms": 4200,
  "environment": "dev"
}
```

```json
{
  "event_timestamp": "2026-06-18T09:30:00Z",
  "provider": "github-copilot",
  "model": "copilot-chat",
  "user_id": "engineer-003",
  "project_id": "platform-team",
  "agent_name": null,
  "request_count": 12,
  "input_tokens": 3200,
  "output_tokens": 1800,
  "total_tokens": 5000,
  "estimated_cost": 0.0,
  "latency_ms": 980,
  "environment": "dev"
}
```

---

## Cost Attribution Strategy

The schema supports the following attribution dimensions:

| Dimension | Column | Attribution Question |
| --- | --- | --- |
| By team | `user_id` or `project_id` | Which team is spending the most? |
| By provider | `provider` | Which AI provider is most expensive? |
| By model | `model` | Which model drives the most cost? |
| By agent | `agent_name` | Which agent consumes the most tokens? |
| By project | `project_id` | Which project has the highest AI cost? |
| By environment | `environment` | How does prod AI spend compare to dev? |
| By time | `event_timestamp` | How is AI consumption trending? |

Cost attribution does not require a separate reporting layer. The `ai_usage` table can answer attribution questions directly through SQL queries. A formal attribution engine is introduced in Phase 3 when query volume and complexity justify it.

---

## Retention Strategy

| Phase | Retention |
| --- | --- |
| Phase 1 (Foundation) | 90 days |
| Phase 3 (Attribution) | 365 days |
| Phase 5+ (Reliability) | Configurable per environment |

Partition expiration is configured at the table level. Data older than the retention window is automatically deleted by BigQuery without manual intervention.

---

## Query Examples

**Total estimated cost by provider this month:**
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
  SUM(estimated_cost) AS total_cost_usd,
  SUM(request_count) AS total_requests,
  ROUND(AVG(latency_ms), 0) AS avg_latency_ms
FROM `aiopsvista-market-dev.ai_finops.ai_usage`
WHERE
  agent_name IS NOT NULL
  AND event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
GROUP BY agent_name
ORDER BY total_cost_usd DESC;
```

**Cost per engineer over the last 30 days:**
```sql
SELECT
  user_id,
  COUNT(DISTINCT DATE(event_timestamp)) AS active_days,
  SUM(request_count) AS total_requests,
  SUM(total_tokens) AS total_tokens,
  SUM(estimated_cost) AS total_cost_usd
FROM `aiopsvista-market-dev.ai_finops.ai_usage`
WHERE
  event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
GROUP BY user_id
ORDER BY total_cost_usd DESC;
```
