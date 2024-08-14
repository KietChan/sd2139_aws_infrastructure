resource "aws_vpc" "k_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "k-vpc"
  }
}

resource "aws_internet_gateway" "k_internet_gateway" {
  vpc_id = aws_vpc.k_vpc.id
}

resource "aws_route_table" "k_route_table" {
  vpc_id = aws_vpc.k_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k_internet_gateway.id
  }
}

resource "aws_subnet" "k_subnet" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.k_vpc.id
  cidr_block        = element(var.subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
     Name = "k-subnet-${count.index}"
  }
}

resource "aws_route_table_association" "k_route_table_association" {
  count = length(var.availability_zones)

  subnet_id = aws_subnet.k_subnet[count.index].id
  route_table_id = aws_route_table.k_route_table.id
}

output "vpc_id" {
  value = aws_vpc.k_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.k_subnet[*].id
}
