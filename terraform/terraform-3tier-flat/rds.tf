# RDS Subnet Group
resource "aws_db_subnet_group" "db_subnet" {
  name       = "${local.name}-db-subnetgrp"
  subnet_ids = [for s in aws_subnet.db : s.id]
  tags = { Name = "${local.name}-db-subnetgrp" }
}

# RDS Security group already created aws_security_group.db_sg

resource "aws_db_instance" "mysql" {
  identifier              = "${local.name}-mysql"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "appdb"
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  apply_immediately       = true
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.db_subnet.name
  publicly_accessible     = false
  deletion_protection     = false
  auto_minor_version_upgrade = true

  tags = { Name = "${local.name}-mysql" }
}
