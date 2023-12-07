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
  description = "AWS region"
}

# ------- Network Resources -------

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
