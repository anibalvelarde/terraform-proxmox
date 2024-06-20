# Variable for starting VM ID
variable "start_vmid" {
  default = 501
}

# Create the k3s master node
resource "proxmox_vm_qemu" "k3s_master" {
  name         = "k3s-master"
  target_node  = "proxmox"
  clone        = "k3sTv2"

  os_type      = "cloud-init"
  cores        = 2
  sockets      = 1
  memory       = 2048
  scsihw       = "virtio-scsi-pci"
  bootdisk     = "scsi0"

  network {
    model   = "virtio"
    bridge  = "vmbr0"
  }

  disk {
    storage = "local"
    type    = "scsi"
    size    = "8G"
  }

  # Set the VM ID
  vmid        = var.start_vmid

  lifecycle {
    create_before_destroy = true
  }
}

# Create the k3s worker nodes
resource "proxmox_vm_qemu" "k3s_worker" {
  count        = 3  # Adjust the count as needed
  name         = "k3s-worker-${count.index + 1}"
  target_node  = "proxmox"
  clone        = "k3sTv2"

  os_type      = "cloud-init"
  cores        = 2
  sockets      = 1
  memory       = 2048
  scsihw       = "virtio-scsi-pci"
  bootdisk     = "scsi0"

  network {
    model   = "virtio"
    bridge  = "vmbr0"
  }

  disk {
    storage = "local"
    type    = "scsi"
    size    = "8G"
  }

  # Set the VM ID using the start_vmid variable and the count index
  vmid        = var.start_vmid + count.index + 1

  lifecycle {
    create_before_destroy = true
  }
}

# Outputs for IP addresses
output "k3s_master_ip" {
  value = proxmox_vm_qemu.k3s_master.default_ipv4_address
}

output "k3s_worker_ips" {
  value = [for i in proxmox_vm_qemu.k3s_worker : i.default_ipv4_address]
}
