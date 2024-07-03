# Create a VM instance
resource "google_compute_instance" "default" {
  name         = "webapp-vm"
  machine_type = "e2-medium"
  zone         = "northamerica-northeast2-b"

  tags = ["http-server"]
 
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 50 // 50 GB boot disk
    }
  }
 
  network_interface {
    network       = "default"
    access_config {
    }
  }
    metadata_startup_script = file("./app.sh")
} 
# Output the external IP address of the instance
output "instance_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}
