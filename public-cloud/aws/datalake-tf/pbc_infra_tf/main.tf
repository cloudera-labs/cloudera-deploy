##### Terraform and Provider Configuration #####
terraform {
  required_providers {
    cdp = {
      source  = "cloudera/cdp"
      version = "0.1.4-pre"
    }
  }

  required_version = ">= 0.13"
}

provider "aws" {
  region = var.aws_region
}

##### Create SSH keys and AWS keypair #####

# Create and save a RSA key
resource "tls_private_key" "cdp_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save the private key to <env_prefix>-ssh-key.pem
resource "local_sensitive_file" "pem_file" {
  filename             = "${var.env_prefix}-ssh-key.pem"
  file_permission      = "600"
  directory_permission = "700"
  content              = tls_private_key.cdp_private_key.private_key_pem
}

# Save the public key to <env_prefix>-ssh-key.pub
resource "local_file" "pub_file" {
  filename             = "${var.env_prefix}-ssh-key.pub"
  content              = tls_private_key.cdp_private_key.public_key_openssh
}

# Create an AWS EC2 keypair from the generated public key
resource "aws_key_pair" "cdp_keypair" {
  key_name   = "${var.env_prefix}-keypair"
  public_key = tls_private_key.cdp_private_key.public_key_openssh
}

##### Find xaccount ids using CDP provider data source #####

# Use the CDP Terraform Provider to find the xaccount account and external ids
data "cdp_environments_aws_credential_prerequisites" "cdp_prereqs" {}

##### Create the AWS pre-requisite resources for CDP #####
# Using the terraform-cdp-aws-pre-reqs module
module "cdp_aws_prereqs" {
  source = "git::https://github.com/cloudera-labs/terraform-cdp-modules.git//modules/terraform-cdp-aws-pre-reqs?ref=v0.2.0"

  env_prefix = var.env_prefix
  aws_region = var.aws_region

  deployment_template           = var.deployment_template
  ingress_extra_cidrs_and_ports = var.ingress_extra_cidrs_and_ports

  # Using CDP TF Provider cred pre-reqs data source for values of xaccount account_id and external_id
  xaccount_account_id  = data.cdp_environments_aws_credential_prerequisites.cdp_prereqs.account_id
  xaccount_external_id = data.cdp_environments_aws_credential_prerequisites.cdp_prereqs.external_id


}