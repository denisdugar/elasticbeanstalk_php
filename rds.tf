resource "aws_db_instance" "elastic_db" {
  allocated_storage       = 10
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t3.micro"
  vpc_security_group_ids  = [aws_security_group.sg_rds.id]
  name                    = "test"
  username                = local.db_creds.username
  password                = local.db_creds.password
  parameter_group_name    = "default.mysql5.7"
  db_subnet_group_name    = aws_db_subnet_group.sb_group.name
  storage_encrypted       = true
  skip_final_snapshot     = true
}

resource "aws_security_group" "sg_rds" {
  vpc_id        = aws_vpc.test_vpc.id
}

resource "aws_security_group_rule" "rds_sg_in" {
  security_group_id        = aws_security_group.sg_rds.id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_db_subnet_group" "sb_group" {
  name       = "rds_sb_group"
  subnet_ids = [aws_subnet.test_subnet_private_1.id, aws_subnet.test_subnet_private_2.id]
}