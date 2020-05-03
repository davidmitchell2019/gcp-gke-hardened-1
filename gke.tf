###
# Create gke cluster
###
module "gke" {
  source = "./modules/gcp-gke-cluster"

  # enable master authorized access to local private subnet
  master_authorized_cidrs = [
    {
      cidr : module.private_subnet.ip_cidr_range
      name : module.private_subnet.name
    }
  ]

  master_ipv4_cidr_block        = var.gke_master_ipv4_cidr_block
  name                          = local.gke_cluster_name
  network                       = module.vpc.name
  subnetwork                    = module.gke_subnet.name
  service_account               = google_service_account.gke.email
  common_labels                 = module.labels.rendered
  cluster_secondary_range_name  = module.gke_subnet.secondary_ip_ranges[0]["range_name"]
  services_secondary_range_name = module.gke_subnet.secondary_ip_ranges[1]["range_name"]
  istio_enable                  = var.gke_istio_enable
  istio_permissive_mtls         = var.gke_istio_permissive_mtls
  network_policy_enable         = var.gke_network_policy_enable
  node_locations                = local.gke_node_locations
  region                        = var.region
  release_channel               = var.gke_release_channel
}

###
# Create gke node pool
###
module "gke_node_pool" {
  source = "./modules/gcp-gke-node-pool"

  cluster           = module.gke.name
  boot_disk_kms_key = var.kms_key
  location          = var.region
  name              = local.gke_node_pool_name
  machine_type      = var.machine_type["gke"]
}
