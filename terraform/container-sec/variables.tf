variable "azure-subscription-id" {}

variable "azure-service-principal-id" {}

variable "azure-service-principal-secret" {}

variable "azure-tenant-id" {}

variable "namespace" {
 type = string
 description = "Namespace for all resources"

}

variable "location" {
    type = string
    description = "The Azure region for all resources"
}