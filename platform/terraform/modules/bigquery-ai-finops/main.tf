resource "google_bigquery_dataset" "ai_finops" {
  project                    = var.project_id
  dataset_id                 = var.dataset_id
  friendly_name              = var.dataset_friendly_name
  description                = var.dataset_description
  location                   = var.location
  delete_contents_on_destroy = var.delete_contents_on_destroy

  labels = var.labels
}

resource "google_bigquery_table" "ai_usage" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.ai_finops.dataset_id
  table_id            = "ai_usage"
  deletion_protection = false

  description = "Normalized AI cost and usage records for FinOps attribution and observability."

  labels = var.labels

  time_partitioning {
    type  = "DAY"
    field = "event_timestamp"
  }

  clustering = ["provider", "model", "environment"]

  schema = jsonencode([
    {
      name        = "event_timestamp"
      type        = "TIMESTAMP"
      mode        = "REQUIRED"
      description = "UTC timestamp when the AI usage event occurred."
    },
    {
      name        = "provider"
      type        = "STRING"
      mode        = "REQUIRED"
      description = "AI provider name, e.g. openai, gemini, anthropic, github-copilot."
    },
    {
      name        = "model"
      type        = "STRING"
      mode        = "REQUIRED"
      description = "Model identifier, e.g. gpt-4o, gemini-1.5-pro, claude-3-5-sonnet."
    },
    {
      name        = "user_id"
      type        = "STRING"
      mode        = "NULLABLE"
      description = "Identifier of the user or service that initiated the request."
    },
    {
      name        = "project_id"
      type        = "STRING"
      mode        = "NULLABLE"
      description = "GCP project or internal project identifier for cost attribution."
    },
    {
      name        = "agent_name"
      type        = "STRING"
      mode        = "NULLABLE"
      description = "Name of the AI agent if the request originated from an agent workflow."
    },
    {
      name        = "request_count"
      type        = "INTEGER"
      mode        = "REQUIRED"
      description = "Number of API requests represented by this record."
    },
    {
      name        = "input_tokens"
      type        = "INTEGER"
      mode        = "NULLABLE"
      description = "Number of input tokens consumed."
    },
    {
      name        = "output_tokens"
      type        = "INTEGER"
      mode        = "NULLABLE"
      description = "Number of output tokens generated."
    },
    {
      name        = "total_tokens"
      type        = "INTEGER"
      mode        = "NULLABLE"
      description = "Total token count (input plus output)."
    },
    {
      name        = "estimated_cost"
      type        = "FLOAT64"
      mode        = "NULLABLE"
      description = "Estimated cost in USD based on provider pricing at time of recording."
    },
    {
      name        = "latency_ms"
      type        = "INTEGER"
      mode        = "NULLABLE"
      description = "End-to-end request latency in milliseconds."
    },
    {
      name        = "environment"
      type        = "STRING"
      mode        = "REQUIRED"
      description = "Deployment environment: dev, staging, or prod."
    }
  ])
}
