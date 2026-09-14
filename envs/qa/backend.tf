terraform {
  backend "azurerm" {
    resource_group_name  = "rg-cicd-terraform-app-btorres" # Reemplazar por btorres
    storage_account_name = "tfstatebtorres"                # Reemplazar por btorres
    container_name       = "tfstate"
    key                  = "qa/terraform.tfstate"
  }
}