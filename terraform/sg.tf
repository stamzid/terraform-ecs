resource "aws_security_group" "lb_sg" {
  name        = "unstructured-lb-sg"
  description = "allow inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "pulic internet access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    name = "allow_traffic"
  }
}

resource "aws_security_group" "service_sg" {
  name        = "allow"
  description = "allow inbound traffic from vpc"
  vpc_id      = var.vpc_id

  ingress {
    description      = "vpc internet access"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_blocks
    security_groups  = [aws_security_group.lb_sg.id]
  }

  ingress {
    description      = "vpc ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_blocks
    security_groups  = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    name = "allow_traffic"
  }

  depends_on = [aws_security_group.lb_sg]
}

output "lb_sg_id" {
  value = aws_security_group.lb_sg.id
}

output "service_sg_id" {
  value = aws_security_group.service_sg.id
}
