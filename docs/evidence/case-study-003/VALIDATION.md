# Case Study #003 — Validation Record

## AI FinOps Foundation: BigQuery Dataset and Table

### Validation Steps

```bash
cd platform/terraform/environments/dev

# 1. Initialize modules
terraform init

# 2. Validate configuration
terraform validate

# 3. Review plan
terraform plan -var-file=terraform.tfvars

# 4. Apply
terraform apply -var-file=terraform.tfvars

# 5. Inspect dataset
bq show aiopsvista-market-dev:ai_finops

# 6. Inspect table
bq show aiopsvista-market-dev:ai_finops.ai_usage

# 7. Verify outputs
terraform output ai_finops_dataset_id
terraform output ai_finops_table_id

# 8. Destroy (lifecycle validation)
terraform destroy -var-file=terraform.tfvars

# 9. Re-apply (reproducibility validation)
terraform apply -var-file=terraform.tfvars
```

### Success Criteria

- [ ] `terraform init` — Success
- [ ] `terraform validate` — Success
- [ ] `terraform plan` — No errors, BigQuery resources in plan
- [ ] `terraform apply` — Dataset and table created
- [ ] `bq show` dataset — Dataset visible in Cloud Console and CLI
- [ ] `bq show` table — Table schema matches expected schema
- [ ] `terraform output` — Dataset ID and table ID returned
- [ ] `terraform destroy` — Dataset and table removed cleanly
- [ ] `terraform apply` again — Dataset and table recreated

### Validation Results (To Be Completed After Apply)

| Check | Result | Notes |
| --- | --- | --- |
| `terraform init` | | |
| `terraform validate` | | |
| `terraform plan` | | |
| `terraform apply` | | |
| Dataset visible in Cloud Console | | |
| Table schema correct | | |
| Labels applied | | |
| Partitioning configured | | |
| Clustering configured | | |
| `terraform destroy` | | |
| `terraform apply` re-deploy | | |

### Expected Terraform Outputs

```
ai_finops_dataset_id = "ai_finops"
ai_finops_table_id   = "ai_usage"
```

### Expected bq Commands

```bash
bq show --format=prettyjson aiopsvista-market-dev:ai_finops
bq show --format=prettyjson aiopsvista-market-dev:ai_finops.ai_usage
```
