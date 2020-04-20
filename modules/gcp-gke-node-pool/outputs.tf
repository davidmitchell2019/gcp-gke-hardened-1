output "name" {
  value = google_container_node_pool.default.name
}

output "self" {
  value       = google_container_node_pool.default
  description = "Self object"
}