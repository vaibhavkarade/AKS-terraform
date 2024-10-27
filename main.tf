# main.tf

# Specify the Azure provider
provider "azurerm" {
  features {}

subscription_id = "<YOUR_SUBSCRIPTION_ID>"
}

# Define variables for resource customization
variable "resource_group_name" {
  default = "myAKSResourceGroup"
}
variable "aks_cluster_name" {
  default = "myAKSCluster"
}
variable "location" {
  default = "East US"
}

# Resource Group for AKS
resource "azurerm_resource_group" "aks" {
  name     = var.resource_group_name
  location = var.location
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "myAKSdns"

  # Default node pool configuration
  default_node_pool {
    name       = "nodepool"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  # Integrate with Azure CLI for Authentication
  tags = {
    environment = "development"
  }
}

# Output the Kubernetes configuration
output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive = true
}
