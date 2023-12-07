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
  security_group_name = var.security_group_name != "" ? var.security_group_name : "${var.prefix}-pvc-base-bastion"
  bastion_instance_name = var.bastion_instance_name != "" ? var.bastion_instance_name : "${var.prefix}-pvc-base-bastion"
}

data "aws_key_pair" "bastion" {
  key_name = var.ssh_key_pair
}

data "aws_ami" "bastion" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "bastion" {
  name        = local.security_group_name
  description = "Allow SSH traffic"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "bastion" {
  security_group_id = aws_security_group.bastion.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
  description = "All traffic"
}

resource "aws_vpc_security_group_ingress_rule" "bastion" {
  security_group_id = aws_security_group.bastion.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
  description = "All SSH traffic"
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.bastion.id
  instance_type = "t2.micro"
  key_name      = data.aws_key_pair.bastion.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [ aws_security_group.bastion.id ]
  associate_public_ip_address = true
  tags = { Name = local.bastion_instance_name }
}
