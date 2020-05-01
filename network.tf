###
# Create VPC
###
module "vpc" {
  source = "./modules/gcp-vpc"

  common_labels      = module.labels.rendered
  create_nat_gateway = var.create_nat_gateway
  nat_router_name    = local.nat_router_name
  project_id         = var.project_id
  region             = var.region
  router_name        = local.router_name
  vpc_name           = local.vpc_name
}

###
# Create subnetworks
# https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters
# Private Google Access makes it possible for private nodes to pull container images from Google Container Registry, and to send logs to Stackdriver.
###
module "private_subnet" {
  source = "./modules/gcp-subnet"
  providers = {
    google = google-beta
  }

  enable_flow_logs         = var.enable_flow_logs
  ip_cidr_range            = cidrsubnet(var.network_cidr, 8, 1)
  network                  = module.vpc.name
  private_ip_google_access = true
  region                   = var.region
  subnet_name              = format("%s-%s", "private-net", random_id.this.hex)
}

module "gke_subnet" {
  source = "./modules/gcp-subnet"
  providers = {
    google = google-beta
  }

  enable_flow_logs         = var.enable_flow_logs
  ip_cidr_range            = var.gke_subnetwork["cidr"]
  network                  = module.vpc.name
  private_ip_google_access = true
  region                   = var.region
  subnet_name              = format("%s-%s", var.gke_subnetwork["name"], random_id.this.hex)
  # Kubernetes Secondary Networking
  secondary_ip_ranges = [
    {
      range_name    = format("%s-%s", var.gke_subnetwork["pod_name"], random_id.this.hex)
      ip_cidr_range = var.gke_subnetwork["pod_cidr"]
    },
    {
      range_name    = format("%s-%s", var.gke_subnetwork["service_name"], random_id.this.hex)
      ip_cidr_range = var.gke_subnetwork["service_cidr"]
    }
  ]
}

module "ilb_subnet" {
  source = "./modules/gcp-subnet"
  providers = {
    google = google-beta
  }

  enable_flow_logs         = var.enable_flow_logs
  ip_cidr_range            = cidrsubnet(var.network_cidr, 8, 2)
  network                  = module.vpc.name
  private_ip_google_access = false
  purpose                  = "INTERNAL_HTTPS_LOAD_BALANCER"
  region                   = var.region
  role                     = "ACTIVE"
  subnet_name              = format("%s-%s", "ilb-net", random_id.this.hex)
}

###
# Enable IAP access for SSH access
###
resource "google_compute_firewall" "remote-mgmt-iap" {
  name        = "remote-mgmt-iap-${random_id.this.hex}"
  network     = module.vpc.name
  description = "Allow inbound connections from iap"
  direction   = "INGRESS"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  source_ranges = var.iap_source_cidrs
}
