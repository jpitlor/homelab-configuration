source "googlecompute" "vps" {
  project_id = "dev-pitlor-homelab"
  source_image_family = "debian-12"
  zone = "us-central1-a"

  machine_type = "e2-micro"

  ssh_username = "packer"
  ssh_password = "packer"
  ssh_timeout = "20m"
}

build {
  sources = [
    "source.googlecompute.vps"
  ]

  provisioner "ansible" {
    playbook_file = "../playbook.yml"
    groups = ["vps"]
    user = "packer"
  }
}
