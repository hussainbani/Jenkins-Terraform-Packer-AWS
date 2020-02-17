resource "aws_db_subnet_group" "postgres-subnet" {
  name       = "postgres-subnet"
  subnet_ids = ["${aws_subnet.Private-1.id}", "${aws_subnet.Private-2.id}", "${aws_subnet.Private-3.id}"]
  tags = {
    Name = "My DB subnet group"
  }
}
resource "aws_db_parameter_group" "postgres-parameters" {
  name   = "postgres-parameters"
  family = "postgres11"

  parameter {
    name  = "max_connections"
    value = 200
    apply_method = "pending-reboot"
  }
}

resource "aws_db_instance" "node-postgres" {
  allocated_storage    = "${var.STORAGE_DB}"
  identifier = "node-postgres-db"
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "11.1"
  instance_class       = "db.${var.DB_INSTANCE_TYPE}"
  name                 = "toptaldb"
  username             = "${var.DB_USER}"
  password             = "${var.DB_PASS}"
  final_snapshot_identifier = "toptaldb-finalsnaphot"
  skip_final_snapshot = "false"
  backup_retention_period = 15
  backup_window = "${var.BACKUP_WINDOW}"
  enabled_cloudwatch_logs_exports = ["postgresql"]
  db_subnet_group_name = "${aws_db_subnet_group.postgres-subnet.id}"
  parameter_group_name = "${aws_db_parameter_group.postgres-parameters.name}"
  multi_az = "true"
  vpc_security_group_ids = ["${aws_security_group.RDS-sg.id}"]
  tags = {
    task="toptal"
  }
}  
