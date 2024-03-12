resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}

resource "local_sensitive_file" "ssh_private_key" {
  content = tls_private_key.ssh_key.private_key_openssh
  filename = "${path.module}/artifacts/id_ed25519"
  file_permission = "0600"
}

resource "local_file" "ssh_public_key" {
  content = tls_private_key.ssh_key.public_key_openssh
  filename = "${path.module}/artifacts/id_ed25519.pub"
  file_permission = "0644"
}

resource "local_file" "ssh_script" {
  content = templatefile("${path.module}/templates/ssh_script.sh", {
    node_names = var.node_names
    ssh_key_path = local_sensitive_file.ssh_private_key.filename

    primary_network_node_ips = local.primary_network_node_ips
    user_name = var.user_name
  })
  filename = "${path.module}/artifacts/ssh_script.sh"
  file_permission = "0750"
}
