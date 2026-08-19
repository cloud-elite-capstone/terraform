resource "google_compute_instance" "vm" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  allow_stopping_for_update = var.allow_stopping_for_update

  tags = var.tags

  dynamic "boot_disk" {
    for_each = var.boot_disk_source == null ? [1] : []
    content {
      initialize_params {
        image = var.machine_image
        size  = var.boot_disk_size_gb
        type  = var.boot_disk_type
      }
    }
  }

  dynamic "boot_disk" {
    for_each = var.boot_disk_source != null ? [1] : []
    content {
      source      = var.boot_disk_source
      auto_delete = false
    }
  }

  dynamic "attached_disk" {
    for_each = var.attached_disks
    content {
      source      = attached_disk.value.source
      device_name = attached_disk.value.device_name
      mode        = attached_disk.value.mode
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    dynamic "access_config" {
      for_each = var.assign_public_ip ? [1] : []
      content {
        nat_ip = var.nat_ip
      }
    }
  }

  metadata_startup_script = var.startup_script != "" ? var.startup_script : null

  metadata = var.ssh_keys != "" ? {
    "ssh-keys" = var.ssh_keys
  } : null
}
