locals {
  default_invoker = [
    local.service_account_members.compute_default,
  ]

  # Services with no outbound calls to other services
  leaf_services = {
    for name, image in var.server_images : name => image
    if name != "agent-service"
  }

  service_ports = {
    "user-service"    = 8081
    "shop-service"    = 8082
    "product-service" = 8083
    "order-service"   = 8084
    "agent-service"   = 8085
  }

  db_names = {
    "user-service"    = "user_db"
    "shop-service"    = "shop_db"
    "product-service" = "product_db"
    "order-service"   = "order_db"
    "agent-service"   = "agent_db"
  }

  db_connection_name = module.default.instance_connection_name
  db_user            = "cartesian"

  cloud_sql_annotations = {
    "run.googleapis.com/client-name"        = "terraform"
    "generated-by"                          = "terraform"
    "autoscaling.knative.dev/maxScale"      = "2"
    "autoscaling.knative.dev/minScale"      = "1"
    "run.googleapis.com/cloudsql-instances" = local.db_connection_name
  }
}

module "backend_servers" {
  source = "GoogleCloudPlatform/cloud-run/google"

  for_each = local.leaf_services

  location   = var.region
  project_id = var.project_id

  image        = each.value
  service_name = each.key

  members = local.default_invoker
  ports   = { name = "http1", port = local.service_ports[each.key] }

  template_annotations = local.cloud_sql_annotations

  env_vars = [
    { name = "SPRING_PROFILES_ACTIVE", value = "cloud" },
    {
      name  = "DB_URL"
      value = "jdbc:postgresql:///${local.db_names[each.key]}?cloudSqlInstance=${local.db_connection_name}&socketFactory=com.google.cloud.sql.postgres.SocketFactory"
    },
    { name = "DB_USERNAME", value = local.db_user },
  ]

  env_secret_vars = [
    {
      name = "DB_PASSWORD"
      value_from = [{
        secret_key_ref = {
          name = google_secret_manager_secret.db_password.secret_id
          key  = "latest"
        }
      }]
    },
  ]

  depends_on = [google_secret_manager_secret_version.db_password]
}

module "agent_service" {
  source = "GoogleCloudPlatform/cloud-run/google"

  location   = var.region
  project_id = var.project_id

  image        = var.server_images["agent-service"]
  service_name = "agent-service"

  members = local.default_invoker
  ports   = { name = "http1", port = local.service_ports["agent-service"] }

  timeout_seconds = 600

  template_annotations = local.cloud_sql_annotations

  env_vars = [
    { name = "SPRING_PROFILES_ACTIVE", value = "cloud" },
    { name = "PRODUCT_SERVICE_URL", value = module.backend_servers["product-service"].service_url },
    { name = "USER_SERVICE_URL", value = module.backend_servers["user-service"].service_url },
    { name = "SHOP_SERVICE_URL", value = module.backend_servers["shop-service"].service_url },
    { name = "ORDER_SERVICE_URL", value = module.backend_servers["order-service"].service_url },
    { name = "ID_TOKEN_ENABLED", value = "true" },
    {
      name  = "DB_URL"
      value = "jdbc:postgresql:///${local.db_names["agent-service"]}?cloudSqlInstance=${local.db_connection_name}&socketFactory=com.google.cloud.sql.postgres.SocketFactory"
    },
    { name = "DB_USERNAME", value = local.db_user },
  ]

  env_secret_vars = [
    {
      name = "GEMINI_API_KEY"
      value_from = [{
        secret_key_ref = {
          name = var.gemini_api_key_secret_id
          key  = "latest"
        }
      }]
    },
    {
      name = "DB_PASSWORD"
      value_from = [{
        secret_key_ref = {
          name = google_secret_manager_secret.db_password.secret_id
          key  = "latest"
        }
      }]
    },
  ]

  depends_on = [google_secret_manager_secret_version.db_password]
}
