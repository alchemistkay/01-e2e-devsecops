resource "kubernetes_namespace" "ebs" {
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

resource "aws_iam_role" "ebs_csi" {
  name               = "${var.name_prefix}-ebs-csi-irsa"
  assume_role_policy = data.aws_iam_policy_document.assume_role_irsa.json
}

resource "aws_iam_role_policy_attachment" "ebs_csi" {
  role       = aws_iam_role.ebs_csi.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "kubernetes_service_account" "ebs_csi" {
  metadata {
    name      = var.service_account_name
    namespace = kubernetes_namespace.ebs.metadata[0].name

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.ebs_csi.arn
    }
  }

  depends_on = [kubernetes_namespace.ebs]
}

resource "helm_release" "ebs_csi_driver" {
  name       = var.release_name
  namespace  = var.namespace
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  version    = var.chart_version

  values = [yamlencode({
    controller = {
      serviceAccount = {
        create = false
        name   = var.service_account_name
      }
    }
  })]

  depends_on = [kubernetes_service_account.ebs_csi]
}
