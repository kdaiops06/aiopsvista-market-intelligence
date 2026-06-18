# Budget Module

## Purpose
Creates FinOps budget guardrails for a GCP project with email-based alerting.

## Features
- Monthly budget configuration
- Current spend threshold alerts
- Forecast threshold alert
- Email notification channel
- Standardized governance labels

## Default Thresholds
- 50%
- 75%
- 90%
- 100%

## Inputs
See `variables.tf` for configurable values.

## Outputs
- `budget_name`
- `budget_display_name`
- `notification_channel_name`
- `configured_thresholds`
