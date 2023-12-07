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

terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = ">= 4.60.0",
    }
  }
}

locals {
  instance_name = var.name != "" ? var.name : "${var.prefix}-pvc-base"
}

data "aws_ami" "pvc_base" {
  filter {
    name   = "image-id"
    values = [var.image_id]
  }
}

resource "aws_instance" "pvc_base" {
  count = var.quantity

  key_name      = var.ssh_key_pair
  instance_type = var.instance_type
  ami           = data.aws_ami.pvc_base.id

  subnet_id                   = var.subnet_ids[count.index % length(var.subnet_ids)]
  associate_public_ip_address = var.public_ip

  security_groups = var.security_groups

  root_block_device {
    delete_on_termination = var.root_volume.delete_on_termination
    volume_size           = var.root_volume.volume_size
    volume_type           = var.root_volume.volume_type
  }

  metadata_options {
    http_tokens = data.aws_ami.pvc_base.imds_support == "v2.0" ? "required" : "optional"
  }

  tags = merge(var.tags, { Name = format("%s-%02d", local.instance_name, count.index + var.offset + 1) })
}
