# Create a VM instance
resource "google_compute_instance" "vm-1" {
  name         = "webapp"
  machine_type = "e2-medium"
  zone         = "northamerica-northeast2-c"

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

