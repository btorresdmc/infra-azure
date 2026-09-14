# 1. Referencias a la infraestructura existente (Laboratorio 1)
data "azurerm_resource_group" "main" {
  name = "rg-cicd-terraform-app-${local.idapp}"
}

data "azurerm_container_registry" "acr" {
  name                = "acr${local.idapp}"
  resource_group_name = data.azurerm_resource_group.main.name
}

# 2. Identidad Administrada independiente (Soluciona el error de lista vacía en principal_id)
resource "azurerm_user_assigned_identity" "aca_identity" {
  name                = "id-aca-${local.idapp}-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
}

# 3. Asignación del rol AcrPull sobre el ACR usando la identidad creada
resource "azurerm_role_assignment" "aca_pull_default_acr" {
  principal_id         = azurerm_user_assigned_identity.aca_identity.principal_id
  role_definition_name = "AcrPull"
  scope                = data.azurerm_container_registry.acr.id
}

# 4. Entorno administrado de Container Apps
resource "azurerm_container_app_environment" "aca_env" {
  name                = "aca-env-${local.idapp}-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
}

# 5. Microservicio en Azure Container Apps
resource "azurerm_container_app" "aca" {
  name                         = "aca-ms-${local.idapp}-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  resource_group_name          = data.azurerm_resource_group.main.name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aca_identity.id]
  }

  template {
    container {
      name   = "demo"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.5
      memory = "1Gi"
    }
  }

  ingress {
    external_enabled           = true
    target_port                = 80
    allow_insecure_connections = false

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].container[0].image,
      registry
    ]
  }

  depends_on = [
    azurerm_container_app_environment.aca_env,
    azurerm_role_assignment.aca_pull_default_acr
  ]
}
# resource "azurerm_container_registry" "acr" {
#   name                = "acr${local.idapp}${var.environment}"
#   resource_group_name = data.azurerm_resource_group.main.name
#   location            = data.azurerm_resource_group.main.location
#   sku                 = "Basic"
#   admin_enabled       = false
# }

# Dar permisos al ACA para leer del ACR
# resource "azurerm_role_assignment" "aca_pull" {
#   principal_id         = azurerm_container_app.aca.identity[0].principal_id
#   role_definition_name = "AcrPull"
#   scope                = azurerm_container_registry.acr.id
# }

