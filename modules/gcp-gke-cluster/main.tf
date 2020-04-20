resource "google_container_cluster" "default" {
  provider       = google-beta
  name           = var.name
  location       = var.region
  node_locations = var.node_locations

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true

  node_pool {
    name               = "default-pool"
    initial_node_count = 0
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.daily_maintenance_start
    }
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # use latest version, unless a specific version requested
  min_master_version = var.min_master_version

  # specifying node_config here causes terraform to re-create the cluster on EVERY execution

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_cidrs
      content {
        cidr_block   = cidr_blocks.value["cidr"]
        display_name = cidr_blocks.value["name"]
      }
    }
  }

  network    = var.network
  subnetwork = var.subnetwork

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }
  private_cluster_config {
    enable_private_endpoint = "true"
    enable_private_nodes    = "true"
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  release_channel {
    channel = var.release_channel
  }

  pod_security_policy_config {
    enabled = false
  }

  enable_shielded_nodes = true

  addons_config {
    istio_config {
      disabled = ! var.istio_enable
      auth     = var.istio_permissive_mtls == "true" ? "AUTH_NONE" : "AUTH_MUTUAL_TLS"
    }

    http_load_balancing {
      disabled = ! var.http_load_balancing_enable
    }

    horizontal_pod_autoscaling {
      disabled = ! var.horizontal_pod_autoscaling_enable
    }

    network_policy_config {
      disabled = ! var.network_policy_enable
    }
  }

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  dynamic "network_policy" {
    for_each = local.cluster_network_policy

    content {
      enabled  = network_policy.value.enabled
      provider = network_policy.value.provider
    }
  }

  resource_labels = var.common_labels

  lifecycle {
    ignore_changes = [node_pool, initial_node_count, resource_labels]
  }

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

locals {
  cluster_network_policy = var.network_policy_enable ? [{
    enabled  = true
    provider = var.network_policy_provider
    }] : [{
    enabled  = false
    provider = null
  }]
}
