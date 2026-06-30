variable "project_id" {
  description = "Google Cloud Project ID."
  type        = string
}

variable "dataset_id" {
  description = "BigQuery dataset containing analytics views."
  type        = string
}

variable "views_directory" {
  description = "Directory containing SQL view definitions."
  type        = string
}

variable "labels" {
  description = "Labels applied to BigQuery views."
  type        = map(string)
  default     = {}
}