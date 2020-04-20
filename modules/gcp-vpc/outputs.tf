output "name" {
  value       = google_compute_network.default.name
  description = "VPC name"
}

output "self" {
  value       = google_compute_network.default
  description = "Self object"
}