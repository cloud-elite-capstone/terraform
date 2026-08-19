variable "instance_name" {
  type        = string
  description = "The name of the VM"
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
}

variable "zone" {
  type    = string
  default = "asia-southeast1-a"
}

variable "network" {
  type        = string
  default     = "default"
  description = "The network to attach the VM to"
}

variable "machine_image" {
  type        = string
  default     = "debian-cloud/debian-13"
  description = "The image to use for the VM's boot disk"
}

variable "subnetwork" {
  type        = string
  default     = null
  description = "The subnetwork to attach the VM to. Defaults to the network's default subnetwork."
}

variable "boot_disk_size_gb" {
  type        = number
  default     = 100
  description = "Size of the boot disk in GB"
}

variable "boot_disk_type" {
  type        = string
  default     = "pd-balanced"
  description = "Type of the boot disk"
}

variable "boot_disk_source" {
  type        = string
  default     = null
  description = "Self link of an existing disk to use as the boot disk. When set, initialize_params is ignored and the disk is preserved (auto_delete = false) when the instance is deleted."
}

variable "assign_public_ip" {
  type        = bool
  default     = false
  description = "Assign a public IP address to the VM"
}

variable "nat_ip" {
  type        = string
  default     = null
  description = "Static external IP address to assign to the VM. When null and assign_public_ip is true, GCP assigns an ephemeral IP."
}

variable "tags" {
  type        = list(string)
  default     = []
  description = "Network tags applied to the VM for firewall rule targeting"
}

variable "ssh_keys" {
  type        = string
  default     = ""
  description = "Instance-level SSH keys in the format 'user:ssh-rsa AAAA...'"
}

variable "startup_script" {
  type        = string
  default     = ""
  description = "Startup script to run on first boot"
}

variable "allow_stopping_for_update" {
  type        = bool
  default     = true
  description = "Allow the instance to be stopped and restarted for updates such as machine type changes"
}

variable "attached_disks" {
  type = list(object({
    source      = string
    device_name = string
    mode        = optional(string, "READ_WRITE")
  }))
  default     = []
  description = "Persistent disks to attach to the VM"
}
