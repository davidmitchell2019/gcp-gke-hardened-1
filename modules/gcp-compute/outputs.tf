output "name" {
  value       = google_compute_instance.default.name
  description = "Instance name"
}

output "private_ip" {
  value       = google_compute_instance.default.network_interface.0.network_ip
  description = "Instance private ip address"
}

output "zone" {
  value       = google_compute_instance.default.zone
  description = "Instance zone"
}

output "self" {
  value       = google_compute_instance.default
  description = "Self object"
}
