resource "helm_release" "nginx" {
  name = "ingress-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  create_namespace = true
  namespace        = "ingress-nginx"

}

resource "helm_release" "cert_manager" {
  name = "cert-manager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  create_namespace = true
  namespace        = "cert-manager"
  version          = "v1.15.3"



  set {
    name  = "wait-for"
    value = module.cert_manager_irsa_role.iam_role_arn
  }

  set {
    name  = "installCRDs"
    value = "true"
  }

  values = [file("../helm_values/cert-manager.yaml")]

}


resource "helm_release" "external_dns" {
  name = "external-dns"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"

  create_namespace = true
  namespace        = "external-dns"
  version          = "8.3.5"

  set {
    name  = "wait-for"
    value = module.external_dns_irsa_role.iam_role_arn
  }

  values = [file("../helm_values/external-dns.yaml")]

}

resource "helm_release" "argocd_deploy" {

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.19.15"
  timeout    = "600"

  create_namespace = true
  namespace        = "argo-cd"


  values = [file("../helm_values/argocd.yaml")]

}

resource "helm_release" "prometheus" {

  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  timeout    = "600"

  create_namespace = true
  namespace        = "prometheus"


  values = [file("../helm_values/prometheus.yaml"),file("../helm_values/grafana.yaml")]


}