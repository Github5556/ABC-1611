

variable "resource_group_name" {
  default = "evaultion_rg"
}

variable "location" {
  default = "westeurope"
}

variable "vnet_1_name" {
  default = "network_1"
}
variable "vnet_2_name" {
  default = "network_2"
}
variable "peering_name" {
  default = "vnet_peering"
}
variable "subnet_space1" {
  default = ["10.5.1.0/24", "10.5.2.0/24"]
  type    = list(string)
}

variable "subnet_space2" {
  default = ["10.15.0.0/24", "10.15.2.0/24"]
  type    = list(string)
}


variable "subnet1_name" {
  default = "test_subnet1"
}

variable "subnet2_name" {
  default = "test_subnet2"
}

variable "key" {
  description = "SSH public key"
  type        = string
  default     = "testsshkey"
}
variable "nic_name" {
  default = "testic"
}
variable "public-ip_name" {
  default = "publicip"
}

variable "ip_name" {
  default = "ip"
}
variable "sku" {
  default = "22.04-LTS"
}
variable "admin" {
  default = "azureadmin"
}
variable "size" {
  default = "Standard_B1s"
}
variable "user" {
  default = "azureuser"
}

variable "private_ip" {
  description = "Static private IP address for the network interface"
  type        = string
  default     = "10.15.0.10"
}

variable "vm1_name" {
  default = "test1-vm"
}

variable "vm2_name" {
  default = "test2-vm"
}
