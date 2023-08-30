output "aws_key_name" {
  value = aws_key_pair.cdp_keypair.key_name
}

output "aws_vpc_id" {
  value = module.cdp_aws_prereqs.aws_vpc_id
}

output "aws_public_subnet_ids" {
  value = module.cdp_aws_prereqs.aws_public_subnet_ids
}

output "aws_private_subnet_ids" {
  value = module.cdp_aws_prereqs.aws_private_subnet_ids
}

output "aws_security_group_default_id" {
  value = module.cdp_aws_prereqs.aws_security_group_default_id
}

output "aws_security_group_knox_id" {
  value = module.cdp_aws_prereqs.aws_security_group_knox_id
}

output "aws_data_storage_location" {
  value = module.cdp_aws_prereqs.aws_data_storage_location
}

output "aws_log_storage_location" {
  value = module.cdp_aws_prereqs.aws_log_storage_location
}

output "aws_backup_storage_location" {
  value = module.cdp_aws_prereqs.aws_backup_storage_location
}

output "aws_xaccount_role_arn" {
  value = module.cdp_aws_prereqs.aws_xaccount_role_arn
}

output "aws_datalake_admin_role_arn" {
  value = module.cdp_aws_prereqs.aws_datalake_admin_role_arn
}

output "aws_ranger_audit_role_arn" {
  value = module.cdp_aws_prereqs.aws_ranger_audit_role_arn
}

output "aws_log_instance_profile_arn" {
  value = module.cdp_aws_prereqs.aws_log_instance_profile_arn
}

output "aws_idbroker_instance_profile_arn" {
  value = module.cdp_aws_prereqs.aws_idbroker_instance_profile_arn
}
