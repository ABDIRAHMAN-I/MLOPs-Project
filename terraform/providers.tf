terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6"
    }
  }

}


provider "aws" {
  region = "eu-west-2"

}


provider "helm" {
  kubernetes {
    host                   = module.infrastructure.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.infrastructure.eks_cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.infrastructure.eks_cluster_name]
      command     = "aws"
    }
  }
}
