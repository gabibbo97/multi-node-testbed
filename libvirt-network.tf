locals {
  primary_network_node_ips = {
    for i, name in var.node_names :
      name => cidrhost(var.primary_network_cidr, i+10)
  }
  primary_network_node_macs = {
    for i, name in var.node_names :
      name => format("${var.primary_network_mac_prefix}:%02X", i+1                                                                                                                                )
  }
  secondary_networks_node_ips = {
    for network in var.secondary_networks :                                                                                         
      network.name => { for i, name in var.node_names : name => cidrhost(network.cidr, i+10) }
  }
  secondary_networks_node_macs = {
    for i, network in var.secondary_networks :
      network.name => { for j, name in var.node_names : name => format("${var.secondary_networks_mac_prefix}:%02X:%02X", i+1, j+1) }
  }
}

resource "libvirt_network" "testbed" {
  name = var.primary_network_name
  mode = "nat"
  domain = var.primary_network_domain
  addresses = [
    var.primary_network_cidr
  ]
  mtu = var.primary_network_mtu
  dns {
    enabled = true
    dynamic "forwarders" {
      for_each = var.primary_network_dns_forwards
      content {
        address = forwarders.value
      }
    }
    dynamic "hosts" {
      for_each = var.primary_network_enable_dns_for_hostnames ? local.primary_network_node_ips : {}
      content {
        hostname = hosts.key
        ip = hosts.value
      }
    }
  }
  dhcp {
    enabled = var.primary_network_enable_dhcp
  }
}

resource "libvirt_network" "testbed_secondary" {
  for_each = { for x in var.secondary_networks: x.name => x }
  name = each.key
  mode = "none"
  addresses = [
    each.value.cidr
  ]
  dhcp {
    enabled = coalesce(each.value.dhcp, false)
  }
}
