provider "google" {
  project     = "winter-monolith-477705-m8"
  region      = "us-central1"
}

resource "google_compute_instance" "new" {
  name = "siva"
}
