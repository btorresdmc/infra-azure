locals {
  idapp = "btorres" # btorres
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "b497fd69-266c-46a9-b55b-8be0cd579667" # Id de suscripción
}
