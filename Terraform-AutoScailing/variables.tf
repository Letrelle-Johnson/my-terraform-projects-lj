variable "aws_region" {
  type    = string
  default = "us-east-1" # You can set a default region or leave it without default to require it at runtime
}

variable "instance_type" {
  default = "t2.micro" # Specifies the EC2 instance type. Adjust this based on your requirements.
  type    = string
}

variable "ami" {
  default = "ami-04681163a08179f28" # The AMI ID for the EC2 instance. Ensure it corresponds to the desired Amazon Linux 2 AMI version.
  type    = string
}

variable "key_name" {
  default = "myjenkinskp" # The name of the SSH key pair used to access the EC2 instance. Ensure this key exists in your AWS account.
  type    = string
}

variable "default_vpc" {
  default = "vpc-0f1db6f27b08f0096" #The defaul VPC used for deploying the resources 
  type    = string
}

variable "desired_capacity" {
  default = 2 #Desired number of instances for Auto-Scaling Group 
  type    = number
}

variable "min_size" {
  default = 2 #Minimum number of instances for Auto-Scaling Group 
  type    = number
}

variable "max_size" {
  default = 5 #Maximum number of instances for Auto-Scaling Group 
  type    = number
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b"] #Specifies the availability zones for the resources to be deployed to in the region of your choosing 
  type    = list(string)
}