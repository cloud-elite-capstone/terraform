terraform {
  backend "gcs" {
    bucket = "cloud-elite-capstone-tfstate"
    prefix = "env/dev"
  }
}