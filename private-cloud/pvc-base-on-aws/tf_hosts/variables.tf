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

variable "tags" {
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

# ------- Instances -------

variable "name" {
  type        = string
  description = "Instance name prefix"
  default     = ""
}

variable "quantity" {
  type        = number
  description = "Number of instances"
  default     = 1
}

variable "offset" {
  type        = number
  description = "Number offset for instance name"
  default     = 0
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs to provision the instances"
}

variable "security_groups" {
  type = list(string)
  description = "List of security group IDs to attach to the instances"
}

variable "public_ip" {
  type        = bool
  description = "Flag to assign public IP addresses to the hosts"
  default     = false
}

variable "instance_type" {
  type        = string
  description = "Instance type name for the hosts"
  default     = "t2.micro"
}

variable "image_id" {
  type        = string
  description = "AMI image ID for the hosts"
}

variable "root_volume" {
  type = object({
    delete_on_termination = optional(bool, true)
    volume_size           = optional(number, 100)
    volume_type           = optional(string)
  })
  description = "Root volume details"
  default     = {}
}

