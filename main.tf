module "container_apps" {
  source = "./module/"
  tenants = var.tenants
}