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
  subscription_id = "708e9960-cf5d-4687-857d-e9babbb2d87c" # Id de suscripción
}
