variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}
 
variable "infra_prj" {
  type        = string
  description = "infrastructure project"
}
 
variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
  default     = "10.0.0.0/16"
}