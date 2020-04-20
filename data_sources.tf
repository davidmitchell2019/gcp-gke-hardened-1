data "google_compute_zones" "available" {
  region = var.region
  status = "UP"
}

data "google_compute_image" "rhel7" {
  family  = "rhel-7"
  project = "rhel-cloud"
}

data "template_file" "automation_startup_script" {
  template = file(format("files/%s", var.automation_startup_filename))
}
