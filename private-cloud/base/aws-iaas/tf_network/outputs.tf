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

output "availability_zones" {
  value       = data.aws_availability_zones.pvc_base
  description = "AWS Availability Zones"
}

output "public_subnets" {
  value       = values(aws_subnet.pvc_base_public)
  description = "Cluster public subnets"
}

output "private_subnets" {
  value       = values(aws_subnet.pvc_base_private)
  description = "Cluster private subnets"
}

output "intra_cluster_security_group" {
  value       = aws_security_group.pvc_base
  description = "Intra-cluster traffic Security Group"
}
