tenants = [
  {
    tenant_name         = "ram"
    container_app_names = ["rabbitmq", "inservice"]
  },
  {
    tenant_name         = "amit"
    container_app_names = ["rabbitmq", "scheduler"]
  },
  {
    tenant_name         = "sid"
    container_app_names = ["inservice", "scheduler"]
  },
  {
    tenant_name         = "amul"
    container_app_names = ["inservice", "scheduler", "rabbitmq"]
  },
  {
    tenant_name         = "pariska"
    container_app_names = ["inservice", "scheduler", "rabbitmq"]
  }
]