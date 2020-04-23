# gcp-gke-hardened

# Description
Terraform state bucket and workspaces are utilised to allow multiple deployments.

The terraform script consists of 2 stages:
1. Bootstrap deployment
1. Component deployment

# Usage
## Booststrap
This stage deploys the following components:
* GCS Bucket for terraform state
* KMS Key Ring
* KMS Key Crypto Key

## Components
This stage deploys the following components:
* VPC
* Subnetworks
* Firewall Rules
* NAT Router
* GKE cluster

## Pre-requisites
Create the file named bootstrap/vars/bootstrap.tfvars and populate variables accordingly.
```
region                  = "europe-west2"
project_id              = "gcp-project-id"
project_name            = "my-project"
project_sponsor         = "joe-bloggs"
project_technical_lead  = "joe-bloggs"
cost_code               = "123456"
business_name           = "dept-1"
creator                 = "owner"
```

Create the file named vars/ws-dev1.tfvars and populate variables accordingly.
```
region                  = "europe-west2"
project_id              = "gcp-project-id"
project_name            = "my-project"
project_sponsor         = "joe-bloggs"
project_technical_lead  = "joe-bloggs"
cost_code               = "123456"
business_name           = "dept-1"
creator                 = "owner"

gke_subnetwork = {
  name         = "gke"
  cidr         = "10.0.32.0/24"
  pod_cidr     = "10.32.0.0/17"
  pod_name     = "gke-pod"
  service_cidr = "10.32.128.0/20"
  service_name = "gke-service"

}

gke_master_ipv4_cidr_block          = "172.16.0.0/28"
```

## Bootstrap
As part of bootstrap deployment, Terraform checks and tries to activate missing APIs. If it doesn't have enough privileges to activate a missing API, it will fail. If this happens, to successfully deploy the bootstrap, activate the following APIs through other means:

```
cloudkms.googleapis.com
compute.googleapis.com
container.googleapis.com
iam.googleapis.com
storage-api.googleapis.com
```

The commands below will download the required terraform executable and initialise the terraform state bucket.
```
export WS=dev1
make bootstrap-init
make bootstrap-plan
make bootstrap-apply
```

## Component Deployment
The commands below will deploy the infrastructure components to GCP.
```
export WS=dev1
make init 
make plan 
make apply
```

## Component Deletion
The commands below will destroy the infrastructure components in GCP.
```
export WS=dev1
make destroy
 ```

## Deletion of a component, e.g. GKE
The commands below will destroy the selected infrastructure components and related dependencies in GCP.
```
export WS=dev1
RESOURCE=module.gke make destroy-target
```

## (Mostly) complete deletion of all resources
The commands will destroy the Component Deployment as well as the bootstrap deployment
```
export WS=dev1
make destroy
make clean
make bootstrap-destroy
make bootstrap-clean
```

NOTE: This process is mostly complete as the Cloud KMS keys and key rings are left behind as currently there isn't a process to delete all key versions

## Deploy into another terraform workspace
Create the file named vars/ws-*dev2*.tfvars and populate variables accordingly.

The command below will deploy all the components into the terraform workspace *dev2*.
```
export WS=dev2
make init 
make plan 
make apply
```

## Useful commands
SSH connectivity to automation host via IAP
```shell script
gcloud compute ssh $(terraform output automation_name) \
  --zone $(terraform output automation_zone) \
  --tunnel-through-iap
```

SSH connectivity to automation host via IAP with proxy forwarding to localhost:3128
```shell script
gcloud compute ssh $(terraform output automation_name) \
  --zone $(terraform output automation_zone) \
  --tunnel-through-iap \
  -- -L 3128:localhost:3128
```

IAP proxy forwarding to localhost:3128
```shell script
gcloud compute start-iap-tunnel $(terraform output automation_name) 3128 \
  --local-host-port localhost:3128 \
  --zone $(terraform output automation_zone)
```

Check status of metadata startup script (wait upto 10 mins for the script to complete)
```shell script
gcloud compute ssh $(terraform output automation_name) \
  --zone $(terraform output automation_zone) \
  --tunnel-through-iap 
  --command "sudo tail /var/log/bootstrap.log -f"
```

GKE Cluster connectivity
```shell script
gcloud container clusters get-credentials $(terraform output gke_cluster_name) \
  --region $(terraform output region)

HTTPS_PROXY=localhost:3128 kubectl get nodes

HTTPS_PROXY=localhost:3128 kubectl get all
```
