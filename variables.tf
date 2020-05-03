variable "project_id" {
  type        = string
  description = "Project ID to create resources"
}

variable "vpc_prefix" {
  type        = string
  default     = "vpc"
  description = "VPC name prefix"
}

variable "network_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Network CIDR"
}

variable "region" {
  type        = string
  description = "Region to create resources"
}

variable "router_prefix" {
  type        = string
  default     = "rtr"
  description = "Router name prefix"
}

variable "nat_router_prefix" {
  type        = string
  default     = "nat"
  description = "NAT router name prefix"
}

variable "create_nat_gateway" {
  type        = bool
  default     = true
  description = "Create nat gatway for internal servers"
}

variable "enable_flow_logs" {
  type        = string
  default     = false
  description = "Enable flow logging"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment name"
}

variable "creator" {
  type        = string
  description = "Creator name"
}

variable "automation_prefix" {
  type        = string
  default     = "automation"
  description = "Automation name prefix"
}

variable "mgmt_source_cidr" {
  type        = list(string)
  default     = null
  description = "Management CIDR for remote access"
}

variable "firewall_rule_prefix" {
  type        = string
  default     = "remote-mgmt"
  description = "Firewall rule prefix"
}

variable "automation_startup_filename" {
  type        = string
  default     = "automation_bootstrap.sh"
  description = "Metadata startup script"
}

variable "machine_type" {
  type = map(string)
  default = {
    automation : "g1-small"
    gke : "n1-standard-1"
  }
  description = "Machine type"
}

variable "boot_disk_size" {
  type = object({
    automation = number
  })
  default = {
    automation = 20
  }
  description = "Boot disk size"
}

variable "boot_disk_type" {
  type = object({
    automation = string
  })
  default = {
    automation = "pd-standard"
  }
  description = "Boot disk type"
}

variable "automation_image" {
  type        = string
  default     = null
  description = "Automation image URI"
}

variable "kms_key" {
  type        = string
  default     = null
  description = "KMS key URI"
}

variable "iap_source_cidrs" {
  type        = list(string)
  default     = ["35.235.240.0/20"]
  description = "IAP cidrs"
}

variable "compute_service_account_prefix" {
  type        = string
  default     = "compute-sa"
  description = "Service account for compute instances"
}

variable "gke_service_account_prefix" {
  type        = string
  default     = "gke-sa"
  description = "Service account for gke instances"
}

variable "gke_subnetwork" {
  type = object({
    name         = string
    cidr         = string
    pod_cidr     = string
    pod_name     = string
    service_cidr = string
    service_name = string
  })
  description = "Subnetworks for GKE"
}

variable "gke_master_ipv4_cidr_block" {
  type = string
}

variable "gke_cluster_name_prefix" {
  type    = string
  default = "gke"
}

variable "gke_pool_name_prefix" {
  type    = string
  default = "pool"
}

variable "gke_istio_enable" {
  type    = bool
  default = false
}

variable "gke_istio_permissive_mtls" {
  type    = bool
  default = false
}

variable "gke_network_policy_enable" {
  type    = bool
  default = false
}

variable "gke_release_channel" {
  type        = string
  default     = "STABLE"
  description = "Specify the release channel"
}
variable "project_name" {
  type = string
}

variable "business_name" {
  type = string
}

variable "cost_code" {
  type = string
}

variable "project_sponsor" {
  type = string
}

variable "project_technical_lead" {
  type = string
}
