variable "azure-subscription-id" {}

variable "azure-service-principal-id" {}

variable "azure-service-principal-secret" {}

variable "azure-tenant-id" {}

variable "namespace" {
  type        = string
  description = "Namespace for all resources"

}

variable "location" {
  type        = string
  description = "The Azure region for all resources"
}

variable "environment" {
  type        = string
  description = "Environment tag"
}

variable "authorized-ips" {
  type        = string
  description = "IP Address for network security group access"
}

variable "ssh-key" {
  type        = string
  description = "Public Key For SSH Access"
}

variable "admin-user" {
  type        = string
  description = "Admin user name"
}

variable "jenkins-vm-size" {
  type        = string
  description = "Size for Jenkins VM"
}