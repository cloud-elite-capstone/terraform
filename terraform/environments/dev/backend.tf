terraform {
  backend "gcs" {
    bucket = "cloud-elite-retail-tfstate"
    prefix = "env/dev"
  }
}
