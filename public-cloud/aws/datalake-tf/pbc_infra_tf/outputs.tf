# Copyright 2023 Cloudera, Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
