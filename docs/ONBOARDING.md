# Engineering Onboarding Guide

## 1. Project Vision
AiOpsVista Market Intelligence Platform is a production-inspired AI Reliability Engineering reference platform focused on operability, observability, and consulting-grade architecture quality.

Start here:
- docs/PROJECT_CONTEXT.md
- docs/ARCHITECTURE.md

## 2. Repository Structure
Understand repository layout before implementation work:
- docs/REPOSITORY_MAP.md

## 3. Engineering Standards
All contributors must align with repository governance and quality standards:
- docs/ENGINEERING_STANDARDS.md
- docs/SDLC_AND_GOVERNANCE.md

## 4. Branching Strategy
- Never commit directly to main.
- Work from feature/<scope>-<description> branches.
- Keep branches small and focused for fast reviews.

Reference:
- docs/SDLC_AND_GOVERNANCE.md

## 5. Pull Request Process
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
- .github/pull_request_template.md

## 6. Development Workflow
1. Create a feature branch from main.
2. Implement changes with documentation updates.
3. Validate locally where possible.
4. Open PR and address review feedback.
5. Merge after status checks and approvals.

## 7. CI/CD Overview
Workflow inventory and behavior:
- docs/WORKFLOW_CATALOG.md

Governance controls:
- docs/SDLC_AND_GOVERNANCE.md

## 8. Architecture Documents
Primary architecture references:
- docs/ARCHITECTURE.md
- architecture/executive-view.md
- architecture/platform-architecture.md
- architecture/ai-sre-architecture.md

## 9. First Contribution Guide
Suggested first contribution path:
1. Read project context and architecture docs.
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
