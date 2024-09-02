variable "tenants" {
  type = list(object({
    tenant_name          = string
    container_app_names  = list(string)
  }))
  description = "List of tenants with their respective container app names."
}
