resource "local_file" "ansible_inventory" {
  content = yamlencode({
    all = {
      hosts = {
        for node_name in var.node_names:
        node_name => {
          ansible_host = local.primary_network_node_ips[node_name]
          ansible_user = var.user_name
          ansible_ssh_private_key_file = abspath(local_sensitive_file.ssh_private_key.filename)
          ansible_ssh_common_args = <<-EOF
            -o UserKnownHostsFile=/dev/null
            -o StrictHostKeyChecking=no
          EOF
        }
      }
    }
  })
  filename = "${path.module}/artifacts/ansible_inventory.yml"
  file_permission = "0750"
}