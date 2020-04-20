output "name" {
  value = google_container_cluster.default.name
}

output "self" {
  value       = google_container_cluster.default
  description = "Self object"
}
