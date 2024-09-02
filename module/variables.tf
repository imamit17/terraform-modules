variable "tenants" {
  type = list(object({
    tenant_name         = string
    container_app_names = list(string)
  }))
}
