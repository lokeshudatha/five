provider "google" {
  project = "winter-monolith-477705-m8"
  region  = "us-central1"
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

  metadata = {
    ssh-keys = "udathalokesh11:${file("/home/lokesh/.ssh/id_rsa.pub")}"
  }

  # Upload project files (Dockerfile etc.)
  provisioner "file" {
    source      = "./app"  # Your local folder that contains Dockerfile
    destination = "/home/udathalokesh11/app"

    connection {
      type        = "ssh"
      user        = "udathalokesh11"
      private_key = file("/home/lokesh/.ssh/id_rsa")
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }

  # Install docker + build + push image
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io",
      "sudo systemctl start docker",
      "sudo usermod -aG docker udathalokesh11",
      "cd /home/udathalokesh11/app",
      "docker build -t python_img:latest .",
      "echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin",
      "docker tag python_img:latest lokeshudatha/python:v1",
      "docker push lokeshudatha/python:v1"
    ]

    connection {
      type        = "ssh"
      user        = "udathalokesh11"
      private_key = file("/home/lokesh/.ssh/id_rsa")
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }
}

resource "google_compute_firewall" "lokifirewall" {
  name    = "lokesh-firewall"
  network = google_compute_network.lokinetwork.id

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}
