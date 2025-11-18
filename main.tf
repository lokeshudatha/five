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
    ssh-keys = "udathalokesh:${file("/var/lib/jenkins/.ssh/id_ed25519.pub.")}"
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
    docker build -t pythonlokesh:latest .
    echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin
    docker tag pythonlokesh:latest 9515524259/pythonudatha:v1
    docker push 9515524259/pythonudatha:v1
  EOF
}
resource "local_file" "file1" {
  content  = "udathalokesh@${google_compute_instance.python.network_interface[0].access_config[0].nat_ip}"
  filename = "/var/lib/jenkins/workspace/ip.txt"
}
