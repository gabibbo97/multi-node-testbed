resource "libvirt_pool" "testbed" {
  name = var.storage_pool_name
  type = "dir"
  path = var.storage_pool_path
}

resource "libvirt_volume" "primary_disk_template" {
  count = var.primary_image_url == null ? 0 : 1
  name = "testbed_primary_disk_template"
  pool = libvirt_pool.testbed.name
  source = var.primary_image_url
}

resource "libvirt_volume" "primary_disk" {
  count = var.primary_image_url == null ? 0 : length(var.node_names)
  name = "testbed_n${count.index}_primary_disk.qcow2"
  pool = libvirt_pool.testbed.name
  size = var.primary_disk_size_gb * 1024 * 1024 * 1024

  base_volume_id = libvirt_volume.primary_disk_template[0].id
  base_volume_pool = libvirt_pool.testbed.id
}