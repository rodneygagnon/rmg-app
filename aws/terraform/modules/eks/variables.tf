variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "infra_prj" {
  type        = string
  description = "infrastructure project"
}

variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "subnet_ids" {
  type = list(string)
  description = "subnet ids to create cluster"
}

