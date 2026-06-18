locals {
  activate_apis = [
    "serviceusage.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "artifactregistry.googleapis.com",
    "billingbudgets.googleapis.com",
    "monitoring.googleapis.com",
    "bigquery.googleapis.com",
  ]
}

module "project" {
  source = "../../modules/project"

  project_name    = var.project_name
  project_id      = var.project_id
  billing_account = var.billing_account
  org_id          = var.org_id
  folder_id       = var.folder_id
  activate_apis   = local.activate_apis
}

module "shared_vpc" {
  source = "../../modules/shared-vpc"

  project_id   = module.project.project_id
  region       = var.region
  network_name = var.network_name

  depends_on = [module.project]
}

module "cloud_nat" {
  source = "../../modules/cloud-nat"

  project_id        = module.project.project_id
  region            = var.region
  network_self_link = module.shared_vpc.network_self_link
  router_name       = "aiopsvista-dev-router"
  nat_name          = "aiopsvista-dev-nat"

  depends_on = [module.shared_vpc]
}

module "gke" {
  source = "../../modules/gke"

  project_id                    = module.project.project_id
  location                      = var.gke_zone
  cluster_name                  = "aiopsvista-dev-gke"
  network_self_link             = module.shared_vpc.network_self_link
  subnetwork_self_link          = module.shared_vpc.subnet_self_links["gke-subnet"]
  pods_secondary_range_name     = "gke-pods-range"
  services_secondary_range_name = "gke-services-range"
  release_channel               = "REGULAR"
  # node_service_account          = var.node_service_account
  node_service_account       = module.project.gke_node_service_account_email
  master_authorized_networks = var.master_authorized_networks
  application_pool_enabled   = false

  depends_on = [module.cloud_nat]
}

module "budget" {
  source = "../../modules/budget"

  project_id                     = module.project.project_id
  billing_account_id             = var.billing_account
  budget_display_name            = var.budget_display_name
  monthly_budget_amount          = var.monthly_budget_amount
  currency_code                  = var.budget_currency_code
  threshold_percents             = var.budget_threshold_percents
  enable_forecast_alert          = var.enable_forecast_alert
  forecast_threshold_percent     = var.forecast_threshold_percent
  notification_email             = var.budget_notification_email
  disable_default_iam_recipients = var.disable_default_iam_recipients
  labels                         = var.labels

  depends_on = [module.project]
}

module "bigquery_ai_finops" {
  source = "../../modules/bigquery-ai-finops"

  project_id                 = module.project.project_id
  dataset_id                 = var.ai_finops_dataset_id
  location                   = var.ai_finops_location
  delete_contents_on_destroy = var.ai_finops_delete_contents_on_destroy
  labels                     = var.ai_finops_labels

  depends_on = [module.project]
}
