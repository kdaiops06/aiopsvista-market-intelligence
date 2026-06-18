# Validation Findings

## 1. Billing Account Formatting Issue

**Problem**

The billing budget resource required the billing account in the full `billingAccounts/XXXXXX-XXXXXX-XXXXXX` format rather than a short or loosely formatted value.

**Root Cause**

The Billing Budgets API expects a billing-account resource identifier, and the first implementation path needed to be aligned with that resource format.

**Resolution**

The configuration was updated to use the correct billing account resource format in the budget workflow.

**Business Impact**

The budget resource could be created reliably and linked to the correct billing scope.

**Lessons Learned**

Billing integrations are sensitive to resource naming format and should be validated before deployment.

## 2. ADC Quota Project Requirement

**Problem**

Terraform failed to create the budget resource because local ADC lacked a quota project.

**Root Cause**

User ADC was used for the session, and the Billing Budgets API requires a quota project for those credentials.

**Resolution**

The ADC profile was configured with `aiopsvista-market-dev` as the quota project.

**Business Impact**

The budget workflow could authenticate successfully and proceed with resource creation.

**Lessons Learned**

When using ADC for GCP automation, quota project configuration must be treated as a deployment prerequisite.

## 3. Service Usage API Dependency

**Problem**

Terraform encountered `SERVICE_DISABLED` errors while managing project services.

**Root Cause**

`serviceusage.googleapis.com` was not enabled, so the provider could not read or manage `google_project_service` resources during plan/apply.

**Resolution**

Service Usage API was enabled and added to the managed API bootstrap list.

**Business Impact**

Terraform could manage the required APIs consistently during bootstrap and future rebuilds.

**Lessons Learned**

Project-service automation depends on Service Usage being available before service enablement is attempted.

## 4. Provider Hardening Requirements

**Problem**

The Google provider needed additional configuration to support billing-budget operations with user ADC credentials.

**Root Cause**

The initial provider block did not explicitly set billing-project behavior or user-project override behavior.

**Resolution**

Provider hardening was added in the dev environment so billing-budget calls use the correct project context.

**Business Impact**

The Terraform workflow became resilient for local development and repeatable demo execution.

**Lessons Learned**

Cloud provider blocks should be hardened for the exact authentication pattern used by the environment, not only for the idealized service-account path.
