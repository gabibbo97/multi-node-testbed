#
# nodes
#
variable "node_names" {
  type = list(string)
  default = [ "node1", "node2", "node3" ]
}

#
# OS Configuration
#
variable "user_name" {
  type = string
  default = "user"
}

variable "password" {
  type = string
  default = null
}

variable "extra_cloud_init_user_data" {
  type = map(any)
  default = {}
}

variable "extra_cloud_init_meta_data" {
  type = map(any)
  default = {}
}

variable "extra_cloud_init_network_config" {
  type = map(any)
  default = {}
}

#
# Virtual filesystems
#
variable "filesystems" {
  type = list(object({
    source = string
    destination = optional(string)
    target = string
    readonly = optional(bool)
  }))
  default = [
  ]
}

variable "mount_filesystems" {
  type = bool
  default = true
}

#
# Hardware configuration
#
variable "num_cpus" {
  type = number
  default = 2
}

variable "ram_mb" {
  type = number
  default = 4096
}

#
# VM Configuration
#
variable "uefi_firmware" {
  type = string
  default = "/usr/share/OVMF/OVMF_CODE.fd"
}

variable "qemu_agent" {
  type = bool
  default = false
}

#
# network
#
variable "primary_network_name" {
  type = string
  default = "testbed"
}

variable "primary_network_dns_forwards" {
  type = list(string)
  default = [
    "1.1.1.1",
    "1.0.0.1"
  ]
}

variable "primary_network_domain" {
  type = string
  default = "testbed.local"
}

variable "primary_network_mtu" {
  type = number
  default = 1500
}

variable "primary_network_cidr" {
  type = string
  default = "172.16.42.0/24"
}

variable "primary_network_enable_dhcp" {
  type = bool
  default = true
}

variable "primary_network_enable_dns_for_hostnames" {
  type = bool
  default = true
}

variable "primary_network_mac_prefix" {
  type = string
  default = "AA:BB:CC:DD:EE"
}

variable "secondary_networks_mac_prefix" {
  type = string
  default = "AA:BB:42:42"
}

variable "secondary_networks" {
  type = list(object({
    name = string
    cidr = string
    dhcp = optional(bool)
    mac_prefix = optional(string)
  }))
  default = [
  ]
}

#
# storage
#
variable "storage_pool_name" {
  type = string
  default = "testbed"
}

variable "storage_pool_path" {
  type = string
  default = "/var/lib/libvirt/testbed"
}

#
# disk
#
variable "primary_image_url" {
  type = string
  default = null
}

variable "primary_disk_size_gb" {
  type = number
  default = 100
}
