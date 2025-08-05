module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.13.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  subnet_ids      = var.private_subnet_ids
  vpc_id          = var.vpc_id
  enable_irsa     = true

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["142.126.95.54/32"]
  cluster_endpoint_private_access      = true

    # 👇 Enable Access Entry Mode (instead of aws-auth)
  authentication_mode = "API"

  access_entries = {
    admin = {
      principal_arn = "arn:aws:iam::970547371216:user/vishnu"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
  

  eks_managed_node_groups = {
    frontend = {
      desired_size   = 1
      max_size       = 2
      min_size       = 1
      instance_types = ["t3.micro"]
      labels = {
        workload = "frontend"
      }
      taints = [{
        key    = "workload"
        value  = "frontend"
        effect = "NO_SCHEDULE"
      }]
    }

    backend = {
      desired_size   = 1
      max_size       = 2
      min_size       = 1
      instance_types = ["t3.micro"]
      labels = {
        workload = "backend"
      }
      taints = [{
        key    = "workload"
        value  = "backend"
        effect = "NO_SCHEDULE"
      }]
    }

    db = {
      desired_size   = 1
      max_size       = 2
      min_size       = 1
      instance_types = ["t3.micro"]
      labels = {
        workload = "db"
      }
      taints = [{
        key    = "workload"
        value  = "db"
        effect = "NO_SCHEDULE"
      }]
    }

    general = {
      desired_size   = 1
      max_size       = 2
      min_size       = 1
      instance_types = ["t3.micro"]

      labels = {
        workload = "general"
      }

      taints = []  # 🔥 No taints = accepts everything (default behavior)
    }
      tags = {
        "k8s.io/cluster-autoscaler/enabled"             = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      }

    monitoring = {
      desired_size   = 1
      max_size       = 4
      min_size       = 1
      instance_types = ["t3.micro"]
      labels = {
        workload = "monitoring"
      }
  #     taints = [{
  #       key    = "workload"
  #       value  = "monitoring"
  #       effect = "NO_SCHEDULE"
  #     }]
        tags = {
          "k8s.io/cluster-autoscaler/enabled"             = "true"
          "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
        }
    }
  }

  node_security_group_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

  iam_role_arn = var.node_iam_role_arn
}
