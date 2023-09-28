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

module "cdp_deploy" {
  source = "git::https://github.com/cloudera-labs/terraform-cdp-modules.git//modules/terraform-cdp-deploy?ref=v0.3.0"

  env_prefix          = var.env_prefix
  infra_type          = "aws"
  region              = var.aws_region
  keypair_name        = var.aws_key_pair
  deployment_template = var.deployment_template

  aws_vpc_id             = var.aws_vpc_id
  aws_public_subnet_ids  = var.aws_public_subnet_ids
  aws_private_subnet_ids = var.aws_private_subnet_ids

  aws_security_group_default_id = var.aws_security_group_default_id
  aws_security_group_knox_id    = var.aws_security_group_knox_id

  data_storage_location   = var.data_storage_location
  log_storage_location    = var.log_storage_location
  backup_storage_location = var.backup_storage_location

  aws_xaccount_role_arn       = var.aws_xaccount_role_arn
  aws_datalake_admin_role_arn = var.aws_datalake_admin_role_arn
  aws_ranger_audit_role_arn   = var.aws_ranger_audit_role_arn

  aws_log_instance_profile_arn      = var.aws_log_instance_profile_arn
  aws_idbroker_instance_profile_arn = var.aws_idbroker_instance_profile_arn

}