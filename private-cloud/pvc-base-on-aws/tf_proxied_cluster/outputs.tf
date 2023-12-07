output "ssh_key_pair" {
  value = {
    name        = aws_key_pair.pvc_base.key_name
    public_key  = data.local_file.ssh_public_key_file
    fingerprint = aws_key_pair.pvc_base.fingerprint
  }
  description = "SSH key"
}

# output "bastion" {
#   value = {
#     instance       = aws_instance.bastion
#     security_group = aws_security_group.bastion
#     ssh_key_pair = {
#       name        = aws_key_pair.pvc_base.key_name
#       public_key  = data.local_file.ssh_public_key_file
#       fingerprint = aws_key_pair.pvc_base.fingerprint
#     }
#   }
#   description = "Bastion host"
# }

output "availability_zones" {
  value       = module.cluster_network.availability_zones
  description = "AWS Availability Zones"
}

output "cluster" {
  value = {
    public_subnets               = module.cluster_network.public_subnets
    private_subnets              = module.cluster_network.private_subnets
    intra_cluster_security_group = module.cluster_network.intra_cluster_security_group
  }
  description = "Private Cloud cluster"
}

output "bastion" {
  value = {
    host           = module.bastion.host
    security_group = module.bastion.security_group
  }
  description = "Bastion host"
}
