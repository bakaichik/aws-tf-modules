variable "env" {
  description = "Environment name."
  type        = string
}

variable "vpc_id" {
  type = string
}


variable "eks_version" {
  description = "Desired Kubernetes master version."
  type        = string
}

variable "eks_name" {
  description = "Name of the cluster."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs. Must be in at least two different availability zones."
  type        = list(string)
}

variable "node_iam_policies" {
  description = "List of IAM Policies to attach to EKS-managed nodes."
  type        = map(any)
  default = {
    1 = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    2 = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    3 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    4 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

variable "node_groups" {
  description = "EKS node groups"
  type        = map(any)
}

variable "enable_irsa" {
  description = "Determines whether to create an OpenID Connect Provider for EKS to enable IRSA"
  type        = bool
  default     = true
}


variable "endpoint_private_access" {
  type    = bool
  default = false
}

variable "endpoint_public_access" {
  type    = bool
  default = true
}


variable "eks_ingress_rules" {
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
      protocol    = "tcp"
      to_port     = 65535
    }
  }
}


variable "eks_egress_rules" {
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
      protocol    = "tcp"
      to_port     = 65535
    }
  }

  description = "By default allow everything"
}

variable "enableExtraEksIamPolicy" {
  type    = bool
  default = false
}

variable "extraEksIamPolicies" {
  type    = list(string)
  default = []
}

variable "public_access_cidrs" {
  description = "Restrict Public Access to API Server"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "additional_ingress_rules" {
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
      protocol    = "tcp"
      to_port     = 65535
    }
  }
}


variable "additional_egress_rules" {
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

  description = "By default allow everything"
}
