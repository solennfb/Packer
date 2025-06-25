provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "nginx" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  tags = {
    Name = "NginxPackerInstance"
  }
}
