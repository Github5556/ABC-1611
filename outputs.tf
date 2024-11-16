# Output the public IP for VM1
output "public_ip_vm1" {
  description = "The public IP address of vm1"
  value       = azurerm_public_ip.public-ip.ip_address
}

# Output the private IP for VM2
output "private_ip_vm2" {
  description = "The private IP address of vm2"
  value       = azurerm_network_interface.nicvm2.ip_configuration[0].private_ip_address
}

