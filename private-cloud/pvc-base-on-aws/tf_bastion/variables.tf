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

variable "asset_tags" {
  type        = map(any)
  default     = {}
  description = "Map of tags applied to all cloud-provider assets."
}

variable "ssh_key_pair" {
  type        = string
  description = "SSH key pair name"
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
  description = "Region"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID"
}

variable "security_group_name" {
  type = string
  description = "Name of the bastion security group"
  default = ""
}

variable "bastion_instance_name" {
  type = string
  description = "Name of the bastion instance"
  default = ""
}