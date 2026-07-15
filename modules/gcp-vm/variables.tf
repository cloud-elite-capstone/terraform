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