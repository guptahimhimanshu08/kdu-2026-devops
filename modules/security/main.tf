resource "aws_security_group" "alb_sg" {
  name        = "himanshu-${var.environment}-alb-sg"
  description = "ALB security group (HTTP only)"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "himanshu-${var.environment}-alb-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "himanshu-${var.environment}-bastion-sg"
  description = "Bastion host security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH from trusted IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "himanshu-${var.environment}-bastion-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "app_sg" {
  name        = "himanshu-${var.environment}-app-sg"
  description = "Application tier security group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description     = "Allow SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "himanshu-${var.environment}-app-sg"
    Environment = var.environment
  }
}

# Databse Security groups
resource "aws_security_group" "db_sg" {
  name        = "himanshu-${var.environment}-db-sg"
  description = "Database tier security group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow MySQL from application tier"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "himanshu-${var.environment}-db-sg"
    Environment = var.environment
  }
}