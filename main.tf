data "aws_region" "current" {}
data "aws_availability_zones" "available" {
  filter {
    name   = "region-name"
    values = [data.aws_region.current.name]
  }
}

locals {
  azs = var.multi_az ? slice(data.aws_availability_zones.available.names, 0, 3) : [data.aws_availability_zones.available.names[0]]
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = var.vpc_name
  }
}

# Create subnets
resource "aws_subnet" "private" {
  count             = var.multi_az ? 3 : 1
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = element(local.azs, count.index)

  tags = {
    Name = var.multi_az ? "${var.vpc_name}-private-${count.index}" : "${var.vpc_name}-private"
  }
}

resource "aws_subnet" "public" {
  count             = var.multi_az ? 3 : 1
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 3, count.index + 3)
  availability_zone = element(local.azs, count.index)

  tags = {
    Name = var.multi_az ? "${var.vpc_name}-public-${count.index}" : "${var.vpc_name}-public"
  }
}

locals {
  public_subnet_ids  = { for idx, s in aws_subnet.public : idx => s.id }
  private_subnet_ids = { for idx, s in aws_subnet.private : idx => s.id if idx < (var.multi_nat ? 3 : 1) }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Associate the Internet Gateway with the VPC
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.vpc_name}-public"
  }
}

resource "aws_route_table_association" "public_subnet" {
  for_each = local.public_subnet_ids

  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

# Create NAT Gateways
resource "aws_eip" "this" {
  count = var.multi_nat ? 3 : 1

  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-eip-${count.index}"
  }
}

resource "aws_nat_gateway" "this" {
  count         = var.multi_nat ? 3 : 1
  allocation_id = aws_eip.this[count.index].id
  subnet_id     = element(aws_subnet.public[*].id, count.index)

  tags = {
    Name = var.multi_nat ? "${var.vpc_name}-nat-${count.index}" : "${var.vpc_name}-nat"
  }
}

# Associate the NAT Gateways with the private subnets
resource "aws_route_table" "private" {
  count = var.multi_nat ? 3 : 1

  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.multi_nat ? "${var.vpc_name}-private-${count.index}" : "${var.vpc_name}-private"
  }
}

resource "aws_route" "private_nat_gateway" {
  count = var.multi_nat ? 3 : 1

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "private_subnet" {
  for_each = local.private_subnet_ids

  subnet_id      = each.value
  route_table_id = aws_route_table.private[each.key].id
}

