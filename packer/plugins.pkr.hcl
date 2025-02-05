packer {
  required_plugins {
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }

    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }

    googlecompute = {
      version = "~> 1"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}
