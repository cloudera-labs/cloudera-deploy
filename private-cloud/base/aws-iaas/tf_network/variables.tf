# Copyright 2023 Cloudera, Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# ------- Required -------

variable "asset_tags" {
  type        = map(any)
  default     = {}
  description = "Map of tags applied to all cloud-provider assets"
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
  description = "AWS region"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

# ------- Network Resources -------

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
  type        = string
  description = "NAT gateway name"
  default     = ""
}

variable "private_route_table_name" {
  type        = string
  description = "Private Route Table name prefix"
  default     = ""
}

# Security Groups
variable "security_group_intra_name" {
  type        = string
  description = "Security Group for intra-cluster communication"
  default     = ""
}
