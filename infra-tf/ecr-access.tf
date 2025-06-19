resource "kubernetes_namespace" "task_app" {
  metadata {
    name = "task-app"
  }
}

resource "kubernetes_service_account" "ecr_access" {
  metadata {
    name      = "ecr-access-sa"
    namespace = kubernetes_namespace.task_app.metadata[0].name
  }
}

data "aws_iam_policy_document" "ecr_read_only" {
  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecr_policy" {
  name   = "ECRReadOnlyPolicy"
  policy = data.aws_iam_policy_document.ecr_read_only.json
}

resource "aws_iam_role" "ecr_pod_identity" {
  name = "ECRPodIdentityRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "pods.eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_policy_attach" {
  role       = aws_iam_role.ecr_pod_identity.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}

resource "aws_eks_pod_identity_association" "ecr_access" {
  cluster_name = module.eks.cluster_name
  namespace    = kubernetes_namespace.task_app.metadata[0].name
  service_account = kubernetes_service_account.ecr_access.metadata[0].name
  role_arn     = aws_iam_role.ecr_pod_identity.arn
}
