variable "proxmox_host" {
  type = string
}

variable "proxmox_username" {
  type = string
}

variable "proxmox_password" {
  type = string
  sensitive = true
}

variable "proxmox_node_list" {
  type = list(string)
}

variable "proxmox_local_storage_pool" {
  type = string
}

variable "proxmox_shared_storage_pool" {
  type = string
}

variable "debian_iso_url" {
  type = string
}

variable "debian_iso_checksum_url" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "ssh_password" {
  type = string
  sensitive = true
}
