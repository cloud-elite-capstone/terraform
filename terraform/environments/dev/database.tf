resource "random_password" "db_password" {
  length  = 32
  special = false
}

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

  db_name       = "user_db"
  user_name     = "cartesian"
  user_password = random_password.db_password.result

  additional_databases = [
    { name = "shop_db", charset = "UTF8", collation = "en_US.UTF8" },
    { name = "product_db", charset = "UTF8", collation = "en_US.UTF8" },
    { name = "order_db", charset = "UTF8", collation = "en_US.UTF8" },
    { name = "agent_db", charset = "UTF8", collation = "en_US.UTF8" },
  ]
}
