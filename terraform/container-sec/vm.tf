# Create random id for storage account for diagnostics data
resource "random_id" "randomId" {
  keepers = {
    resource_group = azurerm_resource_group.cloud-sec-rg.name
  }

  byte_length = 8
}


# Create storage account
resource "azurerm_storage_account" "cloud-sec-vm-storage" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.cloud-sec-rg.name
  location                 = azurerm_resource_group.cloud-sec-rg.location
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = {
    environment = var.environment
  }
}

# Create VM

resource "azurerm_virtual_machine" "jenkins-vm-01" {
  name                  = join("-", ["vm", var.namespace, var.environment, "001"])
  resource_group_name   = azurerm_resource_group.cloud-sec-rg.name
  location              = azurerm_resource_group.cloud-sec-rg.location
  network_interface_ids = [azurerm_network_interface.jenkins-nic.id]
  vm_size               = var.jenkins-vm-size

  storage_os_disk {
    name              = join("-", ["disk", var.namespace, var.environment, "001"])
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_profile {
    computer_name  = join("-", ["vm", var.namespace, var.environment, "001"])
    admin_username = var.admin-user
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = var.admin-ssh-key-path
      key_data = var.ssh-key
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.cloud-sec-vm-storage.primary_blob_endpoint
  }

  tags = {
    environment = var.environment
  }
}