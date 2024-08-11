resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "example-vpc"
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }
}

resource "aws_subnet" "example" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.example.id
  cidr_block        = element(var.subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
     Name = "example-subnet-${count.index}"
  }
}

resource "aws_route_table_association" "example" {
  count = length(var.availability_zones)

  subnet_id = aws_subnet.example[count.index].id
  route_table_id = aws_route_table.example.id
}

output "vpc_id" {
  value = aws_vpc.example.id
}

output "subnet_ids" {
  value = aws_subnet.example[*].id
}
