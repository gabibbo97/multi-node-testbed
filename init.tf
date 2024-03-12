terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.6"
    }
    local = {
      source = "hashicorp/local"
      version = "2.5"
    }
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.5"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///session"
}
