resource "aws_db_subnet_group" "this" {
  name       = "himanshu-${var.environment}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name        = "himanshu-${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}
resource "aws_db_instance" "this" {
  identifier = "himanshu-${var.environment}-mysql-db"

  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"

  allocated_storage    = 20
  storage_type         = "gp2"
  storage_encrypted    = false

  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password

  vpc_security_group_ids = [var.db_security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  publicly_accessible          = false
  multi_az                     = false
  auto_minor_version_upgrade   = false
  deletion_protection          = false
  skip_final_snapshot          = true

  tags = {
    Name        = "himanshu-${var.environment}-mysql-db"
    Environment = var.environment
    Purpose     = "application-database"
  }
}