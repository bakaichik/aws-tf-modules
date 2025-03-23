resource "random_password" "this" {
  length  = 32
  special = false
}

resource "random_string" "this" {
  length  = 16
  lower   = true
  special = false
}

resource "aws_rds_cluster" "this" {
  cluster_identifier     = "${var.env}-${var.name}-rds"
  engine                 = var.engine
  engine_mode            = var.engine_mode
  engine_version         = var.engine_version
  database_name          = var.database_name
  master_username        = var.master_username
  master_password        = random_password.this.result
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  enabled_cloudwatch_logs_exports = var.cloudwatch_logs_exports

  serverlessv2_scaling_configuration {
    max_capacity = var.serverles2_config.max_capacity
    min_capacity = var.serverles2_config.min_capacity
  }

  tags = {
    "env" = var.env
  }
}

resource "aws_rds_cluster_instance" "this" {
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.env}-${var.name}-rds"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "this" {
  name   = "${var.env}-${var.name}-rds"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks

    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    "env" = var.env
  }
}
