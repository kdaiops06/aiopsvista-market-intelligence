output "dataset_id" {
  description = "BigQuery dataset ID."
  value       = google_bigquery_dataset.ai_finops.dataset_id
}

output "dataset_self_link" {
  description = "Self link of the BigQuery dataset."
  value       = google_bigquery_dataset.ai_finops.self_link
}

output "table_id" {
  description = "BigQuery table ID for AI usage records."
  value       = google_bigquery_table.ai_usage.table_id
}

output "table_self_link" {
  description = "Self link of the ai_usage BigQuery table."
  value       = google_bigquery_table.ai_usage.self_link
}
