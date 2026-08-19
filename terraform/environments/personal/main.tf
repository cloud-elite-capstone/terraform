# just t destroy -target=module.devpod_vm.google_compute_instance.vm

locals {
  devpod_ssh_keys = "${var.devpod_ssh_user}:${var.devpod_ssh_public_key}"
}

resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnetwork_name
  network       = google_compute_network.vpc.self_link
  region        = var.region
  ip_cidr_range = var.subnet_cidr
  project       = var.project_id
}

resource "google_compute_disk" "devpod_data" {
  name            = "devpod-data"
  type            = var.devpod_data_disk_type
  zone            = "${var.region}-a"
  size            = var.devpod_data_disk_size_gb
  project         = var.project_id
  deletion_policy = "PREVENT"
}

resource "google_compute_disk" "devpod_boot" {
  name            = "devpod-boot"
  type            = var.devpod_boot_disk_type
  zone            = "${var.region}-a"
  image           = var.machine_image
  size            = var.boot_disk_size_gb
  project         = var.project_id
  deletion_policy = "PREVENT"
}

resource "google_compute_address" "devpod_static_ip" {
  name    = "devpod-static-ip"
  region  = var.region
  project = var.project_id
}

module "devpod_vm" {
  source = "../../modules/gcp-vm"

  instance_name = "devpod-c2-standard-8"
  machine_type  = var.machine_type
  zone          = "${var.region}-a"

  boot_disk_source = google_compute_disk.devpod_boot.self_link

  network          = google_compute_network.vpc.self_link
  subnetwork       = google_compute_subnetwork.subnet.self_link
  assign_public_ip = true
  nat_ip           = google_compute_address.devpod_static_ip.address

  tags = ["devpod", "ssh"]

  ssh_keys = local.devpod_ssh_keys

  attached_disks = [
    {
      source      = google_compute_disk.devpod_data.id
      device_name = "devpod-data"
    }
  ]

  startup_script = <<-EOT
    #!/bin/bash
    set -euo pipefail

    user="${var.devpod_ssh_user}"

    if ! id -u "$user" >/dev/null 2>&1; then
      useradd --create-home --shell /bin/bash "$user"
    fi

    DISK="/dev/disk/by-id/google-devpod-data"
    DATA_DIR="/var/lib/docker"

    for _ in $(seq 1 60); do
      [ -e "$DISK" ] && break
      sleep 1
    done

    if [ -e "$DISK" ]; then
      # Format the disk on first use only
      blkid "$DISK" >/dev/null 2>&1 || mkfs.ext4 -F "$DISK"

      mkdir -p "$DATA_DIR"
      mount "$DISK" "$DATA_DIR"

      # Persist the mount across reboots
      grep -qsF "$DISK" /etc/fstab || echo "$DISK $DATA_DIR ext4 defaults,discard 0 2" >> /etc/fstab

      # Route containerd's content store onto the data disk
      CONTAINERD_DIR="/var/lib/containerd"
      CONTAINERD_DATA="$DATA_DIR/containerd-data"

      if ! mountpoint -q "$CONTAINERD_DIR"; then
        mkdir -p "$CONTAINERD_DIR" "$CONTAINERD_DATA"

        # Migrate any existing boot-disk content on first run
        if [ -n "$(ls -A "$CONTAINERD_DIR" 2>/dev/null)" ]; then
          cp -a "$CONTAINERD_DIR"/. "$CONTAINERD_DATA"/
          rm -rf "$CONTAINERD_DIR"
          mkdir -p "$CONTAINERD_DIR"
        fi

        mount --bind "$CONTAINERD_DATA" "$CONTAINERD_DIR"
        grep -qsF "$CONTAINERD_DATA $CONTAINERD_DIR" /etc/fstab || echo "$CONTAINERD_DATA $CONTAINERD_DIR none bind nofail 0 0" >> /etc/fstab
      fi
    else
      echo "Persistent disk $DISK not found; Docker data will live on the boot disk" >&2
    fi

    curl -fsSL https://get.docker.com | sh

    usermod -aG docker "$user"
    usermod -aG sudo "$user"

    systemctl enable --now docker
  EOT
}

resource "google_compute_firewall" "devpod_ssh" {
  name    = "allow-devpod-ssh"
  network = google_compute_network.vpc.self_link
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.devpod_ssh_source_ranges
  target_tags   = ["devpod"]
}

resource "google_compute_firewall" "devpod_egress" {
  name    = "allow-devpod-egress"
  network = google_compute_network.vpc.self_link
  project = var.project_id

  direction          = "EGRESS"
  priority           = 1000
  destination_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "all"
  }

  target_tags = ["devpod"]
}
