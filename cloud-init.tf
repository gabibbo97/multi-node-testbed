resource "libvirt_cloudinit_disk" "testbed" {
  count = length(var.node_names)
  name = "${var.node_names[count.index]}_cloud_init.iso"
  pool = libvirt_pool.testbed.name

  user_data = format("#cloud-config\n%s", jsonencode(merge(
    {
      # Message
      final_message = <<-EOF
        cloud-init finished
          version: $version
          timestamp: $timestamp
          datasource: $datasource
          uptime: $uptime
      EOF
      # Disk
      growpart = {
        mode = "auto"
        devices = [ "/" ]
      }
      mounts = var.mount_filesystems ? [
        for fs in var.filesystems :
          [ fs.target, coalesce(fs.destination, fs.source), "9p", "trans=virtio,version=9p2000.L,${coalesce(fs.readonly,false)?"r":"rw"}", "0", "0" ]
      ] : []
      resizefs = {
        resize_rootfs = true
      }
      # Locale / Keyboard / Language / Timezone
      keyboard = {
        layout = "us"
      }
      locale = "C.UTF-8"
      timezone = "Etc/UTC"
      # Others
      fqdn = "${var.node_names[count.index]}.${var.primary_network_domain}"
      hostname = "${var.node_names[count.index]}"
      manage_etc_hosts = true
      manage_resolv_conf = true
      ntp = {
        enabled = true
        ntp_client = "systemd-timesyncd"
      }
      package_update = true
      package_upgrade = true
      package_reboot_if_required = true
      # Users
      disable_root = false
      ssh_authorized_keys = [
        tls_private_key.ssh_key.public_key_openssh
      ]
      ssh_pwauth = var.password != null
      users = [
        {
          name = var.user_name
          gecos = "Testbed user"
          ssh_authorized_keys = [
            tls_private_key.ssh_key.public_key_openssh
          ]
          sudo = "ALL=(ALL) NOPASSWD:ALL"
          plain_text_passwd = var.password
          lock_passwd = var.password == null
        }
      ]
    },
    var.extra_cloud_init_user_data
  )))
  meta_data = yamlencode(var.extra_cloud_init_meta_data)
  network_config = yamlencode(merge(
    {
      network = {
        version = 2
        ethernets = {
          id0 = {
            match = {
              macaddress = local.primary_network_node_macs[var.node_names[count.index]]
            }
            dhcp4 = true
          }
        }
      }
    },
    var.extra_cloud_init_network_config
  ))
}