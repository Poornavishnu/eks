provider "aws" {
  region = var.aws_region
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  # 👈 points to your local kubeconfig
  }
}
# VPC Module
module "vpc" {
  source  = "./modules/vpc"

  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

# IAM Module (EKS Node Role)
module "iam" {
  source       = "./modules/iam"
  cluster_name = var.cluster_name
}

# EKS Module
module "eks" {
  source  = "./modules/eks"

  cluster_name         = var.cluster_name
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  node_iam_role_arn    = module.iam.eks_node_role_arn
}



# # Monitoring Stack (Prometheus + Grafana)
# module "monitoring" {
#   source       = "./modules/monitoring"
#   cluster_name = var.cluster_name
#   depends_on = [module.eks]  # ensures EKS is ready before helm runs
# }

# module "ingress_controller" {
#   source = "./modules/ingress-controller"
#   depends_on = [module.eks]  # ensures EKS is ready before helm runs
# }

