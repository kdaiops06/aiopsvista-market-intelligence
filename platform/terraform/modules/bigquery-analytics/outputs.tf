output "sql_files_found" {
  description = "SQL files discovered for analytics deployment."

  value = local.sql_files
}

output "analytics_views" {
  description = "BigQuery analytics views managed by Terraform."

  value = {
    for k, v in google_bigquery_table.analytics_views :
    k => v.table_id
  }
}