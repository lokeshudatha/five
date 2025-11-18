provider "google" {
  project     = "winter-monolith-477705-m8"
  region      = "us-central1"
  zone        = "us-central1-c"
}
resource "google_compute_instance" "python" {
  name         = "pythonvm"
  machine_type = "e2-small"
  zone         = "us-central1-c"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = "jenkins:${file("/var/lib/jenkins/.ssh/id_ed25519.pub")}"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker udathalokesh11
    sudo chmod 666 /var/run/docker.sock
    sudo systemctl restart docker
  EOF
}
resource "local_file" "file1" {
  content  = "jenkins@${google_compute_instance.python.network_interface[0].access_config[0].nat_ip}"
  filename = "/var/lib/jenkins/workspace/ip.txt"
}
