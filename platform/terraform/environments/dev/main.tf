locals {
  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "artifactregistry.googleapis.com",
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
