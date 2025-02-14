source "proxmox-iso" "debian_base" {
  http_directory = "./http_content"
  boot_command = ["<esc><wait>auto preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"]
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout = "20m"

  boot_iso {
    unmount = true
    iso_url = var.debian_iso_url
    iso_checksum = "file:${var.debian_iso_checksum_url}"
    iso_storage_pool = "local"
  }

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
    firewall = "false"
  }

  disks {
    disk_size         = "50G"
    storage_pool      = var.proxmox_disk_storage_pool
    type              = "scsi"
    format = "raw"
  }

  efi_config {
    efi_storage_pool  = var.proxmox_disk_storage_pool
  }

  template_name = "debian-base-template"
  scsi_controller = "virtio-scsi-pci"
  memory = 1024
  cores = 4
  qemu_agent = true

  proxmox_url = var.proxmox_host
  insecure_skip_tls_verify = true
  node = var.proxmox_node
  username = var.proxmox_username
  password = var.proxmox_password
  vm_id = 900
}

source "proxmox-clone" "docker_containers" {
  clone_vm = "debian-base-template"
  ssh_username = var.ssh_username
  ssh_certificate_file = "~/.ssh/id_rsa-cert.pub"
  ssh_private_key_file = "~/.ssh/id_rsa"

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
    firewall = "false"
    mac_address = "f6:13:a0:be:25:a1"
  }

  template_name = "docker-containers-template"
  memory = 1024
  cores = 4
  qemu_agent = true

  proxmox_url = var.proxmox_host
  insecure_skip_tls_verify = true
  node = var.proxmox_node
  username = var.proxmox_username
  password = var.proxmox_password
  vm_id = 901
}

source "proxmox-clone" "dev_playground" {
  clone_vm = "debian-base-template"
  ssh_username = var.ssh_username
  ssh_certificate_file = "~/.ssh/id_rsa-cert.pub"
  ssh_private_key_file = "~/.ssh/id_rsa"

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
    firewall = "false"
  }

  template_name = "dev-playground-template"
  memory = 1024
  qemu_agent = true

  proxmox_url = var.proxmox_host
  insecure_skip_tls_verify = true
  node = var.proxmox_node
  username = var.proxmox_username
  password = var.proxmox_password
  vm_id = 902
}

build {
  sources = [
    "source.proxmox-iso.debian_base",
    "source.proxmox-clone.dev_playground",
    "source.proxmox-clone.docker_containers",
  ]

  provisioner "ansible" {
    playbook_file = "../configure-templates.yml"
    groups = ["proxmox_all", "${source.name}_group"]
    user = var.ssh_username
    use_proxy = false
  }
}
