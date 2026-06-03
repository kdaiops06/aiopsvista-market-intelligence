# Architecture Traceability Matrix

## Purpose
This matrix links business outcomes to architecture, services, observability, and runbook expectations for engineering governance and consulting discussions.

| Business Goal | Architecture Component | Service | Observability | Runbook |
|---|---|---|---|---|
| Reliable Market Data | Pub/Sub ingestion pipeline | Market Processor | Grafana pipeline health dashboard, Cloud Monitoring backlog metrics | Market data pipeline incident runbook (planned under runbooks/) |
| Timely Market Insights | BigQuery + Vertex AI integration path | AI Analyzer | Langfuse traces, OpenLIT latency/cost panels, Tempo traces | AI analysis degradation runbook (planned under runbooks/) |
| News Signal Coverage | External feed ingestion + storage staging | News Collector | Collector success/failure metrics, Cloud Logging error tracking | News ingestion failure runbook (planned under runbooks/) |
| Stable API Experience | Private GKE + API service layer | Dashboard API | API latency/error dashboards, SLO burn-rate alerts | Dashboard API incident response runbook (planned under runbooks/) |
| Actionable Alerting | Rule evaluation and delivery routing | Alert Service | Alert dispatch success metrics, notification failure logs | Alert delivery failure runbook (planned under runbooks/) |
| Platform Security Posture | IAM + Workload Identity + Secret Manager | Platform-wide controls | Security scan workflow outputs, audit log monitoring | Credential/security incident runbook (planned under runbooks/) |
| Deployment Reliability | Branch protection + CI/CD governance | GitHub Actions workflows | Workflow run history, failed check trends | CI/CD failure triage runbook (planned under runbooks/) |
| AI Reliability Assurance | AI observability stack (Langfuse/OpenLIT) | AI Analyzer + Agent flows | Prompt trace quality, hallucination indicators, cost/latency trends | AI reliability incident runbook (planned under runbooks/) |

## Related Documentation
- docs/ARCHITECTURE.md
- docs/SDLC_AND_GOVERNANCE.md
- docs/WORKFLOW_CATALOG.md
