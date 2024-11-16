resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}
resource "azurerm_virtual_network" "vnet_1" {
  name                = var.vnet_1_name
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.5.0.0/16"]
  location            = var.location
}

resource "azurerm_virtual_network" "vnet_2" {
  name                = var.vnet_2_name
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.15.0.0/16"]
  location            = var.location
}
resource "azurerm_virtual_network_peering" "peering" {
  name                         = var.peering_name
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet_1.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet1_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = var.vnet_1_name
  address_prefixes     = var.subnet_space1
}
resource "azurerm_subnet" "subnet2" {
  name                 = var.subnet2_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = var.vnet_2_name
  address_prefixes     = var.subnet_space2
}
resource "azurerm_ssh_public_key" "ssh" {
  name                = var.key
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  public_key          = file("~/.ssh/id_rsa.pub")
}

resource "azurerm_public_ip" "public-ip" {
  name                = var.public-ip_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
}



resource "azurerm_network_interface" "nicvm1" {
  name                = "vmnic1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  ip_configuration {
    name                          = var.ip_name
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public-ip.id
    subnet_id                     = azurerm_subnet.subnet1.id
  }
}
resource "azurerm_network_interface" "nicvm2" {
  name                = "nic-vm2"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet2.id
    private_ip_address            = var.private_ip
    private_ip_address_allocation = "Static"
  }

}

resource "azurerm_linux_virtual_machine" "vm1" {
  name                = var.vm1_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  admin_username        = var.admin
  network_interface_ids = [azurerm_network_interface.nicvm1.id]
  size                  = var.size

  admin_ssh_key {

    public_key = file("~/.ssh/id_rsa.pub")
    username   = var.admin
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "vm2" {
  name                = var.vm2_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B1s"
  admin_username      = var.admin
  admin_ssh_key {
    username   = var.admin
    public_key = file("~/.ssh/id_rsa.pub")
  }


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }


  network_interface_ids = [azurerm_network_interface.nicvm2.id]
}


