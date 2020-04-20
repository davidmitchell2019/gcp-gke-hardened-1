/**
*# Bootstrap
*
*Refer to README.md in parent folder.
*
*/

###
# Generate randon id to append to every created resource name
###
resource "random_id" "this" {
  byte_length = 3
}


###
# Make sure essential APIS are enabled
###
module "apis" {
  source = "../modules/gcp-project-services"

  project_id                  = var.project_id
  enable_apis                 = true
  disable_services_on_destroy = false

  activate_apis = [
    "cloudkms.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "storage-api.googleapis.com",
    "trafficdirector.googleapis.com",
  ]
}


###
# Create common labels
###
module "labels" {
  source = "../modules/gcp-labels"

  business_name          = var.business_name
  creator                = var.creator
  cost_code              = var.cost_code
  environment            = var.environment
  project_id             = var.project_id
  project_name           = var.project_name
  project_sponsor        = var.project_sponsor
  project_technical_lead = var.project_technical_lead
}

###
# Create GCS bucket for terraform state
###
resource "google_storage_bucket" "terraform" {
  name               = local.bucket_name
  bucket_policy_only = true
  force_destroy      = true
  labels             = module.labels.rendered
  location           = var.region

  encryption {
    default_kms_key_name = google_kms_crypto_key.crypto_key.self_link
  }

  versioning {
    enabled = true
  }

  lifecycle {
    ignore_changes = [labels]
  }
}

locals {
  bucket_name       = "${var.bucket_prefix}-${var.environment}-${random_id.this.hex}"
  kms_key_ring_name = "${var.kms_key_ring_prefix}-${random_id.this.hex}"
  kms_crypto_name   = "${var.kms_crypto_key_prefix}-${random_id.this.hex}"

  depends_on = [module.apis]
}
