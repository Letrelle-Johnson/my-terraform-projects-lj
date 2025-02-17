variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_name" {
  type    = string
  default = "tfcloud_vpc"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

# Creates the AMI for Amazon Linux 2
variable "image_id" {
  type    = string
  default = "ami-04681163a08179f28"
}

# Creates a key in the console and use the name here
variable "key_name" {
  type    = string
  default = "tfcloud_kp"
}

# Creates VPC Cidr 
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

# Creates private subnets 
variable "tfcloud_private_subnets" {
  default = {
    "private_subnet_1" = 1
    "private_subnet_2" = 2
  }
}

# Creates public subnets 
variable "tfcloud_public_subnets" {
  default = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
  }
}