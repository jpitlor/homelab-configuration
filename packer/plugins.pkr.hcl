packer {
  required_plugins {
    proxmox = {
      version = "1.2.2"
      source  = "github.com/hashicorp/proxmox"
    }

    ansible = {
      version = "1.1.2"
      source = "github.com/hashicorp/ansible"
    }

    googlecompute = {
      version = "1.1.6"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}
