#---------------------------------aws_security_group-----------------------------
resource "aws_security_group" "defenders_security_group" {
  name_prefix = "Security-Group for Defenders"

  vpc_id = "${var.module_vpc_id.id}"

  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.CIDR
    }
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.CIDR
  }

  tags = {
    Name = "Defenders_Security_group"
  }
}


resource "aws_security_group" "alb_sg" {
  name = "alb_sg"

  vpc_id = "${var.module_vpc_id.id}"

  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.CIDR
    }
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.CIDR
  }

  tags = {
    Name = "alb-sg"
  }
}
