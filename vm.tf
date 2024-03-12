resource "libvirt_domain" "testbed" {
  count = length(var.node_names)
  name = var.node_names[count.index]
  description = "Testbed node ${var.node_names[count.index]}"

  vcpu = var.num_cpus
  memory = var.ram_mb

  #firmware = var.uefi_firmware

  cloudinit = libvirt_cloudinit_disk.testbed[count.index].id

  boot_device {
    dev = [ "hd" ]
  }

  cpu {
    mode = "host-passthrough"
  }

  console {
    type = "pty"
    target_port = 0
  }

  graphics {
    type = "spice"
  }

  video {
    type = "virtio"
  }

  qemu_agent = var.qemu_agent

  # Primary network interface
  network_interface {
    network_id = libvirt_network.testbed.id
    hostname = var.node_names[count.index]
    addresses = [
      local.primary_network_node_ips[var.node_names[count.index]]
    ]
    mac = local.primary_network_node_macs[var.node_names[count.index]]
  }

  # Secondary networks interfaces
  dynamic "network_interface" {
    for_each = { for x in var.secondary_networks: x.name => x }
    content {
      network_id = libvirt_network.testbed_secondary[network_interface.key].id
      hostname = var.node_names[count.index]
      addresses = [
        local.secondary_networks_node_ips[network_interface.key][var.node_names[count.index]]
      ]
      mac = local.secondary_networks_node_macs[network_interface.key][var.node_names[count.index]]
    }
  }

  # Primary disk
  dynamic "disk" {
    for_each = var.primary_image_url == null ? [] : [null]
    content {
      volume_id = libvirt_volume.primary_disk[count.index].id
    }
  }

  # Secondary drives

}
