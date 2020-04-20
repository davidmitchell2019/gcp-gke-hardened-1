###
# Generate randon id to append to every created resource name
###
resource "random_id" "this" {
  byte_length = 3
}

###
# Fetch available zones in region
###
data "google_compute_zones" "zones" {
  provider = google

  project = var.project_id
  region  = var.region
}

###
# Fetch 3 available zones from region
###
resource "random_shuffle" "zones" {
  input        = data.google_compute_zones.zones.names
  result_count = 3
}

###
# Create common labels
###
module "labels" {
  source = "./modules/gcp-labels"

  project_id             = var.project_id
  environment            = var.environment
  creator                = var.creator
  project_name           = var.project_name
  business_name          = var.business_name
  cost_code              = var.cost_code
  project_sponsor        = var.project_sponsor
  project_technical_lead = var.project_technical_lead
}

###
# Create unique names for resources
###
locals {
  vpc_name                = format("%s-%s", var.vpc_prefix, random_id.this.hex)
  router_name             = format("%s-%s", var.router_prefix, random_id.this.hex)
  nat_router_name         = format("%s-%s", var.nat_router_prefix, random_id.this.hex)
  automation_name         = format("%s-%s", var.automation_prefix, random_id.this.hex)
  compute_service_account = format("%s-%s", var.compute_service_account_prefix, random_id.this.hex)
  gke_service_account     = format("%s-%s", var.gke_service_account_prefix, random_id.this.hex)
  gke_cluster_name        = format("%s-%s", var.gke_cluster_name_prefix, random_id.this.hex)
  gke_node_pool_name      = format("%s-%s", var.gke_pool_name_prefix, random_id.this.hex)
  gke_node_locations      = sort(random_shuffle.zones.result)

  common_metadata = {
    environment = var.environment
    project     = var.project_id
    workspace   = terraform.workspace
  }
}
