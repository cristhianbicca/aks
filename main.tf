data "azurerm_virtual_network" "vnet" {
    name                = "${var.aks_vnet}"
    resource_group_name = "${var.resource_group_name}"    
}
data "azurerm_subnet" "kubernetes-subnet" {
    name = "${var.subnet_name}"
    virtual_network_name = "${var.aks_vnet}"
    resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_kubernetes_cluster" "cluster" {
    name = "${var.aks_cluster_name}"
    location = "${var.location}"
    resource_group_name = "${var.resource_group_name}"
    dns_prefix = "${var.dns_prefix}"
    kubernetes_version = "${var.kubernetes_version}"

    agent_pool_profile {
        name            = "default"
        count           = "${var.worker_count}"
        vm_size         = "${var.worker_size}"
        os_type         = "Linux"
        os_disk_size_gb = "${var.os_disk_size_gb}"
        vnet_subnet_id = "${data.azurerm_subnet.kubernetes-subnet.id}"
    }   
    network_profile {
        network_plugin = "azure"
        dns_service_ip = "${var.dns_service_ip}"        
        service_cidr = "${var.service_cidr}"
        docker_bridge_cidr = "${var.docker_bridge_cidr}"
    } 
    service_principal {
        client_id     = "${var.client_id}"
        client_secret = "${var.client_secret}"
    }  
}
