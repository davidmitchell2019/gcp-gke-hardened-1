variable "region" {
  type        = string
  description = "The region to host the cluster in"
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "service_account" {
  type        = string
  description = "Service account to associate to the nodes"
}

variable "name" {
  description = "The cluster name"
}

variable "min_master_version" {
  type    = string
  default = null
}

variable "master_authorized_cidrs" {
  type = list(object({
    name = string
    cidr = string
  }))
}

variable "daily_maintenance_start" {
  type    = string
  default = "02:00"
}

variable "oauth_scopes" {
  type = list(string)

  default = [
    "storage-ro",
    "logging-write",
    "monitoring",
  ]
}

variable "cluster_secondary_range_name" {
  type = string
}

variable "services_secondary_range_name" {
  type = string
}

variable "master_ipv4_cidr_block" {
  type = string
}

variable "common_labels" {
  type        = map(string)
  description = "Labels applied"
  default     = null
}

variable "tags" {
  type        = list(string)
  description = "Tags applied"
  default     = null
}

variable "horizontal_pod_autoscaling_enable" {
  type        = bool
  description = "Enable horizontal pod autoscaling addon"
  default     = true
}

variable "http_load_balancing_enable" {
  type        = bool
  description = "Enable httpload balancer addon"
  default     = true
}

variable "network_policy_enable" {
  type        = bool
  description = "Enable network policy addon"
  default     = false
}

variable "logging_service" {
  type        = string
  description = "The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none"
  default     = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  type        = string
  description = "The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none"
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "network_policy_provider" {
  type        = string
  description = "The network policy provider."
  default     = "CALICO"
}

variable "istio_permissive_mtls" {
  type    = string
  default = "false"
}

variable "istio_enable" {
  type    = string
  default = "false"
}

variable "node_locations" {
  type        = list(string)
  description = "Locations to deploy the node pools"
}

variable "release_channel" {
  type        = string
  default     = "STABLE"
  description = "Specify the release channel"
}