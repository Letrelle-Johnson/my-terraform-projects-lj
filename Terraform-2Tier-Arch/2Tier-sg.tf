# Creates security group for the EC2 instance
resource "aws_security_group" "tfcloud_ec2_sg" {
  name        = "tfcloud_ec2_sg"
  description = "Allows access on ports 80 & 22"
  vpc_id      = aws_vpc.tfcloud_vpc.id

  # Allows access on port 80
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allows access on port 22
  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allows access for EC2 instance & RDS instance to communicate 
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform EC2 security group"
  }
}


# Creates security group for RDS
resource "aws_security_group" "tfcloud_rds_sg" {
  name        = "tfcloud_rds_sg"
  description = "Allows access on ports 80, 22, & 3306"
  vpc_id      = aws_vpc.tfcloud_vpc.id

  # Allows access on port 80
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow access on port 22
  ingress {
    description     = "ssh access"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.tfcloud_ec2_sg.id]
  }

  # Allows EC2 access to RDS database
  ingress {
    description     = "mysql/rds"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.tfcloud_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform RDS security group"
  }
}
