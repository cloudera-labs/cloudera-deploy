# ------- Global settings -------
variable "aws_region" {
  type        = string
  description = "Region which Cloud resources will be created"
}

variable "env_prefix" {
  type        = string
  description = "Shorthand name for the environment. Used in resource descriptions"
}

variable "infra_type" {
  type        = string
  description = "Cloud Provider to deploy CDP."

}

variable "aws_key_pair" {
  type = string

  description = "Name of the Public SSH key for the CDP environment"

}

# ------- CDP Environment Deployment -------
variable "deployment_template" {
  type = string

  description = "Deployment Pattern to use for Cloud resources and CDP"
}

# ------- Cloud Service Provider Settings - AWS specific -------

variable "aws_vpc_id" {
  type        = string
  description = "AWS Virtual Private Network ID. Required for CDP deployment on AWS."

}

variable "aws_public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet ids. Required for CDP deployment on AWS."

}

variable "aws_private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet ids. Required for CDP deployment on AWS."

}

variable "aws_security_group_default_id" {
  type = string

  description = "ID of the Default Security Group for CDP environment. Required for CDP deployment on AWS."

}

variable "aws_security_group_knox_id" {
  type = string

  description = "ID of the Knox Security Group for CDP environment. Required for CDP deployment on AWS."

}

variable "data_storage_location" {
  type        = string
  description = "Data storage location. The location has to be in uri format for the cloud provider - i.e. s3a:// for AWS, abfs:// for Azure,  gs://"
}

variable "log_storage_location" {
  type        = string
  description = "Log storage location. The location has to be in uri format for the cloud provider - i.e. s3a:// for AWS, abfs:// for Azure,  gs://"
}

variable "backup_storage_location" {
  type        = string
  description = "Backup storage location. The location has to be in uri format for the cloud provider - i.e. s3a:// for AWS, abfs:// for Azure,  gs://"
}

variable "aws_datalake_admin_role_arn" {
  type = string

  description = "Datalake Admin Role ARN. Required for CDP deployment on AWS."

}

variable "aws_ranger_audit_role_arn" {
  type = string

  description = "Ranger Audit Role ARN. Required for CDP deployment on AWS."

}

variable "aws_xaccount_role_arn" {
  type = string

  description = "Cross Account Role ARN. Required for CDP deployment on AWS."

}

variable "aws_log_instance_profile_arn" {
  type = string

  description = "Log Instance Profile ARN. Required for CDP deployment on AWS."

}

variable "aws_idbroker_instance_profile_arn" {
  type = string

  description = "IDBroker Instance Profile ARN. Required for CDP deployment on AWS."

}
