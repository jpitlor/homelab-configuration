source "proxmox-iso" "docker_containers" {
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

  template_name = "docker-containers-template"
  scsi_controller = "virtio-scsi-pci"
  memory = 1024
  cores = 2
  qemu_agent = true

  proxmox_url = var.proxmox_host
  insecure_skip_tls_verify = true
  node = var.proxmox_node
  username = var.proxmox_username
  password = var.proxmox_password
  vm_id = 900
}

source "proxmox-iso" "dev_playground" {
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

  template_name = "dev-playground-template"
  scsi_controller = "virtio-scsi-pci"
  memory = 1024
  qemu_agent = true

  proxmox_url = var.proxmox_host
  insecure_skip_tls_verify = true
  node = var.proxmox_node
  username = var.proxmox_username
  password = var.proxmox_password
  vm_id = 901
}

source "proxmox-iso" "vault" {
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

  template_name = "vault-template"
  scsi_controller = "virtio-scsi-pci"
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
    "source.proxmox-iso.docker_containers"
  ]

  provisioner "ansible" {
    playbook_file = "../configure-templates.yml"
    groups = ["docker_containers"]
    user = var.ssh_username
  }
}

build {
  sources = [
    "source.proxmox-iso.dev_playground"
  ]

  provisioner "ansible" {
    playbook_file = "../configure-templates.yml"
    groups = ["dev_playground"]
    user = var.ssh_username
  }
}

build {
  sources = [
    "source.proxmox-iso.vault"
  ]

  provisioner "ansible" {
    playbook_file = "../configure-templates.yml"
    groups = ["vault"]
    user = var.ssh_username
  }
}
