# Create Virtual Network
resource "azurerm_virtual_network" "cloud-sec-network" {
  name                = join("-", ["snet", var.namespace, var.environment])
  location            = azurerm_resource_group.cloud-sec-rg.location
  resource_group_name = azurerm_resource_group.cloud-sec-rg.name
  address_space       = ["10.1.0.0/16"]
}

# Create subnet
resource "azurerm_subnet" "cloud-sec-subnet" {
  name                 = join("-", ["vnet", var.namespace, var.environment])
  resource_group_name  = azurerm_resource_group.cloud-sec-rg.name
  address_prefixes     = ["10.1.1.0/24"]
  virtual_network_name = azurerm_virtual_network.cloud-sec-network.name

}

# Create Newtork Security Group

resource "azurerm_network_security_group" "cloud-sec-nsg" {
  name                = join("-", ["nsg", var.namespace, var.environment])
  location            = var.location
  resource_group_name = azurerm_resource_group.cloud-sec-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.authorized-ips
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
  }
}

# Allow Port 80

resource "azurerm_network_security_rule" "jenkins-80" {
  name                        = "Port_80"
  priority                    = 320
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = var.authorized-ips
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.cloud-sec-rg.name
  network_security_group_name = azurerm_network_security_group.cloud-sec-nsg.name
}

# Allow Port 443
resource "azurerm_network_security_rule" "jenkins-443" {
  name                        = "Port_443"
  priority                    = 330
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.authorized-ips
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.cloud-sec-rg.name
  network_security_group_name = azurerm_network_security_group.cloud-sec-nsg.name
}


resource "azurerm_network_security_rule" "jenkins-8080" {
  name                        = "Port_8080"
  priority                    = 350
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = var.authorized-ips
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.cloud-sec-rg.name
  network_security_group_name = azurerm_network_security_group.cloud-sec-nsg.name
}


resource "azurerm_network_security_rule" "jenkins-50000" {
  name                        = "Port_50000"
  priority                    = 360
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "50000"
  source_address_prefix       = var.authorized-ips
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.cloud-sec-rg.name
  network_security_group_name = azurerm_network_security_group.cloud-sec-nsg.name
}
# Create public ip for the vm
resource "azurerm_public_ip" "jenkins-public-ip" {
  name                = join("-", ["pip", var.namespace, var.environment, "01"])
  location            = var.location
  resource_group_name = azurerm_resource_group.cloud-sec-rg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = var.environment
  }
}

# Create NIC
resource "azurerm_network_interface" "jenkins-nic" {
  name                = join("-", ["nic", var.namespace, var.environment, "001"])
  location            = var.location
  resource_group_name = azurerm_resource_group.cloud-sec-rg.name

  ip_configuration {
    name                          = join("-", ["nic-config", var.namespace, var.environment, "001"])
    subnet_id                     = azurerm_subnet.cloud-sec-subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.jenkins-public-ip.id
  }

  tags = {
    environment = var.environment
  }
}


resource "azurerm_application_security_group" "cloud-sec-asg" {
  name                = join("-", ["asg", var.namespace, var.environment])
  location            = azurerm_resource_group.cloud-sec-rg.location
  resource_group_name = azurerm_resource_group.cloud-sec-rg.name

}
resource "azurerm_network_interface_application_security_group_association" "cloud-sec-sga" {
  network_interface_id          = azurerm_network_interface.jenkins-nic.id
  application_security_group_id = azurerm_application_security_group.cloud-sec-asg.id
}