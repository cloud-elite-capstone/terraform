terraform {
  # backend "gcs" {
  #   bucket = "cloud-elite-dev-tfstate"
  #   prefix = "env/dev"
  # }
  backend "local" {
    path = "./.terraform/terraform.tfstate"
  }
}