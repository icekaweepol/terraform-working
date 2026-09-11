provider "kubernetes" {
  host                   = data.aws_eks_cluster.my_eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.my_eks.certificate_authority[0].data)
  config_path            = "~/kubeconfig/config-prod-pci-2"
  exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name, "--profile", var.aws_profile]
  }
}

resource "kubernetes_secret" "ingress-nginx-scb-tls-cert" {
  metadata {
    name = "scb-tls-cert"
    namespace = "ingress-nginx"
  }

    data = {
     "tls.crt" = file("certs/scb-self.crt")
     "tls.key" = file("certs/scb-self.key")
    }

  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "istio-scb-tls-cert" {
  metadata {
    name = "scb-tls-cert"
    namespace = "istio-ingress"
  }

    data = {
     "tls.crt" = file("certs/scb-self.crt")
     "tls.key" = file("certs/scb-self.key")
    }

  type = "kubernetes.io/tls"
}