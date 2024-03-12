# multi-node testbed

This OpenTofu/Terraform abomination allows you to set up a local multi-node testbed for all of your system administration needs.

## Quickstart

- Ensure you are running the libvirt daemon
- Ensure you can access the `qemu:///session` libvirt URL (`usermod -aG libvirt $(whoami)`)
- Download a cloud image `make fedora-cloud-39.img`
- Initialize `make init`
- Run `make apply`
- Access the first node ssh `sh artifacts/ssh_script.sh node1`
