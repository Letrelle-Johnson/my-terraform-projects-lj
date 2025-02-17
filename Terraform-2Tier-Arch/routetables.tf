# Creates route tables for public and private subnets
resource "aws_route_table" "tfcloud_public_route_table" {
  vpc_id = aws_vpc.tfcloud_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tfcloud_internet_gateway.id
    #nat_gateway_id = aws_nat_gateway.tfcloud_internet_gateway_vpcsubnet.id
  }
  tags = {
    Name = "tfcloud_public_rt"
  }
}

resource "aws_route_table" "tfcloud_private_route_table" {
  vpc_id = aws_vpc.tfcloud_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tfcloud_nat_gateway.id
    #gateway_id     = aws_internet_gateway.tfcloud_internet_gateway.id
  }
  tags = {
    Name = "tfcloud_private_rt"
  }
}

#Creates route table associations
resource "aws_route_table_association" "tfcloud_public_rt_association" {
  depends_on     = [aws_subnet.tfcloud_public_subnets]
  route_table_id = aws_route_table.tfcloud_public_route_table.id
  for_each       = aws_subnet.tfcloud_public_subnets
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "tfcloud_private_rt_association" {
  depends_on     = [aws_subnet.tfcloud_private_subnets]
  route_table_id = aws_route_table.tfcloud_private_route_table.id
  for_each       = aws_subnet.tfcloud_private_subnets
  subnet_id      = each.value.id
}

#Creates Internet Gateway
resource "aws_internet_gateway" "tfcloud_internet_gateway" {
  vpc_id = aws_vpc.tfcloud_vpc.id
  tags = {
    Name = "two_tier_igw"
  }
}

# Creates EIP for NAT Gateway 
resource "aws_eip" "tfcloud_nat_gateway_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.tfcloud_internet_gateway]
  tags = {
    Name = "two_tier_igw_eip"
  }
}

