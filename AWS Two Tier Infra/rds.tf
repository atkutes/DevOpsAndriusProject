
# Database subnet group
resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"
  subnet_ids = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1b.id]
}
# Security group for database tier
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "allow traffic only from web_sg"
  vpc_id      = aws_vpc.azcloud.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.publicsg.id]
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.publicsg.id]
    cidr_blocks     = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Database instance in private subnet 1
resource "aws_db_instance" "db1" {
  allocated_storage           = 10
  engine                      = "mysql"
  engine_version              = "5.7"
  instance_class              = "db.t3.micro"
  db_subnet_group_name        = "db_subnet"
  vpc_security_group_ids      = [aws_security_group.db_sg.id]
  parameter_group_name        = "default.mysql5.7"
  db_name                     = "andriuscloud"
  username                    = "admin"
  password                    = "password"
  multi_az                    = false
  skip_final_snapshot         = true
}