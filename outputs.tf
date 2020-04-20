output "labels" {
  value = module.labels.rendered
}

output "automation_name" {
  value = module.automation.name
}

output "automation_private_ip" {
  value = module.automation.private_ip
}

output "automation_zone" {
  value = module.automation.zone
}

output "gke_cluster_name" {
  value = module.gke.name
}

output "gke_node_locations" {
  value = join(", ", local.gke_node_locations)
}
