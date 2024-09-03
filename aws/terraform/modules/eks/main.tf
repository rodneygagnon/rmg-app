module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.infra_prj}-${var.infra_env}-eks-cluster"
  cluster_version = "1.30"

  cluster_endpoint_public_access  = true
  enable_cluster_creator_admin_permissions = true

  # cluster_addons = {
  #   aws-ebs-csi-driver = {
  #     service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  #     most_recent = true
  #   }
  # }

  vpc_id     = "${var.vpc_id}"
  subnet_ids = var.subnet_ids

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    "${var.infra_prj}-${var.infra_env}-eks-wg" = {
      instance_types = [ "t3.medium" ]

      min_size = 1
      max_size = 2
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size = 1
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
# data "aws_iam_policy" "ebs_csi_policy" {
#   arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
# }

# module "irsa-ebs-csi" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
#   version = "5.39.0"

#   create_role                   = true
#   role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
#   provider_url                  = module.eks.oidc_provider
#   role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
#   oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
# }