resource "google_compute_instance" "web" {
  name         = "webapp"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
 
  tags = ["http-server"]
  boot_disk {
    initialize_params {
      image = "rhel-cloud/rhel-9"
      #image =  "ubuntu-os-cloud/ubuntu-2004-lts"  
      size  = 40 // 40 GB boot disk
    }
  }
 
  network_interface {
    network = "default"
    access_config {
      // Include any access configuration if needed
    }
  }
  #metadata_startup_script = file("./app.sh")
  metadata_startup_script = <<-EOT
    #!/bin/bash
    #install docker
    sudo yum update -y
    sudo yum install wget -y
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
    sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl start docker
    echo " Docker installation done"
    sudo systemctl enable docker
    sudo yum install git -y
    # Clone the repository
    git clone https://github.com/pavanteja2704/webapp.git /tmp/your-repo
    # Run the httpd container
    docker run -d -p 4102:80 --name apache-container httpd
    # Wait for the container to start
    sleep 10
    # Copy the repository files to the document root
    docker cp /tmp/your-repo/. apache-container:/usr/local/apache2/htdocs/
    # Restart the container to ensure Apache serves the new content
    docker restart apache-container
  EOT
}