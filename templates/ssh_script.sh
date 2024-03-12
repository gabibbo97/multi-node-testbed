#!/bin/sh
fail() {
  echo "$1" >/dev/stderr
  exit 1
}

find_ssh_key() {
  for p in \
    "${basename(ssh_key_path)}" \
    "../${basename(ssh_key_path)}" \
    "artifacts/${basename(ssh_key_path)}" \
    "${abspath(ssh_key_path)}"
  do
    if [ -f "$p" ]; then
      printf '%s' "$p"
      return 0
    fi
  done
  fail 'Could not find SSH key'
}

connectSSH() {
  exec ssh \
    -o IdentitiesOnly=yes \
    -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
    -o ServerAliveInterval=10 \
    -o ServerAliveCountMax=3 \
    -i "$(find_ssh_key)" \
    "$@"
}

case $1 in
  %{~ for host in node_names ~}
  ${host})
    node_name="$1"
    shift
    connectSSH "${user_name}@${primary_network_node_ips[host]}" "$@"
    ;;
  %{~ endfor }
  *)
    if [ -z "$1" ]; then
      echo "Unknown node '$1'"
    fi
    echo 'Available nodes:'
    %{~ for host in node_names ~}
    echo '  - ${host} (${primary_network_node_ips[host]})'
    %{~ endfor ~}
    ;;
esac