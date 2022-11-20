terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">3.30.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "random" {}

resource "azurerm_resource_group" "test" {
  name     = "rg-${var.resource_id_suffix}"
  location = var.region
}

resource "random_string" "storageaccount_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_storage_account" "test" {
  name                     = "storageaccount${random_string.storageaccount_suffix.result}"
  resource_group_name      = azurerm_resource_group.test.name
  location                 = azurerm_resource_group.test.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [
    random_string.storageaccount_suffix
  ]
}

resource "azurerm_storage_container" "app" {
  name                  = "content-${var.resource_id_suffix}"
  storage_account_name  = azurerm_storage_account.test.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "uploads" {
  name                  = "uploads"
  storage_account_name  = azurerm_storage_account.test.name
  container_access_type = "private"
}

resource "azurerm_service_plan" "test" {
  name                = "sp-${var.resource_id_suffix}"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_function_app" "test" {
  name                = "app-fn-file-upload-${var.resource_id_suffix}"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location

  storage_account_name       = azurerm_storage_account.test.name
  storage_account_access_key = azurerm_storage_account.test.primary_access_key
  service_plan_id            = azurerm_service_plan.test.id

  enabled    = true
  https_only = true

  app_settings = {
    "UploadEndpoint"           = azurerm_storage_account.test.primary_connection_string,
    "WEBSITE_RUN_FROM_PACKAGE" = "https://objectstorage.eu-frankfurt-1.oraclecloud.com/p/qxGpF1-ASPCxLPuAq2ZUg_3LmiW6hVwMpScxN_-7tJks1wE2KS_cXLvHDY-WaMC5/n/frnn9qvlbnoj/b/apps/o/az-functions/cloud_upload_function.zip"
  }

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
  }
}

output "hostname" {
  value = azurerm_linux_function_app.test.default_hostname
}

output "file_upload_endpoint" {
  value = "https://${azurerm_linux_function_app.test.default_hostname}/api/upload?code=<code_from_portal>"
}
