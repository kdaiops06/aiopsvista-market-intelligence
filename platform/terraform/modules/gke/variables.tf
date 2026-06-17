variable "project_id" {
  description = "Project ID where the cluster is created."
  type        = string
}

variable "location" {
  description = "Zonal or regional location for the GKE cluster and node pools."
  type        = string
}

variable "cluster_name" {
  description = "GKE cluster name."
  type        = string
  default     = "aiopsvista-dev-gke"
}

variable "network_self_link" {
  description = "Self link of VPC network."
  type        = string
}

variable "subnetwork_self_link" {
  description = "Self link of subnet for nodes."
  type        = string
}

variable "pods_secondary_range_name" {
  description = "Secondary range name for pods."
  type        = string
  default     = "gke-pods-range"
}

variable "services_secondary_range_name" {
  description = "Secondary range name for services."
  type        = string
  default     = "gke-services-range"
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block used for private control plane endpoint."
  type        = string
  default     = "172.16.0.0/28"
}

variable "release_channel" {
  description = "GKE release channel."
  type        = string
  default     = "REGULAR"
}

variable "master_authorized_networks" {
  description = "Authorized CIDR blocks for control plane access."
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "node_service_account" {
  description = "Service account email for GKE nodes."
  type        = string
}

variable "system_pool_machine_type" {
  description = "Machine type for system pool."
  type        = string
  default     = "e2-small"
}

variable "system_pool_min_nodes" {
  description = "Minimum nodes for system pool."
  type        = number
  default     = 1
}

variable "system_pool_max_nodes" {
  description = "Maximum nodes for system pool."
  type        = number
  default     = 1
}

variable "application_pool_machine_type" {
  description = "Machine type for application pool."
  type        = string
  default     = "e2-medium"
}

variable "application_pool_enabled" {
  description = "Whether to create the application node pool."
  type        = bool
  default     = false
}

variable "application_pool_min_nodes" {
  description = "Minimum nodes for application pool."
  type        = number
  default     = 1
}

variable "application_pool_max_nodes" {
  description = "Maximum nodes for application pool."
  type        = number
  default     = 5
}
