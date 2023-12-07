# ------- General and Provider Resources -------

variable "asset_tags" {
  type        = map(any)
  default     = {}
  description = "Map of tags applied to all cloud-provider assets"
}

variable "ssh_public_key_file" {
  type        = string
  description = "Local SSH public key file"
}

variable "prefix" {
  type        = string
  description = "Deployment prefix for all cloud-provider assets"

  validation {
    condition     = length(var.prefix) < 8 || length(var.prefix) > 4
    error_message = "Valid length for prefix is between 4-7 characters."
  }
}

variable "region" {
  type        = string
  description = "Target AWS region"
}

# ------- Network Resources -------
# VPC infrastructure
variable "vpc_name" {
  type        = string
  description = "VPC name"
  default     = ""
}

# TODO Convert to list of CIDR blocks
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR Block"
  default     = "10.10.0.0/16"
}

variable "igw_name" {
  type        = string
  description = "Internet Gateway name"
  default     = ""
}

# Public Network infrastructure
variable "public_subnet_name" {
  type        = string
  description = "Public Subnet name prefix"
  default     = ""
}

variable "public_subnets" {
  type = list(object({
    name = string
    cidr = string
    az   = string
    tags = map(string)
  }))

  description = "List of Public Subnet details (name, CIDR, AZ, add'l tags)"
  default     = []
}

variable "public_route_table_name" {
  type        = string
  description = "Public Route Table name prefix"
  default     = ""
}

# Private Network infrastructure
variable "private_subnet_name" {
  type        = string
  description = "Private Subnet name prefix"
  default     = ""
}

variable "private_subnets" {
  type = list(object({
    name = string
    cidr = string
    az   = string
    tags = map(string)
  }))

  description = "List of Private Subnet details (name, CIDR, AZ, add'l tags)"
  default     = []
}

variable "nat_gateway_name" {
  type = string

  description = "NAT gateway name"
  default     = ""
}

variable "private_route_table_name" {
  type = string

  description = "Private Route Table name prefix"
  default     = ""
}

# Security Groups
variable "security_group_intra_name" {
  type = string

  description = "Security Group for intra-cluster communication"
  default     = ""
}

# variable "security_group_intra_ingress" {
#   type       = list(object({
#     cidr       = list(string)
#     from_port  = string
#     to_port    = string
#     protocol   = string
#   }))

#   description = "Ingress rule details for intra-cluster Security Group"
#   default    = []
# }

# # ------- Storage Resources -------
# variable "storage_locations" {
#   type       = list(object({
#     bucket     = string
#     object     = string
#   }))

#   description = "Storage locations for CDP environment"
# }

# variable "teardown_deletes_data" {
#   type        = bool

#   description = "Purge storage locations during teardown"
# }

# variable "utility_bucket" {
#   type        = string

#   description = "Utility bucket used as a mirror for downloaded PvC parcels"
# }
