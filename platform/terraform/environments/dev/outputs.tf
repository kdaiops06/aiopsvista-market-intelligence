output "project_id" {
  description = "Dev project ID."
  value       = module.project.project_id
}

output "shared_vpc_name" {
  description = "Shared VPC name."
  value       = module.shared_vpc.network_name
}

output "gke_cluster_name" {
  description = "GKE cluster name."
  value       = module.gke.cluster_name
}

output "workload_identity_pool" {
  description = "Workload Identity pool configured for the cluster."
  value       = module.gke.workload_identity_pool
}

output "budget_name" {
  description = "Configured monthly FinOps budget resource name."
  value       = module.budget.budget_name
}

output "budget_notification_channel" {
  description = "Notification channel used by budget alerts."
  value       = module.budget.notification_channel_name
}

output "budget_thresholds" {
  description = "Configured current spend alert thresholds for the budget."
  value       = module.budget.configured_thresholds
}

output "ai_finops_dataset_id" {
  description = "BigQuery dataset ID for AI FinOps usage data."
  value       = module.bigquery_ai_finops.dataset_id
}

output "ai_finops_table_id" {
  description = "BigQuery table ID for AI usage records."
  value       = module.bigquery_ai_finops.table_id
}
