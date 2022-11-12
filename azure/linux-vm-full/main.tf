terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "rg_dz_test_01"
  location = "North Europe"
}

resource "azurerm_virtual_network" "test" {
  name                = "net_dz_test_01"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_public_ip" "test" {
  name                = "pubip_dz_test_01"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "test"
  }
}

resource "azurerm_subnet" "test" {
  name                 = "snet_dz_test_01"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.1.3.0/24"]
}

resource "azurerm_network_interface" "test" {
  name                = "nic_dz_test_01"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  ip_configuration {
    name                          = "ipc_dz_test_01"
    subnet_id                     = azurerm_subnet.test.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.test.id
  }
}

resource "azurerm_network_security_group" "test" {
  name                = "nsg_dz_test_01"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  security_rule {
    name                       = "nsg_dz_test_01_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "test"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.test.id
  network_security_group_id = azurerm_network_security_group.test.id
}

resource "azurerm_marketplace_agreement" "almalinux" {
  publisher = "almalinux"
  offer     = "almalinux"
  plan      = "9-gen2"
}

resource "azurerm_linux_virtual_machine" "test" {
  name                = "az-almalinux-0"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  size                = "Standard_B1s"
  admin_username      = "master"
  network_interface_ids = [
    azurerm_network_interface.test.id,
  ]

  admin_ssh_key {
    username   = "master"
    public_key = file("~/.ssh/tf_tests_id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "almalinux"
    offer     = "almalinux"
    sku       = "9-gen2"
    version   = "latest"
  }

  plan {
    name      = "9-gen2"
    product   = "almalinux"
    publisher = "almalinux"
  }
}
