locals {
  sql_files = fileset(var.views_directory, "*.sql")
}

resource "google_bigquery_table" "analytics_views" {

  for_each = {
    for file in local.sql_files :
    file => file
  }

  project             = var.project_id
  dataset_id          = var.dataset_id

  table_id = "vw_${trimsuffix(each.key, ".sql")}"

  deletion_protection = false

  labels = var.labels

  view {

    query = templatefile(
      "${var.views_directory}/${each.key}",
      {
        project_id = var.project_id
        dataset_id = var.dataset_id
      }
    )

    use_legacy_sql = false
  }
}