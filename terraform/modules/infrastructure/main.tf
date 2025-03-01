# VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = var.local_name
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_vpn_gateway   = true

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.local_name}" = "shared"
    "kubernetes.io/role/internal-elb"         = 1
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.local_name}" = "shared"
    "kubernetes.io/role/elb"                  = 1
  }

  tags = var.tags
}

# EKS
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.4"

  cluster_name    = var.local_name
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
      min_size       = 2
      max_size       = 5
      desired_size   = 3
      instance_types = ["t3.large"]
      disk_size      = 100
    }
  }

  tags = var.tags
}

# EKS Access Entries
resource "aws_eks_access_entry" "access-entry" {
  cluster_name  = var.local_name
  principal_arn = "arn:aws:iam::977098994448:user/Devops-user"
  type          = "STANDARD"

  depends_on = [module.eks]
}

resource "aws_eks_access_policy_association" "policy-association1" {
  cluster_name  = var.local_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = "arn:aws:iam::977098994448:user/Devops-user"

  access_scope {
    type = "cluster"
  }

  depends_on = [module.eks]
}

resource "aws_eks_access_policy_association" "policy-association2" {
  cluster_name  = var.local_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::977098994448:user/Devops-user"

  access_scope {
    type = "cluster"
  }

  depends_on = [module.eks]
}

# IRSA Roles
module "cert_manager_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.2.0"

  role_name                     = "cert-manager"
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z0258866R82A74DOTKTP"]

  oidc_providers = {
    eks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["cert-manager:cert-manager"]
    }
  }
}

module "external_dns_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.2.0"

  role_name                     = "external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z0258866R82A74DOTKTP"]

  oidc_providers = {
    eks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["external-dns:external-dns"]
    }
  }
}
