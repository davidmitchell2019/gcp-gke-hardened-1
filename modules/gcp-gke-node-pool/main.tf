resource "google_container_node_pool" "default" {
  provider = google-beta
  name     = var.name
  location = var.location

  node_count = var.node_count
  cluster    = var.cluster

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    boot_disk_kms_key = var.boot_disk_kms_key
    disk_size_gb      = var.disk_size_gb
    disk_type         = var.disk_type
    image_type        = "COS"
    machine_type      = var.machine_type
    oauth_scopes      = var.oauth_scopes
    service_account   = var.service_account
    tags              = var.tags
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
    workload_metadata_config {
      node_metadata = "SECURE"
    }
  }

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}
