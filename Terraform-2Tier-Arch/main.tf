terraform {
  cloud {

    organization = "Terraform-Two-Tier-Architecture"

    workspaces {
      name = "my-two-tier-architecture-lj"
    }
  }
}


# Creates VPC 
resource "aws_vpc" "tfcloud_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tfcloud_vpc"
  }
}


# Fetches the available availability zones in the current region
data "aws_availability_zones" "available" {
  state = "available"
}

# Creates Public Subnets for Web Server Tier
resource "aws_subnet" "tfcloud_public_subnets" {
  for_each                = var.tfcloud_public_subnets
  vpc_id                  = aws_vpc.tfcloud_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value + 100)
  availability_zone       = tolist(data.aws_availability_zones.available.names)[each.value]
  map_public_ip_on_launch = true

  tags = {
    Name = each.key
  }
}


# Creates NAT Gateway
resource "aws_nat_gateway" "tfcloud_nat_gateway" {
  depends_on = [aws_subnet.tfcloud_public_subnets]

  subnet_id     = aws_subnet.tfcloud_public_subnets["public_subnet_1"].id # Example: Accessing a specific subnet
  allocation_id = aws_eip.tfcloud_nat_gateway_eip.id                      # Assuming you have an Elastic IP allocated for the NAT Gateway

  tags = {
    Name = "tfcloud_nat_gateway"
  }
}

# Launches the EC2 instance and installs apache
resource "aws_instance" "tfcloud_ec2_instance" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  for_each               = aws_subnet.tfcloud_public_subnets
  subnet_id              = each.value.id
  vpc_security_group_ids = [aws_security_group.tfcloud_ec2_sg.id]
  key_name               = var.key_name
  user_data              = file("install_apache.sh")

  tags = {
    Name = "tfcloud_web_server"
  }
}


# Creates an RDS Database Instance
resource "aws_db_instance" "myinstance" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  identifier             = "myrdsinstance"
  instance_class         = "db.t3.micro"
  username               = "myrdsuser"
  password               = "myrdspassword"
  parameter_group_name   = "default.mysql8.0"
  vpc_security_group_ids = [aws_security_group.tfcloud_rds_sg.id, aws_security_group.tfcloud_ec2_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.tfcloud_db_subnet_group.name
  skip_final_snapshot    = true
  publicly_accessible    = false
}

resource "aws_db_subnet_group" "tfcloud_db_subnet_group" {
  name       = "tfcloud_db_subnet_group"
  subnet_ids = [for subnet in aws_subnet.tfcloud_private_subnets : subnet.id]

  tags = {
    Name = "tfcloud-db-subnet-group"
  }
}


# Creates Private Subnets for RDS Tier
resource "aws_subnet" "tfcloud_private_subnets" {
  for_each                = var.tfcloud_private_subnets
  vpc_id                  = aws_vpc.tfcloud_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone       = tolist(data.aws_availability_zones.available.names)[each.value]
  map_public_ip_on_launch = true

  tags = {
    Name = each.key
  }
}


