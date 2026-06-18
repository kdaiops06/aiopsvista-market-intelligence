variable "project_id" {
  description = "GCP project ID where the BigQuery dataset and table are created."
  type        = string
}

variable "dataset_id" {
  description = "BigQuery dataset ID for AI FinOps usage data."
  type        = string
  default     = "ai_finops"
}

variable "dataset_friendly_name" {
  description = "Human-readable name for the BigQuery dataset."
  type        = string
  default     = "AI FinOps"
}

variable "dataset_description" {
  description = "Description of the BigQuery dataset purpose."
  type        = string
  default     = "AI cost and usage observability dataset for FinOps attribution and analytics."
}

variable "location" {
  description = "BigQuery dataset location."
  type        = string
  default     = "US"
}

variable "delete_contents_on_destroy" {
  description = "Whether to delete all tables when the dataset is destroyed. Set true for dev environments."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels to apply to the BigQuery dataset and table."
  type        = map(string)
  default = {
    environment = "dev"
    platform    = "aiopsvista"
    managed_by  = "terraform"
    cost_center = "ai-finops"
  }
}
