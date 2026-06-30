data "google_project" "this" {
  project_id = var.project_id
}

locals {
  repository_url = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.ai_usage_collector.repository_id}"
}

resource "google_service_account" "ai_usage_collector" {
  project      = var.project_id
  account_id   = var.service_account_id
  display_name = "AI Usage Collector"
}

resource "google_artifact_registry_repository" "ai_usage_collector" {
  project       = var.project_id
  location      = var.region
  repository_id = var.artifact_registry_repository_id
  format        = "DOCKER"
  description   = "Container images for the AI Usage Collector mock service."
  labels        = var.labels
}

resource "google_artifact_registry_repository_iam_member" "cloud_run_image_reader" {
  project    = var.project_id
  location   = google_artifact_registry_repository.ai_usage_collector.location
  repository = google_artifact_registry_repository.ai_usage_collector.repository_id
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:service-${data.google_project.this.number}@serverless-robot-prod.iam.gserviceaccount.com"
}

resource "google_bigquery_table_iam_member" "ai_usage_writer" {
  project    = var.project_id
  dataset_id = var.dataset_id
  table_id   = var.table_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.ai_usage_collector.email}"
}

resource "google_cloud_run_v2_service" "ai_usage_collector" {
  count    = var.container_image == "" ? 0 : 1
  project  = var.project_id
  name     = var.service_name
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  labels = var.labels
  deletion_protection = false

  template {
    service_account = google_service_account.ai_usage_collector.email
    timeout         = "${var.request_timeout_seconds}s"

    scaling {
      min_instance_count = 0
      max_instance_count = var.max_instance_count
    }

    max_instance_request_concurrency = var.concurrency

    containers {
      image = var.container_image

      ports {
        container_port = var.container_port
      }

      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
      }

      env {
        name  = "PROJECT_ID"
        value = var.project_id
      }

      env {
        name  = "DATASET_ID"
        value = var.dataset_id
      }

      env {
        name  = "TABLE_ID"
        value = var.table_id
      }

      env {
        name  = "DEFAULT_BATCH_SIZE"
        value = tostring(var.default_batch_size)
      }
    }
  }

  depends_on = [
    google_artifact_registry_repository_iam_member.cloud_run_image_reader,
    google_bigquery_table_iam_member.ai_usage_writer,
  ]
}

resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  count    = var.container_image == "" || !var.public_access ? 0 : 1
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.ai_usage_collector[0].name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_artifact_registry_repository_iam_member" "cloud_build_writer" {

  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.ai_usage_collector.repository_id

  role = "roles/artifactregistry.writer"

  member = "serviceAccount:${var.build_service_account}"
}


