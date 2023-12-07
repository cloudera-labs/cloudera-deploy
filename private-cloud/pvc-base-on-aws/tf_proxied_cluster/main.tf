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

# TODO Could use prefix groups to add GlobalVPN restrictions on a non-proxied cluster

terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = ">= 4.60.0",
    }
    ansible = {
      source  = "ansible/ansible"
      version = ">= 1.0.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.asset_tags
  }
}

locals {
  vpc_name = var.vpc_name != "" ? var.vpc_name : "${var.prefix}-pvc-base"
  igw_name = var.igw_name != "" ? var.igw_name : "${var.prefix}-pvc-base-igw"
}

# ------- SSH -------

data "local_file" "ssh_public_key_file" {
  filename = var.ssh_public_key_file
}

resource "aws_key_pair" "pvc_base" {
  key_name   = "${var.prefix}-pvc-base"
  public_key = data.local_file.ssh_public_key_file.content
}

# ------- VPC -------

resource "aws_vpc" "pvc_base" {
  cidr_block           = var.vpc_cidr
  tags                 = { Name = local.vpc_name }
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "pvc_base" {
  vpc_id = aws_vpc.pvc_base.id
  tags   = { Name = local.igw_name }
}

# ------- Network  -------

module "cluster_network" {
  source = "../tf_network"

  region = var.region
  prefix = var.prefix
  vpc_id = aws_vpc.pvc_base.id
}

resource "aws_vpc_security_group_egress_rule" "pvc_base" {
  security_group_id = module.cluster_network.intra_cluster_security_group.id
  description       = "All traffic"
  ip_protocol       = -1
  cidr_ipv4         = "0.0.0.0/0"
  tags              = { Name = "${var.prefix}-pvc-base-intra" }
}

# ------- Bastion  -------

module "bastion" {
  source     = "../tf_bastion"
  depends_on = [aws_key_pair.pvc_base, module.cluster_network]

  region       = var.region
  prefix       = var.prefix
  vpc_id       = aws_vpc.pvc_base.id
  subnet_id    = module.cluster_network.public_subnets[0].id
  ssh_key_pair = aws_key_pair.pvc_base.key_name
}

resource "aws_vpc_security_group_ingress_rule" "bastion" {
  security_group_id            = module.cluster_network.intra_cluster_security_group.id
  description                  = "All Bastion traffic"
  ip_protocol                  = -1
  referenced_security_group_id = module.bastion.security_group.id
  tags                         = { Name = "${var.prefix}-pvc-base-bastion" }
}

resource "aws_vpc_security_group_egress_rule" "bastion" {
  security_group_id            = module.cluster_network.intra_cluster_security_group.id
  description                  = "All Bastion traffic"
  ip_protocol                  = -1
  referenced_security_group_id = module.bastion.security_group.id
  tags                         = { Name = "${var.prefix}-pvc-base-bastion" }
}

resource "aws_vpc_security_group_ingress_rule" "cluster" {
  security_group_id            = module.bastion.security_group.id
  description                  = "All PVC Base traffic"
  ip_protocol                  = -1
  referenced_security_group_id = module.cluster_network.intra_cluster_security_group.id
  tags                         = { Name = "${var.prefix}-pvc-base-cluster" }
}

# TODO Review if redundant with existing egress
resource "aws_vpc_security_group_egress_rule" "cluster" {
  security_group_id            = module.bastion.security_group.id
  description                  = "All PVC Base traffic"
  ip_protocol                  = -1
  referenced_security_group_id = module.cluster_network.intra_cluster_security_group.id
}

# ------- Cluster  -------

data "aws_ami" "pvc_base" {
  owners      = ["099720109477"] # Canonical
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "masters" {
  source     = "../tf_hosts"
  depends_on = [aws_key_pair.pvc_base, data.aws_ami.pvc_base]

  prefix          = "${var.prefix}-proxied-cluster-master"
  image_id        = data.aws_ami.pvc_base.image_id
  ssh_key_pair    = aws_key_pair.pvc_base.key_name
  subnet_ids      = module.cluster_network.private_subnets[*].id
  security_groups = [module.cluster_network.intra_cluster_security_group.id]
  public_ip       = false
}

module "workers" {
  source     = "../tf_hosts"
  depends_on = [aws_key_pair.pvc_base, data.aws_ami.pvc_base]

  prefix          = "${var.prefix}-proxied-cluster-worker"
  quantity        = 4
  image_id        = data.aws_ami.pvc_base.image_id
  ssh_key_pair    = aws_key_pair.pvc_base.key_name
  subnet_ids      = module.cluster_network.private_subnets[*].id
  security_groups = [module.cluster_network.intra_cluster_security_group.id]
  public_ip       = false
}

module "moar_workers" {
  source     = "../tf_hosts"
  depends_on = [aws_key_pair.pvc_base, data.aws_ami.pvc_base]

  prefix          = "${var.prefix}-proxied-cluster-worker"
  quantity        = 4
  offset          = 4
  image_id        = data.aws_ami.pvc_base.image_id
  ssh_key_pair    = aws_key_pair.pvc_base.key_name
  subnet_ids      = module.cluster_network.private_subnets[*].id
  security_groups = [module.cluster_network.intra_cluster_security_group.id]
  public_ip       = false
}
