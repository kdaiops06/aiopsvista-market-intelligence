# FinOps Budget Validation Evidence

## Objective

Validate that Terraform-managed budget guardrails are correctly provisioned for the AiOpsVista dev environment.

## Controls Validated

- Monthly budget exists and is active.
- Current spend threshold alerts are configured at 50%, 75%, 90%, and 100%.
- Forecast alert rule is configured.
- Email notification channel is attached to budget updates.
- Label governance strategy is configured in Terraform inputs.

## Validation Commands

```bash
cd platform/terraform/environments/dev
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
terraform output budget_name
terraform output budget_notification_channel
terraform output budget_thresholds
```

## CLI Verification (Optional)

```bash
gcloud billing budgets list --billing-account=XXXXXX-XXXXXX-XXXXXX
gcloud monitoring channels list --project=aiopsvista-market-dev
```

## Expected Results

| Check | Expected Result |
| --- | --- |
| Budget resource | Budget is present with configured monthly amount |
| Threshold rules | 0.5, 0.75, 0.9, 1.0 current spend thresholds exist |
| Forecast rule | Forecast threshold rule exists |
| Notification channel | Email channel exists and is bound to updates |
| Terraform outputs | Budget name, channel name, and thresholds are returned |

## Evidence Capture Artifacts

- `terraform plan` output with budget resources
- `terraform apply` output showing created resources
- `terraform output` values
- Optional `gcloud` command output for budget and channel listing

## Validation Outcome

- [ ] Budget guardrails successfully created
- [ ] Threshold alerts confirmed
- [ ] Forecast alert confirmed
- [ ] Notification channel confirmed
- [ ] Evidence archived under `docs/evidence/`
