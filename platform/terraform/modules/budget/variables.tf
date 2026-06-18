variable "project_id" {
  description = "Project ID used by the budget filter and notification channel."
  type        = string
}

variable "billing_account_id" {
  description = "Billing account resource name in format billingAccounts/XXXXXX-XXXXXX-XXXXXX."
  type        = string
}

variable "budget_display_name" {
  description = "Display name for the budget policy."
  type        = string
}

variable "monthly_budget_amount" {
  description = "Monthly budget amount in whole currency units."
  type        = number
}

variable "currency_code" {
  description = "Currency code for the budget amount."
  type        = string
  default     = "USD"
}

variable "threshold_percents" {
  description = "Threshold percentages for current spend alerts."
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 1.0]
}

variable "enable_forecast_alert" {
  description = "Whether to send forecast-based budget alerts."
  type        = bool
  default     = true
}

variable "forecast_threshold_percent" {
  description = "Forecast threshold percentage for projected spend alerts."
  type        = number
  default     = 1.0
}

variable "notification_email" {
  description = "Email address for budget alert notifications."
  type        = string
}

variable "disable_default_iam_recipients" {
  description = "Disable default IAM recipients for budget notifications."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Standard FinOps labels for governance and traceability."
  type = object({
    environment = string
    platform    = string
    managed_by  = string
    cost_center = string
  })
}
