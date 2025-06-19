# Create the Kubernetes namespace
resource "kubernetes_namespace" "task_app" {
  metadata {
    name = "task-app"
  }
}

# Create the Kubernetes ServiceAccount
resource "kubernetes_service_account" "ecr_access" {
  metadata {
    name      = "ecr-access-sa"
    namespace = kubernetes_namespace.task_app.metadata[0].name

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.ecr_access.arn
    }
  }
}

# Create IAM policy for ECR read-only access
data "aws_iam_policy_document" "ecr_read_only" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecr_read_only" {
  name   = "ECRReadOnlyPolicy"
  policy = data.aws_iam_policy_document.ecr_read_only.json
}

# Create IAM role for IRSA
data "aws_iam_policy_document" "assume_role_irsa" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:sub"
      values   = ["system:serviceaccount:task-app:ecr-access-sa"]
    }
  }
}

resource "aws_iam_role" "ecr_access" {
  name               = "ECRAccessRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_irsa.json
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  policy_arn = aws_iam_policy.ecr_read_only.arn
  role       = aws_iam_role.ecr_access.name
}
