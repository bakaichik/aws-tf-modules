locals {
  eks_ssh_name = "${var.eks_name}_${var.env}_ssh_key"
}


resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = local.eks_ssh_name
  public_key = tls_private_key.this.public_key_openssh
  tags = {
    "env" = var.env
  }
}

resource "aws_security_group" "additional_node_sg" {
  name        = "${var.eks_name}_${var.env}_additional_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.additional_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.additional_egress_rules
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

resource "aws_eks_node_group" "this" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.this.name
  ami_type        = each.value.node_ami_type
  node_group_name = each.key
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = each.value.subnet_ids

  capacity_type  = each.value.capacity_type
  instance_types = each.value.instance_types

  disk_size = each.value.disk_size

  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }

  update_config {
    max_unavailable = 1
  }

  labels = each.value.labels

  remote_access {
    ec2_ssh_key               = local.eks_ssh_name
    source_security_group_ids = [aws_security_group.additional_node_sg.id]
  }

  taint {
    key    = each.value.taint.key
    value  = each.value.taint.value
    effect = each.value.taint.effect
  }


  depends_on = [aws_iam_role_policy_attachment.nodes]
}
