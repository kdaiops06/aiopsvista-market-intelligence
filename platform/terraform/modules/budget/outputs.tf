output "budget_name" {
  description = "Resource name of the configured budget."
  value       = google_billing_budget.this.name
}

output "budget_display_name" {
  description = "Display name of the configured budget."
  value       = google_billing_budget.this.display_name
}

output "notification_channel_name" {
  description = "Monitoring notification channel used for budget alerts."
  value       = google_monitoring_notification_channel.budget_email.name
}

output "configured_thresholds" {
  description = "Current spend alert thresholds configured for the budget."
  value       = var.threshold_percents
}
