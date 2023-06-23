data "azurerm_virtual_network" "tp4" {
  name                = "network-tp4"
  resource_group_name = "ADDA84-CTP"
}

data "azurerm_subnet" "tp4" {
  name                 = "internal"
  virtual_network_name = "network-tp4"
  resource_group_name  = "ADDA84-CTP"
}

data "azurerm_resource_group" "tp4" {
  name     = "ADDA84-CTP"
}

resource "tls_private_key" "tp4_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "azurerm_public_ip" "tp4" {
  name                = "public-ip"
  resource_group_name = data.azurerm_resource_group.tp4.name
}

resource "azurerm_network_interface" "tp4" {
  name                = "nic-sarah"
  location            = data.azurerm_resource_group.tp4.location
  resource_group_name = data.azurerm_resource_group.tp4.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.tp4.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = data.azurerm_public_ip.tp4.id
  }
}

resource "azurerm_linux_virtual_machine" "tp4" {
  name                  = "devops-20220016-single-machine"
  location              = data.azurerm_resource_group.tp4.location
  resource_group_name   = data.azurerm_resource_group.tp4.name
  size                   = "Standard_D2s_v3"
  admin_username        = "devops"
  disable_password_authentication = true
  
  admin_ssh_key {
      username   = "devops"
      public_key = tls_private_key.tp4_ssh.public_key_openssh
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface_ids = [
    azurerm_network_interface.tp4.id,
  ]
}
