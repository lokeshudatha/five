provider "google" {
  project     = "winter-monolith-477705-m8"
  region      = "us-central1"
}

resource "google_compute_network" "lokinetwork" {
  name                    = "lokesh-network"
  auto_create_subnetworks = false 
}

resource "google_compute_subnetwork" "lokisubnetwork" {
  name          = "lokesh-subnetwork"
  network       = google_compute_network.lokinetwork.id
  region        = "us-central1"
  ip_cidr_range = "10.0.0.0/22"
}

resource "google_compute_instance" "loki" {
  name         = "lokesh-udatha"
  zone         = "us-central1-a"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork   = google_compute_subnetwork.lokisubnetwork.id
    access_config {}
  }

  depends_on = [
    google_compute_subnetwork.lokisubnetwork
  ]
  metadata_startup_script =<<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker udathalokesh11
    sudo chmod 666 /var/run/docker.sock
    sudo systemctl restart docker
    sudo git clone https://github.com/lokeshudatha/four
    docker build -t python_img:latest .
    echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin
    docker tag python_img:latest lokeshudatha/python:v1
    docker push lokeshudatha/python:v1
  EOF
}

resource "google_compute_firewall" "lokifirewall" {
  name    = "lokesh-firewall"
  network = google_compute_network.lokinetwork.id

  direction = "INGRESS"

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}


