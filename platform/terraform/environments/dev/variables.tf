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
