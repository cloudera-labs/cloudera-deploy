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

# TODO Move VPC creation to tf_proxied_cluster root module

data "aws_availability_zones" "pvc_base" {
  state = "available"
}

locals {
  vpc_name = var.vpc_name != "" ? var.vpc_name : "${var.prefix}-pvc-base"
  igw_name = var.igw_name != "" ? var.igw_name : "${var.prefix}-pvc-base-igw"
  nat_name = var.nat_gateway_name != "" ? var.nat_gateway_name : "${var.prefix}-pvc-base-nat"
  rt_public_name = var.public_route_table_name != "" ? var.public_route_table_name : "${var.prefix}-pvc-base-public"
  rt_private_name = var.private_route_table_name != "" ? var.private_route_table_name : "${var.prefix}-pvc-base-private"
  public_subnet_name = var.public_subnet_name != "" ? var.public_subnet_name : "${var.prefix}-pvc-base-public"
  public_subnets = length(var.public_subnets) > 0 ? var.public_subnets : tolist([{
    name = "${local.public_subnet_name}-01",
    cidr = cidrsubnet(var.vpc_cidr, 8, 0),
    az = data.aws_availability_zones.pvc_base.names[0],
    tags = {}
  }])
  private_subnet_name = var.private_subnet_name != "" ? var.private_subnet_name : "${var.prefix}-pvc-base-private"
  private_subnets = length(var.private_subnets) > 0 ? var.private_subnets : tolist([{
    name = "${local.private_subnet_name}-01",
    cidr = cidrsubnet(var.vpc_cidr, 8, 1),
    az = data.aws_availability_zones.pvc_base.names[0],
    tags = {}
  }])
  sg_intra_name = var.security_group_intra_name != "" ? var.security_group_intra_name : "${var.prefix}-pvc-base-intra"
}

# ------- AWS VPC -------

# Virtual Cluster
resource "aws_vpc" "pvc_base" {
  cidr_block           = var.vpc_cidr
  tags                 = { Name = local.vpc_name }
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Internet Gateway
resource "aws_internet_gateway" "pvc_base" {
  vpc_id = aws_vpc.pvc_base.id
  tags   = { Name = local.igw_name }
}

# ------- AWS Public Network infrastructure -------

# TODO Calculate a local for a single default public subnet or defer to the root tf_proxied_cluter module
# TODO Lookup AZ id by input (name) and if not found, use AZ value as ID

# Public Subnets 
resource "aws_subnet" "pvc_base_public" {
  for_each = { for idx, subnet in local.public_subnets : idx => subnet }

  vpc_id                  = aws_vpc.pvc_base.id
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = true
  availability_zone       = each.value.az
  tags                    = merge(each.value.tags, { Name = each.value.name })
}

resource "aws_route_table" "pvc_base_public" {
  for_each = { for idx, subnet in local.public_subnets : idx => subnet }

  vpc_id = aws_vpc.pvc_base.id

  tags = { Name = format("%s-%02d", local.rt_public_name, index(local.public_subnets, each.value) + 1) }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pvc_base.id
  }
}

# Public Route Table Associations
resource "aws_route_table_association" "pvc_base_public" {
  for_each = { for idx, subnet in aws_subnet.pvc_base_public : idx => subnet }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.pvc_base_public[each.key].id
}

# ------- AWS Private Networking infrastructure -------

# Network Gateways (NAT)
resource "aws_eip" "pvc_base" {
  count = length(aws_subnet.pvc_base_public)

  tags = { Name = format("%s-%02d", local.nat_name, count.index + 1) }
}

resource "aws_nat_gateway" "pvc_base" {
  for_each          = { for idx, subnet in aws_subnet.pvc_base_public : idx => subnet }

  subnet_id         = each.value.id
  allocation_id     = aws_eip.pvc_base[each.key].id
  connectivity_type = "public"
  tags = { Name = format("%s-%02d", local.nat_name, each.key + 1) }
}

# Private Subnets
resource "aws_subnet" "pvc_base_private" {
  for_each = { for idx, subnet in local.private_subnets : idx => subnet }

  vpc_id                  = aws_vpc.pvc_base.id
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = false
  availability_zone       = each.value.az
  tags                    = merge(each.value.tags, { Name = each.value.name })
}

# Private Route Tables
resource "aws_route_table" "pvc_base_private" {
  for_each = { for idx, subnet in local.private_subnets : idx => subnet }

  vpc_id = aws_vpc.pvc_base.id

  tags = { Name = format("%s-%02d", local.rt_private_name, index(local.private_subnets, each.value)) }

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.pvc_base[(index(local.private_subnets, each.value) % length(aws_nat_gateway.pvc_base))].id
  }
}

# Private Route Table Associations
resource "aws_route_table_association" "pvc_base_private" {
  for_each = { for idx, subnet in aws_subnet.pvc_base_private : idx => subnet }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.pvc_base_private[each.key].id
}

# ------- Security Groups -------

# Intra-cluster traffic
resource "aws_security_group" "pvc_base" {
  vpc_id      = aws_vpc.pvc_base.id
  name        = local.sg_intra_name
  description = "Intra-cluster communication for PVC cluster '${var.prefix}'"

  tags = { Name = local.sg_intra_name }

  # Create self reference ingress rule to allow 
  # communication among resources in the security group.
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "all"
    self      = true
  }

  # TODO Ingress should be defined by tf_proxied_cluster or other root module
  # # Dynamic Block to create security group rule from var.sg_ingress
  # dynamic "ingress" {
  #   for_each = var.security_group_rules_ingress

  #   content {
  #     cidr_blocks = ingress.value.cidr
  #     from_port   = ingress.value.from_port
  #     to_port     = ingress.value.to_port
  #     protocol    = ingress.value.protocol
  #   }

  # }

  # Terraform removes the default ALLOW ALL egress. Let's recreate this
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "all"
  }
}
