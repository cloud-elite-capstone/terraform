variable "project_id" {
  type = string
}

variable "gcp_service_account_email" {
  type        = string
  description = "Service account email to impersonate"
}

variable "region" {
  type    = string
  default = "asia-southeast1"
}

variable "network_name" {
  type        = string
  default     = "cloud-elite-personal-vpc"
  description = "Name of the VPC network created for the DevPod VM"
}

variable "subnetwork_name" {
  type        = string
  default     = "personal-subnet-01"
  description = "Name of the subnet created for the DevPod VM"
}

variable "subnet_cidr" {
  type        = string
  default     = "10.30.0.0/24"
  description = "CIDR range of the subnet created for the DevPod VM"
}

variable "machine_type" {
  type        = string
  default     = "c2-standard-4"
  description = "Machine type for the DevPod VM"
}

variable "machine_image" {
  type        = string
  default     = "projects/debian-cloud/global/images/debian-13-trixie-v20260811"
  description = "Boot image for the DevPod VM"
}

variable "boot_disk_size_gb" {
  type        = number
  default     = 20
  description = "Size of the DevPod VM boot disk in GB"
}

variable "devpod_boot_disk_type" {
  type        = string
  default     = "pd-balanced"
  description = "Type of the DevPod VM boot disk"
}

variable "devpod_ssh_user" {
  type        = string
  default     = "devpod"
  description = "Username that DevPod uses to SSH into the VM"
}

variable "devpod_ssh_public_key" {
  type        = string
  description = "Public SSH key (e.g. 'ssh-ed25519 AAAA...') authorized on the DevPod VM"
}

variable "devpod_ssh_source_ranges" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "CIDR ranges allowed to SSH into the DevPod VM"
}

variable "devpod_data_disk_size_gb" {
  type        = number
  default     = 200
  description = "Size of the persistent data disk for the DevPod VM in GB"
}

variable "devpod_data_disk_type" {
  type        = string
  default     = "pd-ssd"
  description = "Type of the persistent data disk for the DevPod VM"
}
