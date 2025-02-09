variable "aws_region" {
  type    = string
  default = "us-east-1" # You can set a default region or leave it without default to require it at runtime
}

variable "instance_type" {
  default = "t2.micro" # Specifies the EC2 instance type. Adjust this based on your requirements.
  type    = string
}

variable "ami" {
  default = "ami-0c614dee691cbbf37" # The AMI ID for the EC2 instance. Ensure it corresponds to the desired Amazon Linux 2 AMI version.
  type    = string
}

variable "key_name" {
  default = "myjenkinskp" # The name of the SSH key pair used to access the EC2 instance. Ensure this key exists in your AWS account.
  type    = string
}

variable "aws_s3_bucket" {
  default = "the-jenkins-bucket2026-lj" # The name of the S3 bucket to store Jenkins artifacts. Make sure the name is unique globally.
  type    = string
}

variable "security_group_name" {
  default = "my_jenkins_sg"
  type    = string
}