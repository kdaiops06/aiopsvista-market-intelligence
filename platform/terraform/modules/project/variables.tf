variable "project_name" {
  description = "Display name for the GCP project."
  type        = string
}

variable "project_id" {
  description = "Project ID for the GCP project."
  type        = string
}

variable "billing_account" {
  description = "Billing account ID to associate with the project."
  type        = string
}

variable "org_id" {
  description = "Organization ID for project placement."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "Folder ID for project placement when org-level placement is not used."
  type        = string
  default     = null
}

variable "activate_apis" {
  description = "List of APIs to enable in the project."
  type        = list(string)
  default = [
    "serviceusage.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "artifactregistry.googleapis.com",
  ]
}
