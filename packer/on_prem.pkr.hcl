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
  memory = 2048
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
  task_timeout = "10m"  # Shutting down a k8s cluster takes longer than the default of 1m

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
    firewall = "false"
  }

  disks {
    disk_size         = "200G"
    storage_pool      = var.proxmox_disk_storage_pool
    type              = "scsi"
    format = "raw"
  }

  memory = 2048
  cores = 4
  qemu_agent = true

  proxmox_url = var.proxmox_host
  insecure_skip_tls_verify = true
  username = var.proxmox_username
  password = var.proxmox_password
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
  memory = 2048
  qemu_agent = true

  proxmox_url = var.proxmox_host
  insecure_skip_tls_verify = true
  node = var.proxmox_node
  username = var.proxmox_username
  password = var.proxmox_password
  vm_id = 901
}

build {
  sources = [
    "source.proxmox-iso.debian_base",
    "source.proxmox-clone.dev_playground"
  ]

  provisioner "ansible" {
    playbook_file = "../configure-templates.yml"
    groups = ["proxmox_all", "${source.name}_group"]
    user = var.ssh_username
  }
}

build {
  dynamic "source" {
    for_each = var.proxmox_node_list
    labels   = ["proxmox-clone.docker_containers"]
    content {
      name = source.value
      node = source.value
      vm_id = 902 + index(var.proxmox_node_list, source.value)
      template_name = "docker-containers-${source.value}-template"
    }
  }

  provisioner "ansible" {
    playbook_file = "../configure-templates.yml"
    groups = ["proxmox_all", "docker_containers_group"]
    user = var.ssh_username
    extra_arguments = ["--extra-vars", "kubernetes_node_label=${source.name}"]
  }
}