data "aws_availability_zones" "available-azs" {
  state = "available"
}

locals {
  azs = tolist(data.aws_availability_zones.available-azs.names)
}

# resource "aws_subnet" "private-subnets-resource" {
#   for_each                = toset(local.azs)
#   vpc_id                  = module.vpc.vpc_id
#   cidr_block              = cidrsubnet(var.vpc_cidr, 8, index(local.azs, each.value))
#   availability_zone       = each.value
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "${var.infra_prj}-${var.infra_env}-private-${each.key}"
#     "kubernetes.io/role/internal-elb" = 1
#     Tier = "private"
#   }
# }

# resource "aws_subnet" "public-subnets-resource" {
#   for_each                = toset(local.azs)
#   vpc_id                  = module.vpc.vpc_id
#   cidr_block              = cidrsubnet(var.vpc_cidr, 8, index(local.azs, each.value) + 4)
#   availability_zone       = each.value
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "${var.infra_prj}-${var.infra_env}-public-${each.key}"
#     "kubernetes.io/role/elb" = 1
#     Tier = "private"
#   }
# }

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"
 
  # insert the 49 required variables here
  name = "${var.infra_prj}-${var.infra_env}-vpc"
  cidr = var.vpc_cidr
 
  azs = local.azs
 
  # Single NAT Gateway, see docs linked above
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnets      = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  private_subnets     = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]

  tags = {
    Name = "${var.infra_prj}-${var.infra_env}-vpc"
    Project = var.infra_prj
    Environment = var.infra_env
    ManagedBy = "terraform"
  }
 
  private_subnet_tags = {
    Tier = "private"
    Name = "${var.infra_prj}-${var.infra_env}-private"
    "kubernetes.io/role/internal-elb" = 1
  }

  public_subnet_tags = {
    Tier = "public"
    Name = "${var.infra_prj}-${var.infra_env}-public"
    "kubernetes.io/role/elb" = 1
  }
}