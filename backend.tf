terraform {
  backend "azurerm" {
    resource_group_name  = "rg-cicd-terraform-app-btorres" # Reemplazar por btorre
    storage_account_name = "tfstatebtorres"                # Reemplazar por btorres
    container_name       = "tfstate"
    key                  = "dev/terraform.tfstate"
  }
}