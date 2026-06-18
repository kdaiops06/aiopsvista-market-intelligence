variable "project_id" {
  description = "Project ID for dev environment."
  type        = string
  default     = "aiopsvista-market-dev"
}

variable "project_name" {
  description = "Display name for the dev project."
  type        = string
  default     = "AiOpsVista Market Dev"
}

variable "billing_account" {
  description = "Billing account for project creation."
  type        = string
}

variable "labels" {
  description = "Standard governance labels for this environment."
  type = object({
    environment = string
    platform    = string
    managed_by  = string
    cost_center = string
  })
  default = {
    environment = "dev"
    platform    = "aiopsvista"
    managed_by  = "terraform"
    cost_center = "demo"
  }
}

variable "org_id" {
  description = "Organization ID for project creation."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "Folder ID for project creation."
  type        = string
  default     = null
}

variable "region" {
  description = "Deployment region."
  type        = string
  default     = "us-central1"
}

variable "gke_zone" {
  description = "Zonal location for the dev GKE cluster."
  type        = string
  default     = "us-central1-a"
}

variable "network_name" {
  description = "Shared VPC name."
  type        = string
  default     = "aiopsvista-shared-vpc"
}

# variable "node_service_account" {
#   description = "Node service account email for GKE pools."
#   type        = string
# }

variable "master_authorized_networks" {
  description = "Authorized CIDR blocks for GKE control plane access."
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "budget_display_name" {
  description = "Display name for the FinOps monthly budget policy."
  type        = string
  default     = "aiopsvista-dev-monthly-budget"
}

variable "monthly_budget_amount" {
  description = "Monthly budget amount in whole currency units."
  type        = number
  default     = 100
}

variable "budget_currency_code" {
  description = "Currency code for the monthly budget."
  type        = string
  default     = "USD"
}

variable "budget_threshold_percents" {
  description = "Current spend threshold percentages for budget alerts."
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 1.0]
}

variable "enable_forecast_alert" {
  description = "Enable projected spend alerts for the budget."
  type        = bool
  default     = true
}

variable "forecast_threshold_percent" {
  description = "Forecast alert threshold percentage."
  type        = number
  default     = 1.0
}

variable "budget_notification_email" {
  description = "Email address to receive budget and forecast alerts."
  type        = string
}

variable "disable_default_iam_recipients" {
  description = "Disable default IAM recipients for budget notifications."
  type        = bool
  default     = false
}

variable "ai_finops_dataset_id" {
  description = "BigQuery dataset ID for AI FinOps usage data."
  type        = string
  default     = "ai_finops"
}

variable "ai_finops_location" {
  description = "BigQuery dataset location."
  type        = string
  default     = "US"
}

variable "ai_finops_delete_contents_on_destroy" {
  description = "Delete dataset contents on destroy. Set true for dev environments."
  type        = bool
  default     = true
}

variable "ai_finops_labels" {
  description = "Labels for the AI FinOps BigQuery dataset and table."
  type        = map(string)
  default = {
    environment = "dev"
    platform    = "aiopsvista"
    managed_by  = "terraform"
    cost_center = "ai-finops"
  }
}
