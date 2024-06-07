# Create a VM instance
resource "google_compute_instance" "default" {
  name         = "webapp-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["http-server"]
 
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"// RHEL 9 image
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
# Create a firewall rule to allow HTTP traffic
resource "google_compute_firewall" "fire" {
  name    = "allow-http"
  network = "default"
 
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
 
  target_tags = ["http-server"]
  source_tags = ["webserver"]
}
 
# Output the external IP address of the instance
output "instance_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}
