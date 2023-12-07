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

output "ssh_key_pair" {
  value = {
    name        = aws_key_pair.pvc_base.key_name
    public_key  = data.local_file.ssh_public_key_file
    fingerprint = aws_key_pair.pvc_base.fingerprint
  }
  description = "SSH key"
}

output "vpc" {
  value       = aws_vpc.pvc_base
  description = "AWS VPC"
}

output "availability_zones" {
  value       = module.cluster_network.availability_zones
  description = "AWS Availability Zones"
}

output "cluster" {
  value = {
    public_subnets               = module.cluster_network.public_subnets
    private_subnets              = module.cluster_network.private_subnets
    intra_cluster_security_group = module.cluster_network.intra_cluster_security_group
  }
  description = "Private Cloud cluster"
}

output "bastion" {
  value = {
    host           = module.bastion.host
    security_group = module.bastion.security_group
  }
  description = "Bastion host"
}
