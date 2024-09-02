
locals {
  container_apps = flatten([
    for tenant in var.tenants : [
      for app_name in tenant.container_app_names : {
        tenant_name = tenant.tenant_name
        app_name     = app_name
      }
    ]
  ])
}

# Resource Groups
resource "azurerm_resource_group" "example" {
  #for_each = { for tenant in var.tenants : tenant.tenant_name => tenant }

  name     = format("%s-rg", "amit")
  location = "West Europe"
}

# Log Analytics Workspaces
resource "azurerm_log_analytics_workspace" "example" {
  for_each = { for tenant in var.tenants : tenant.tenant_name => tenant }

  name                = format("%s-law", each.key)
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
}

# Container App Environments
resource "azurerm_container_app_environment" "example" {
  for_each = { for tenant in var.tenants : tenant.tenant_name => tenant }

  name                       = format("%s-env", each.key)
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example[each.key].id
}

# RabbitMQ Container App
resource "azurerm_container_app" "rabbitmq" {
  for_each = {
    for app in local.container_apps : "${app.tenant_name}-${app.app_name}" => app
    if app.app_name == "rabbitmq"
  }

  name                         = format("%s-rabbitmq", each.value.tenant_name)
  container_app_environment_id = azurerm_container_app_environment.example[each.value.tenant_name].id
  resource_group_name          = azurerm_resource_group.example.name
  revision_mode                = "Single"

  template {
    container {
      name   = "rabbitmq"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"

    }
  }
}

# Inservice Container App
resource "azurerm_container_app" "inservice" {
  for_each = {
    for app in local.container_apps : "${app.tenant_name}-${app.app_name}" => app
    if app.app_name == "inservice"
  }

  name                         = format("%s-inservice", each.value.tenant_name)
  container_app_environment_id = azurerm_container_app_environment.example[each.value.tenant_name].id
  resource_group_name          = azurerm_resource_group.example.name
  revision_mode                = "Single"

  template {
    container {
      name   = "inservice"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"

    
    }
  }
}

# Scheduler Container App
resource "azurerm_container_app" "scheduler" {
  for_each = {
    for app in local.container_apps : "${app.tenant_name}-${app.app_name}" => app
    if app.app_name == "scheduler"
  }

  name                         = format("%s-scheduler", each.value.tenant_name)
  container_app_environment_id = azurerm_container_app_environment.example[each.value.tenant_name].id
  resource_group_name          = azurerm_resource_group.example.name
  revision_mode                = "Single"

  template {
  container {
      name   = "rabbitmq"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"

    }
  }
}