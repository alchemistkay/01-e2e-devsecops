resource "kubernetes_service_account" "lbc" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.lbc.arn
    }
  }

  depends_on = [kubernetes_namespace.lbc_ns]
}

resource "kubernetes_namespace" "lbc_ns" {
  metadata {
    name = var.namespace
  }
}

data "aws_iam_policy_document" "assume_role_irsa" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }
  }
}

resource "aws_iam_role" "lbc" {
  name               = "${var.name_prefix}-aws-lbc-irsa"
  assume_role_policy = data.aws_iam_policy_document.assume_role_irsa.json
}

resource "aws_iam_policy" "lbc" {
  name        = "${var.name_prefix}-aws-lbc-policy"
  path        = "/"
  description = "Policy for AWS Load Balancer Controller"

  policy = file("${path.module}/iam/AWSLoadBalancerController.json")
}

resource "aws_iam_role_policy_attachment" "lbc" {
  role       = aws_iam_role.lbc.name
  policy_arn = aws_iam_policy.lbc.arn
}

resource "helm_release" "aws_lbc" {
  name       = var.release_name
  namespace  = var.namespace
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.chart_version

  values = [yamlencode({
    clusterName         = var.cluster_name
    serviceAccount = {
      create = false
      name   = var.service_account_name
    }
  })]

  depends_on = [kubernetes_service_account.lbc]
}
