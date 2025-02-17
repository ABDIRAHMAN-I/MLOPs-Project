module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.4"

  cluster_name    = local.name
  cluster_version = "1.31"

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  enable_irsa = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets


  eks_managed_node_group_defaults = {
    disk_size      = 100
    instance_types = ["t3a.large", "t3.large"]

  }



  eks_managed_node_groups = {
    default = {
      name           = "default-node-group"
      min_size       = 2 # Minimum number of nodes
      max_size       = 5 # Maximum number of nodes
      desired_size   = 3 # Desired number of nodes initially
      instance_types = ["t3.large"]
      disk_size      = 100 # Root volume size (in GiB)
    }
  }


  tags = local.tags

}

resource "aws_eks_access_entry" "access-entry" {
  cluster_name      = local.name
  principal_arn     = "arn:aws:iam::977098994448:user/Devops-user"
  type              = "STANDARD"

  depends_on = [module.eks.cluster_name]
}

resource "aws_eks_access_policy_association" "policy-association1" {
  cluster_name  = local.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = "arn:aws:iam::977098994448:user/Devops-user"

  access_scope {
    type       = "cluster"
  }

  depends_on = [module.eks.cluster_name]
}

resource "aws_eks_access_policy_association" "policy-association2" {
  cluster_name  = local.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::977098994448:user/Devops-user"

  access_scope {
    type       = "cluster"
  }

  depends_on = [module.eks.cluster_name]
}

