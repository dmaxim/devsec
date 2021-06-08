resource "azurerm_resource_group" "cloud-sec-rg" {
    name = join("-", ["rg", var.namespace])
    location = var.location

    tags = {
        environment = var.environment
    }
}