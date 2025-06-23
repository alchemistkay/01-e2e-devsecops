resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service_account" "ecr_access" {
  metadata {
    name      = var.service_account_name
    namespace = kubernetes_namespace.ns.metadata[0].name

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.ecr_access.arn
    }
  }
}

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
  name   = "${var.name_prefix}-ecr-read-only"
  policy = data.aws_iam_policy_document.ecr_read_only.json
}

data "aws_iam_policy_document" "assume_role_irsa" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }
  }
}

resource "aws_iam_role" "ecr_access" {
  name               = "${var.name_prefix}-ecr-access-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_irsa.json
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  policy_arn = aws_iam_policy.ecr_read_only.arn
  role       = aws_iam_role.ecr_access.name
}
