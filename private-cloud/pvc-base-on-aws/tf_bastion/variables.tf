variable "asset_tags" {
  type        = map(any)
  default     = {}
  description = "Map of tags applied to all cloud-provider assets."
}

variable "ssh_public_key_file" {
  type        = string
  description = "Local SSH public key file"
}

variable "prefix" {
  type        = string
  description = "Deployment prefix for all cloud-provider assets."

  validation {
    condition     = length(var.prefix) < 8 || length(var.prefix) > 4
    error_message = "Valid length for prefix is between 4-7 characters."
  }
}

variable "region" {
  type        = string
  description = "Target AWS region"
}

variable "vpc_id" {
  type        = string
  description = "Target VPC ID"
}

variable "subnet_id" {
  type        = string
  description = "Target Subnet ID"
}
