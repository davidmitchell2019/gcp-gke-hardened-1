###
# create compute service account for compute instances
###
resource "google_service_account" "compute" {
  account_id   = local.compute_service_account
  display_name = "${local.compute_service_account}-service account"
  project      = var.project_id
}

###
# assign gke admin permissions
###
resource "google_project_iam_member" "compute_gke" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = format("serviceAccount:%s", google_service_account.compute.email)
}
###
# create compute service account for gke instances
###
resource "google_service_account" "gke" {
  account_id   = local.gke_service_account
  display_name = "${local.gke_service_account}-service account"
  project      = var.project_id
}

###
# assign logging permissions
###
resource "google_project_iam_member" "gke_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = format("serviceAccount:%s", google_service_account.gke.email)
}

###
# assign monitoring permissions
###
resource "google_project_iam_member" "gke_monitoring_1" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = format("serviceAccount:%s", google_service_account.gke.email)
}

resource "google_project_iam_member" "gke_monitoring_2" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = format("serviceAccount:%s", google_service_account.gke.email)
}

###
# assign gcr permissions
###
resource "google_project_iam_member" "gke_gcr" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = format("serviceAccount:%s", google_service_account.gke.email)
}
