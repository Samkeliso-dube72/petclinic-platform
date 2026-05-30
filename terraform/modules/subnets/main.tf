locals {
  az_count = length(var.availability_zones)
}

resource "aws_subnet" "public" {
  count             = local.az_count
  vpc_id            = var.vpc_id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 3, count.index)

  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "petclinic-${var.environment}-public-${count.index + 1}"
      Type = "Public"
    }
  )
}

resource "aws_subnet" "private" {
  count             = local.az_count
  vpc_id            = var.vpc_id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 3, count.index + local.az_count)

  tags = merge(
    var.tags,
    {
      Name = "petclinic-${var.environment}-private-${count.index + 1}"
      Type = "Private"
    }
  )
}
