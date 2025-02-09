#myterraform-asg-sg.tf

resource "aws_security_group" "the_terraform_asg_sg" {
  name        = "my_terraform_asg_sg-lj"
  description = "Allow traffic for the Auto Scaling Group instances"

  # Ingress rules
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic from anywhere
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH traffic from anywhere
  }

  # Egress rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outgoing traffic for any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
}