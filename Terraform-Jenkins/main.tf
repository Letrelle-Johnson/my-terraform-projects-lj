resource "aws_instance" "jenkins_server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  security_groups             = [aws_security_group.my_jenkins_sg.name]
  associate_public_ip_address = true
  user_data                   = file("jenkins-script.sh")
  tags = {
    Name = "my_jenkins_server"
  }
}
