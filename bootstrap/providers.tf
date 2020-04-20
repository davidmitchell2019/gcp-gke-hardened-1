provider "google" {
  version = "~> 3.17.0"
  region  = var.region
  project = var.project_id
}

provider "random" {
  version = "~> 2.2"
}
