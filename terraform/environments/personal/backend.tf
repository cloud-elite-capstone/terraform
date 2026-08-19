terraform {
  backend "gcs" {
    bucket = "cloud-elite-retail-tfstate"
    prefix = "env/personal"
  }

  # backend "local" {
  #   path = "./.terraform/terraform.tfstate"
  # }
}
