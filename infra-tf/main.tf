# -----------------------------------------------------------------------------
# VPC
# -----------------------------------------------------------------------------
module "vpc" {
  source  = "./modules/vpc" 
  name    = "devsecops-vpc"
  cidr    = "10.0.0.0/16"
  azs     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# -----------------------------------------------------------------------------
# EKS Cluster
# -----------------------------------------------------------------------------
module "eks" {
  source     = "./modules/eks"
  name       = "devsecops-cluster"
  region     = var.region
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
}

# -----------------------------------------------------------------------------
# Kubernetes & Helm Providers using EKS Auth
# -----------------------------------------------------------------------------
data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

# -----------------------------------------------------------------------------
# ECR Access Module
# -----------------------------------------------------------------------------
module "ecr" {
  source                = "./modules/ecr"
  repository_names      = ["frontend", "backend"]
  namespace             = "task-app"
  service_account_name  = "ecr-access-sa"
  oidc_provider         = module.eks.oidc_provider
  oidc_provider_arn     = module.eks.oidc_provider_arn
  name_prefix           = "devsecops"
}

# -----------------------------------------------------------------------------
# ArgoCD Module
# -----------------------------------------------------------------------------
module "argocd" {
  source            = "./modules/argocd"
  namespace         = "argocd"
  name_prefix       = "devsecops"
  providers = {
    helm       = helm.eks
    kubernetes = kubernetes.eks
  }
}

# -----------------------------------------------------------------------------
# AWS Load Balancer Controller Module
# -----------------------------------------------------------------------------
module "aws_lbc" {
  source            = "./modules/aws-lbc"
  cluster_name      = module.eks.cluster_name
  oidc_provider     = module.eks.oidc_provider
  oidc_provider_arn = module.eks.oidc_provider_arn
  name_prefix       = "devsecops"
  providers = {
    helm       = helm.eks
    kubernetes = kubernetes.eks
  }
}

# -----------------------------------------------------------------------------
# EBS CSI Driver Module
# -----------------------------------------------------------------------------
module "ebs_csi_driver" {
  source            = "./modules/ebs-csi-driver"
  cluster_name      = module.eks.cluster_name
  oidc_provider     = module.eks.oidc_provider
  oidc_provider_arn = module.eks.oidc_provider_arn
  name_prefix       = "devsecops"
  providers = {
    helm       = helm.eks
    kubernetes = kubernetes.eks
  }
}

# -----------------------------------------------------------------------------
# Pod Identity Addon (Optional)
# -----------------------------------------------------------------------------
module "pod_identity" {
  source       = "./modules/pod-identity"
  cluster_name = module.eks.cluster_name
}
