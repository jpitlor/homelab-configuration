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
  node = element(var.proxmox_node_list, 0)
  username = var.proxmox_username
  password = var.proxmox_password
  vm_id = 900
}

source "proxmox-clone" "docker_containers_nuc" {
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
    disk_size         = "140G"
    storage_pool      = var.proxmox_local_storage_pool
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

  node = "nuc"
  vm_id = 902
  template_name = "docker-containers-nuc-template"
}

source "proxmox-clone" "docker_containers_zotac03" {
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
    disk_size         = "140G"
    storage_pool      = var.proxmox_local_storage_pool
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

  node = "zotac03"
  vm_id = 903
  template_name = "docker-containers-zotac03-template"
}

source "proxmox-clone" "docker_containers_zotac09" {
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
    disk_size         = "140G"
    storage_pool      = var.proxmox_local_storage_pool
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

  node = "zotac09"
  vm_id = 904
  template_name = "docker-containers-zotac09-template"
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

  disks {
    disk_size         = "50G"
    storage_pool      = var.proxmox_local_storage_pool
    type              = "scsi"
    format = "raw"
  }

  template_name = "dev-playground-template"
  memory = 2048
  qemu_agent = true

  proxmox_url = var.proxmox_host
  insecure_skip_tls_verify = true
  node = element(var.proxmox_node_list, 0)
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
  sources = [
    "proxmox-clone.docker_containers_nuc",
    "proxmox-clone.docker_containers_zotac03",
    "proxmox-clone.docker_containers_zotac09"
  ]

  provisioner "ansible" {
    playbook_file = "../configure-templates.yml"
    groups = ["proxmox_all", "docker_containers_group"]
    user = var.ssh_username
    extra_arguments = ["--extra-vars", "kubernetes_node_label=${source.name}"]
  }
}

# build {
#   dynamic "source" {
#     for_each = var.proxmox_node_list
#     labels   = ["proxmox-clone.docker_containers"]
#     content {
#       name = "docker-containers-${source.value}"
#       node = source.value
#       vm_id = 902 + index(var.proxmox_node_list, source.value)
#       template_name = "docker-containers-${source.value}-template"
#     }
#   }

#   provisioner "ansible" {
#     playbook_file = "../configure-templates.yml"
#     groups = ["proxmox_all", "docker_containers_group"]
#     user = var.ssh_username
#     extra_arguments = ["--extra-vars", "kubernetes_node_label=${source.name}"]
#   }
# }