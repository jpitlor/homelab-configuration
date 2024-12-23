source "googlecompute" "vps" {
  project_id = "dev-pitlor-homelab"
  source_image_family = "debian-12"
  zone = "us-central1-a"

  machine_type = "e2-micro"
  image_name = "vps-image-template"

  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout = "20m"
}

build {
  sources = [
    "source.googlecompute.vps"
  ]

  provisioner "ansible" {
    playbook_file = "../configure-templates.yml"
    groups = ["vps"]
    user = var.ssh_username
    use_proxy = false
  }
}
