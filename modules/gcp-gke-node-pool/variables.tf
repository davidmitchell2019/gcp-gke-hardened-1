variable "location" {
  type        = string
  description = "The location of the cluster"
}

variable "service_account" {
  type        = string
  description = "Service account to associate to the nodes"
  default     = null
}

variable "name" {
  description = "Node pool name"
}

variable "machine_type" {
  type    = string
  default = "n1-standard-2"
}

variable "min_node_count" {
  type    = number
  default = 1
}

variable "max_node_count" {
  type    = number
  default = 3
}

variable "disk_size_gb" {
  type    = number
  default = 10
}

variable "oauth_scopes" {
  type = list(string)

  default = [
    "storage-ro",
    "logging-write",
    "monitoring",
  ]
}

variable "tags" {
  type        = list(string)
  description = "Tags applied"
  default     = null
}

variable "node_count" {
  type        = number
  default     = 1
  description = "Initial node count"
}

variable "cluster" {
  type        = string
  description = "Cluster name"
}

variable "disk_type" {
  type        = string
  description = "Disk type for nodes"
  default     = "pd-standard"
}

variable "boot_disk_kms_key" {
  type        = string
  description = "KMS key for boot disk"
  default     = null
}
