source "proxmox-iso" "docker_containers" {
  iso_url = var.debian_iso_url
  iso_checksum = "file:${var.debian_iso_checksum_url}"
  iso_storage_pool = "local"
  unmount_iso = true

  http_directory = "./http_content"
  http_port_min = 8081
  http_port_max = 8081
  boot_command = ["<esc><wait>auto preseed/url=http://192.168.0.103:{{ .HTTPPort }}/preseed.cfg<enter>"]

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
    firewall = "false"
  }

  disks {
    disk_size         = "50G"
    storage_pool      = var.proxmox_disk_storage_pool
    type              = "scsi"
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
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout = "20m"
  vm_id = 900
}

source "proxmox-iso" "dev_playground" {
  iso_url = var.debian_iso_url
  iso_checksum = "file:${var.debian_iso_checksum_url}"
  iso_storage_pool = "local"
  unmount_iso = true

  http_directory = "./http_content"
  http_port_min = 8081
  http_port_max = 8081
  boot_command = ["<esc><wait>auto preseed/url=http://192.168.0.103:{{ .HTTPPort }}/preseed.cfg<enter>"]

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
    firewall = "false"
  }

  disks {
    disk_size         = "50G"
    storage_pool      = var.proxmox_disk_storage_pool
    type              = "scsi"
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
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout = "20m"
  vm_id = 900
}

source "proxmox-iso" "vault" {
  iso_url = var.debian_iso_url
  iso_checksum = "file:${var.debian_iso_checksum_url}"
  iso_storage_pool = "local"
  unmount_iso = true

  http_directory = "./http_content"
  http_port_min = 8081
  http_port_max = 8081
  boot_command = ["<esc><wait>auto preseed/url=http://192.168.0.103:{{ .HTTPPort }}/preseed.cfg<enter>"]

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
    firewall = "false"
  }

  disks {
    disk_size         = "50G"
    storage_pool      = var.proxmox_disk_storage_pool
    type              = "scsi"
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
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout = "20m"
  vm_id = 900
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
