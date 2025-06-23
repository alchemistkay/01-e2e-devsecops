resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
    labels = {
      "argocd.argoproj.io/managed-by" = var.namespace
    }
  }
}

resource "helm_release" "argocd" {
  name       = var.release_name
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version

  values = [yamlencode(var.values)]

  create_namespace = false

  depends_on = [kubernetes_namespace.argocd]
}
