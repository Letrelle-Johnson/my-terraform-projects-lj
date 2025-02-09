#main.tf

resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "Default VPC"
  }
}

# Creating subnets for the default VPC
resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1a"

  tags = {
    Name = "Default subnet for us-east-1a"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-east-1b"

  tags = {
    Name = "Default subnet for us-east-1b"
  }
}

# Creating an Autoscaling Group
resource "aws_autoscaling_group" "terraform_asg" {
  name               = "myterraform-asg23-lj"
  min_size           = var.min_size
  max_size           = var.max_size
  desired_capacity   = var.desired_capacity
  availability_zones = var.availability_zones

  launch_template {
    id      = aws_launch_template.launch-asg23-lj.id
    version = "$Latest"
  }

  # Tagging the ASG
  tag {
    key                 = "Name"
    value               = "terraform-asg-instance"
    propagate_at_launch = true
  }
}

# Creating a launch template for the ASG
resource "aws_launch_template" "launch-asg23-lj" {
  name          = "mylaunch-asg23-lj"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = base64encode(file("apache_installment.sh"))

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.the_terraform_asg_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "MyLaunchASGInstance"
    }
  }
}