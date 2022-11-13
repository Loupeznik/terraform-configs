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

resource "azurerm_resource_group" "test" {
  name     = "rg_dz_kube_test_01"
  location = "North Europe"
}

resource "azurerm_virtual_network" "test" {
  name                = "net_dz_kube_test_01"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  address_space       = ["10.13.0.0/16"]
}

resource "azurerm_subnet" "test" {
  name                 = "snet_dz_kube_test_01"
  resource_group_name  = azurerm_resource_group.test.name
  address_prefixes     = ["10.13.37.0/24"]
  virtual_network_name = azurerm_virtual_network.test.name
}

resource "azurerm_kubernetes_cluster" "test" {
  name                = "aks_dz_kube_test_01"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  dns_prefix          = "dz-kube-01"
  automatic_channel_upgrade = "stable"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_B2s"
    vnet_subnet_id = azurerm_subnet.test.id
    os_disk_size_gb = 32
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"

    load_balancer_profile {
      managed_outbound_ip_count = 1
    }
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.test.kube_config_raw
  sensitive = true
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.test.kube_config[0].client_certificate
  sensitive = true
}
