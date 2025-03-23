variable "env" {
  type = string
}

variable "name" {
  type = string
}

variable "engine" {
  type    = string
  default = "aurora-postgresql"
}

variable "engine_mode" {
  type    = string
  default = "provisioned"
}

variable "engine_version" {
  type    = string
  default = "15.5"
}

variable "database_name" {
  type    = string
  default = "postgres"
}

variable "master_username" {
  type    = string
  default = "admin"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "cloudwatch_logs_exports" {
  type    = list(string)
  default = ["postgresql"]
}

variable "serverles2_config" {
  type = object({
    max_capacity = number
    min_capacity = number
  })
  default = {
    max_capacity = 2.0
    min_capacity = 0.5
  }
}


variable "ingress_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    "default" = {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 22
      protocol    = "tcp"
      to_port     = 22
    }
  }
}


variable "egress_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    "default" = {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 0
      protocol    = "-1"
      to_port     = 0
    }
  }
}
