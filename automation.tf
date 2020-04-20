###
# Create automation host used for GKE cluster managment
###
module "automation" {
  source = "./modules/gcp-compute"

  boot_disk_size = var.boot_disk_size["automation"]
  boot_disk_type = var.boot_disk_type["automation"]
  image          = data.google_compute_image.rhel7.self_link
  common_labels  = module.labels.rendered
  kms_key        = var.kms_key
  machine_type   = var.machine_type["automation"]
  metadata = merge(local.common_metadata,
    {
      gke-cluster : module.gke.name
      nodetype : "automation"
      ostype : "linux"
  })
  metadata_startup_script = data.template_file.automation_startup_script.rendered
  name                    = local.automation_name
  network                 = module.vpc.name
  region                  = var.region
  service_account         = google_service_account.compute.email
  subnetwork              = module.private_subnet.name
  zone                    = data.google_compute_zones.available.names[0]
  //tags                    = ["automation"]
}
