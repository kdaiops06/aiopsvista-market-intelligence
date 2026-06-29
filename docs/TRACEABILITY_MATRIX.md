# Architecture Traceability Matrix

## Purpose
This matrix links business outcomes to architecture, services, observability, and runbook expectations for engineering governance and consulting discussions.

| Business Goal | Architecture Component | Service | Observability | Runbook |
|---|---|---|---|---|
| Reliable Market Data | Pub/Sub ingestion pipeline | Market Processor | Grafana pipeline health dashboard, Cloud Monitoring backlog metrics | [Runbooks Index](../runbooks/README.md) |
| Timely Market Insights | BigQuery + Vertex AI integration path | AI Analyzer | Langfuse traces, OpenLIT latency/cost panels, Tempo traces | [Runbooks Index](../runbooks/README.md) |
| News Signal Coverage | External feed ingestion + storage staging | News Collector | Collector success/failure metrics, Cloud Logging error tracking | [Runbooks Index](../runbooks/README.md) |
| Stable API Experience | Private GKE + API service layer | Dashboard API | API latency/error dashboards, SLO burn-rate alerts | [Runbooks Index](../runbooks/README.md) |
| Actionable Alerting | Rule evaluation and delivery routing | Alert Service | Alert dispatch success metrics, notification failure logs | [Runbooks Index](../runbooks/README.md) |
| Platform Security Posture | IAM + Workload Identity + Secret Manager | Platform-wide controls | Security scan workflow outputs, audit log monitoring | [Runbooks Index](../runbooks/README.md) |
| Deployment Reliability | Branch protection + CI/CD governance | GitHub Actions workflows | Workflow run history, failed check trends | [Runbooks Index](../runbooks/README.md) |
| AI Reliability Assurance | AI observability stack (Langfuse/OpenLIT) | AI Analyzer + Agent flows | Prompt trace quality, hallucination indicators, cost/latency trends | [Runbooks Index](../runbooks/README.md) |
| AI Usage Collection | [Cloud Run + Artifact Registry + BigQuery telemetry pipeline](case-studies/case-study-004-ai-usage-collector-platform.md) | [AI Usage Collector](../services/ai-usage-collector/README.md) | Structured logs, health/readiness endpoints, BigQuery insert outcomes | [AI Usage Collector runbook](../runbooks/ai-usage-collector-deployment-and-troubleshooting.md) |

## Related Documentation
- docs/ARCHITECTURE.md
- docs/SDLC_AND_GOVERNANCE.md
- docs/WORKFLOW_CATALOG.md
