locals {
    vpc_cidr = "10.0.0.0/16"
    cidr_subnets = cidrsubnets(local.vpc_cidr, 4, 4, 4, 4, 4, 4)
}

module "vpc" {
  source = "./modules/vpc"
 
  infra_prj = var.infra_prj
  infra_env = var.infra_env

  vpc_cidr = local.vpc_cidr
}

# module "ecr" {
#   source = "./modules/ecr"
 
#   infra_prj = var.infra_prj
#   infra_env = var.infra_env
# }

# module "eks" {
#   source = "./modules/eks"
 
#   infra_prj = var.infra_prj
#   infra_env = var.infra_env
#   vpc_id = module.vpc.vpc_id
#   subnet_ids = module.vpc.vpc_private_subnets
# }