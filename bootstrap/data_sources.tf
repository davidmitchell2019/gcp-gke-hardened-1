data "google_project" "current" {}

data "google_storage_project_service_account" "gcs_account" {
  project = var.project_id

  depends_on = [module.apis]
}
