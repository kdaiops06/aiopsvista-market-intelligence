# Engineering Onboarding Guide

## Project Vision
AiOpsVista Intelligence Platform is a production-inspired AI Reliability Engineering, AI FinOps, Platform Engineering, Observability, and Agent Operations reference platform.

Start here:
- [Documentation Hub](README.md)
- [Project Context](PROJECT_CONTEXT.md)
- [Architecture Blueprint](ARCHITECTURE.md)

## Repository Structure
Understand repository layout before implementation work:
- [Repository Map](REPOSITORY_MAP.md)
- [Case Studies](case-studies/README.md)
- [Evidence](evidence/README.md)

## Engineering Standards
All contributors must align with repository governance and quality standards:
- [Engineering Standards](ENGINEERING_STANDARDS.md)
- [SDLC and Governance](SDLC_AND_GOVERNANCE.md)

## Branching Strategy
- Never commit directly to main.
- Work from feature/<scope>-<description> branches.
- Keep branches small and focused for fast reviews.

Reference:
- [SDLC and Governance](SDLC_AND_GOVERNANCE.md)

## Pull Request Process
Each PR must include:
- Objective
- Scope
- Architecture Impact
- Reliability Impact
- Security Impact
- Validation Performed
- Rollback Plan
- Definition of Done

Template:
- [.github/pull_request_template.md](../.github/pull_request_template.md)

## Development Workflow
1. Create a feature branch from main.
2. Implement changes with documentation updates.
3. Validate locally where possible.
4. Open PR and address review feedback.
5. Merge after status checks and approvals.

## CI/CD Overview
Workflow inventory and behavior:
- [Workflow Catalog](WORKFLOW_CATALOG.md)

Governance controls:
- [SDLC and Governance](SDLC_AND_GOVERNANCE.md)

## Architecture Documents
Primary architecture references:
- [Architecture Blueprint](ARCHITECTURE.md)
- [Executive View](../architecture/executive-view.md)
- [Platform Architecture](../architecture/platform-architecture.md)
- [AI SRE Architecture](../architecture/ai-sre-architecture.md)

## First Contribution Guide
Suggested first contribution path:
1. Read the documentation hub, project context, and architecture docs.
2. Pick a small documentation or runbook enhancement.
3. Submit a small PR using the template.
4. Ensure related docs are cross-referenced.
5. Add any operational implications to roadmap/runbooks.

## Audience Notes
This onboarding guide is designed for:
- New engineers
- Contributors
- AI coding assistants
- Consultants
