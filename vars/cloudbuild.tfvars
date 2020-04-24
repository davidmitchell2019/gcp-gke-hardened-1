region = "europe-west2"

project_name           = "project_name"
project_sponsor        = "project_sponsor"
project_technical_lead = "project_technical_lead"

cost_code     = "cost_code"
business_name = "business_name"
creator       = "creator"

gke_subnetwork = {
  name         = "gke"
  cidr         = "10.0.32.0/24"
  pod_cidr     = "10.32.0.0/17"
  pod_name     = "gke-pod"
  service_cidr = "10.32.128.0/20"
  service_name = "gke-service"

}

gke_master_ipv4_cidr_block = "172.16.0.0/28"
