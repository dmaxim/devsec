resource "azurerm_resource_group" "cloud-sec-rg" {
  name     = join("-", ["rg", var.namespace, var.environment])
  location = var.location

  tags = {
    environment = var.environment
  }
}