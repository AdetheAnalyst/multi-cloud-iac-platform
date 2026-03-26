# Azure AKS Cluster Module
terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}

variable "cluster_name"       { type = string }
variable "resource_group"     { type = string }
variable "location"           { type = string }
variable "kubernetes_version" { type = string, default = "1.29" }
variable "environment"        { type = string }

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group
  kubernetes_version  = var.kubernetes_version
  dns_prefix          = var.cluster_name

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

output "cluster_endpoint" { value = azurerm_kubernetes_cluster.main.kube_config[0].host }
output "cluster_name"     { value = azurerm_kubernetes_cluster.main.name }
