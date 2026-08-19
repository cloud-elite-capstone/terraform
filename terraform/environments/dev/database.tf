module "default" {
  source = "terraform-google-modules/sql-db/google//modules/postgresql"

  name             = "db"
  database_version = "POSTGRES_18"
  project_id       = var.project_id

  edition = "ENTERPRISE"
  tier    = "db-f1-micro"

  ip_configuration = {
    ipv4_enabled    = true
    private_network = module.vpc.network.network_id
  }
}
