provider "google" {
  version = "~> 3.19.0"

  region  = var.region
  project = var.project_id
}

provider "google-beta" {
  version = "~> 3.19.0"

  region  = var.region
  project = var.project_id
}

provider "random" {
  version = "> 2.2"
}

provider "template" {
  version = "~> 2.1"
}
