resource "aws_security_group" "sg_jenkins_docker" {
  name        = "sg_jenkins_docker"
  description = "Allow SSH, HTTP, and Jenkins port 8080 traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins Port 8080"
    from_port   = 8080
    to_port     = 8080
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

resource "aws_instance" "ec2_jenkins_docker" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.sg_jenkins_docker.id]
  subnet_id                   = element(var.subnet_ids, 0)
  associate_public_ip_address = true
  key_name                    = var.key_name
  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "EC2 instance for Jenkins & Docker"
  }
}

output "instance_id" {
  value = aws_instance.ec2_jenkins_docker.id
}
