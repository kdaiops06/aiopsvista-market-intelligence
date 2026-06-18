resource "google_monitoring_notification_channel" "budget_email" {
  project      = var.project_id
  display_name = "${var.budget_display_name}-email"
  type         = "email"
  labels = {
    email_address = var.notification_email
  }
  user_labels = {
    environment = var.labels.environment
    platform    = var.labels.platform
    managed_by  = var.labels.managed_by
    cost_center = var.labels.cost_center
  }
  enabled = true
}

resource "google_billing_budget" "this" {
  billing_account = var.billing_account_id
  display_name    = var.budget_display_name

  budget_filter {
    projects = ["projects/${var.project_id}"]
  }

  amount {
    specified_amount {
      currency_code = var.currency_code
      units         = tostring(var.monthly_budget_amount)
    }
  }

  dynamic "threshold_rules" {
    for_each = var.threshold_percents
    content {
      threshold_percent = threshold_rules.value
      spend_basis       = "CURRENT_SPEND"
    }
  }

  dynamic "threshold_rules" {
    for_each = var.enable_forecast_alert ? [var.forecast_threshold_percent] : []
    content {
      threshold_percent = threshold_rules.value
      spend_basis       = "FORECASTED_SPEND"
    }
  }

  all_updates_rule {
    monitoring_notification_channels = [google_monitoring_notification_channel.budget_email.name]
    disable_default_iam_recipients   = var.disable_default_iam_recipients
  }
}
