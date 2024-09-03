variable default_region {
    type = string
    description = "the region this infrastructure is in"
    # default = "us-west-1"
}

variable "infra_prj" {
  type        = string
  description = "infrastructure project name"
  # default     = "rmg"
}

variable "infra_env" {
  type        = string
  description = "infrastructure environment"
  # default     = "dev"
}