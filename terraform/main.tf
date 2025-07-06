resource "aws_instance" "laravel_server" {
  ami           = "ami-042b4708b1d05f512"
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "laravel-deploy-to-ec2"
  }

  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}