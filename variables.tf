variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
    sensitive = true
}

variable "proxmox_api_token_secret" {
  type = string
  sensitive = true
}

variable "start_vmid" {
    type = number    
    default = 3330
}