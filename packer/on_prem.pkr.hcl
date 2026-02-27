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
    iso_storage_pool = var.proxmox_shared_storage_pool
  }

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
    firewall = "false"
  }

  disks {
    disk_size         = "50G"
    storage_pool      = var.proxmox_shared_storage_pool
    type              = "scsi"
    format = "raw"
  }

  efi_config {
    efi_storage_pool  = var.proxmox_shared_storage_pool
  }

  template_name = "debian-base-template"
  scsi_controller = "virtio-scsi-pci"
  memory = 2048
  cores = 4
  qemu_agent = true

  proxmox_url = var.proxmox_host
  insecure_skip_tls_verify = true
  username = var.proxmox_username
  password = var.proxmox_password
  vm_id = 900
}

build {
  sources = ["source.proxmox-iso.debian_base"]

  provisioner "ansible" {
    playbook_file = "../configure-templates.yml"
    groups = ["proxmox_all", "${source.name}_group"]
    user = var.ssh_username
  }
}