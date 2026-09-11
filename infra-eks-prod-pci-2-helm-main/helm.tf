data "aws_eks_cluster" "my_eks" {
  name = var.cluster_name
}
data "aws_eks_cluster_auth" "my_eks_auth" {
  name = var.cluster_name
}
provider "helm" {  
  kubernetes {
    host                   = data.aws_eks_cluster.my_eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.my_eks.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name, "--profile", var.aws_profile]
      command     = "aws"
    }
  }    
}


#ingress-nginx
resource "helm_release" "ingress-nginx" {
  count      = var.ingress-nginx_enable == true ? 1 : 0
  name       = "ingress-nginx"
  create_namespace = true
  namespace  = "ingress-nginx"
  repository = "oci://harbor.scb.co.th/facility"
  # repository_ca_file = "helm_values/cert/diablo_SHA256.crt"
  chart      = "ingress-nginx"
  version    = "4.14.2"
  values = [
    file("helm_values/ingress-nginx/values.yaml")
  ]
  
}

resource "helm_release" "metrics-server" {
  count      = var.metrics-server_enable == true ? 1 : 0
  name       = "metrics-server"
  create_namespace = true
  namespace  = "metrics-server"
  repository = "oci://harbor.scb.co.th/facility"
  # repository_ca_file = "helm_values/cert/diablo_SHA256.crt"
  chart      = "metrics-server"
  version    = "3.13.0"
  values = [
    file("helm_values/metrics-server/values.yaml")
  ]
  
}

resource "helm_release" "cluster-autoscaler" {
  count      = var.cluster-autoscaler_enable == true ? 1 : 0
  name       = "cluster-autoscaler"
  create_namespace = false
  namespace  = "kube-system"
  repository = "oci://harbor.scb.co.th/facility"
  # repository_ca_file = "helm_values/cert/diablo_SHA256.crt"
  chart      = "cluster-autoscaler"
  version    = "9.55.0"
  values = [
    file("helm_values/cluster-autoscaler/values.yaml")
  ]
  set {
    name  = "autoDiscovery.clusterName"
    value = "${var.cluster_name}"
  }
  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${var.SCB-PROD-PCI-2-EKS_autoscaler_role_ARN}"
  }
  
}

resource "helm_release" "kube-downscaler" {
  count      = var.kube-downscaler_enable == true ? 1 : 0
  name       = "kube-downscaler"
  create_namespace = true
  namespace  = "kube-downscaler"
  repository = "oci://harbor.scb.co.th/facility"
  # repository_ca_file = "helm_values/cert/diablo_SHA256.crt"
  chart      = "kube-downscaler"
  version    = "0.4"
  values = [
    file("helm_values/kube-downscaler/values.yaml")
  ]
  
}

resource "helm_release" "external-dns" {
  count      = var.external-dns_enable == true ? 1 : 0
  name       = "external-dns"
  create_namespace = true
  namespace  = "external-dns"
  repository = "oci://harbor.scb.co.th/facility"
  # repository_ca_file = "helm_values/cert/diablo_SHA256.crt"
  chart      = "external-dns"
  version    = "5.4.11"
  values = [
    file("helm_values/external-dns/values.yaml")
  ]
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${var.SCB-PROD-PCI-2-EKS_external_dns_internal_zone_role_ARN}"
  }  
  
}

resource "helm_release" "fluent-bit" {
  count      = var.fluent-bit_enable == true ? 1 : 0
  name       = "fluent-bit"
  create_namespace = true
  namespace  = "fluent-bit"
  repository = "oci://harbor.scb.co.th/facility"
  # repository_ca_file = "helm_values/cert/diablo_SHA256.crt"
  chart      = "fluent-bit"
  version    = "0.37.1"
  values = [
    file("helm_values/fluent-bit/values.yaml")
  ]  
  
}

#prometheus
resource "helm_release" "prometheus" {
 count      = var.prometheus_enable == true ? 1 : 0  
 name       = "prometheus"
 create_namespace = true
 namespace  = "prometheus"
 repository = "oci://harbor.scb.co.th/facility"
 chart      = "prometheus"
 version    = "14.11.0"

 values = [
   file("helm_values/prometheus/values.yaml")
 ]
 depends_on = [helm_release.aws-efs-csi-driver]
}
resource "helm_release" "kube-state-metrics" {
  count      = var.kube-state-metrics_enable == true ? 1 : 0
  name       = "kube-state-metrics"
  create_namespace = true
  namespace  = "metrics"
  repository = "oci://harbor.scb.co.th/facility"
  # repository_ca_file = "helm_values/cert/diablo_SHA256.crt"
  chart      = "kube-state-metrics"
  version    = "5.10.1"
  values = [
    file("helm_values/kube-state-metrics/values.yaml")
  ]  

}
resource "helm_release" "aws-efs-csi-driver" {
  count      = var.aws-efs-csi-driver_enable == true ? 1 : 0
  name       = "aws-efs-csi-driver"
  create_namespace = false
  namespace  = "kube-system"
  repository = "oci://harbor.scb.co.th/facility"
  # repository_ca_file = "helm_values/cert/diablo_SHA256.crt"
  chart      = "aws-efs-csi-driver"
  version    = "2.4.6"
  values = [
    file("helm_values/aws-efs-csi-driver/values.yaml")
  ]
  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${var.SCB-PROD-PCI-2-EKS_efs_csi_role_ARN}"
  }
  set {
    name  = "node.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${var.SCB-PROD-PCI-2-EKS_efs_csi_role_ARN}"
  }   
  
}

resource "helm_release" "aws-node-termination-handler" {
  count      = var.aws-node-termination-handler_enable == true ? 1 : 0
  name       = "aws-node-termination-handler"
  create_namespace = false
  namespace  = "kube-system"
  repository = "oci://harbor.scb.co.th/facility"
  # repository_ca_file = "helm_values/cert/diablo_SHA256.crt"
  chart      = "aws-node-termination-handler"
  version    = "0.15.3"
  values = [
    file("helm_values/aws-node-termination-handler/values.yaml")
  ]  
  
}

# resource "helm_release" "enforcer" {
#   count      = var.enforcer_enable == true ? 1 : 0
#   name       = "enforcer"
#   create_namespace = true
#   namespace  = "aqua-security"
#   repository = "oci://harbor.scb.co.th/facility"
#   # repository_ca_file = "helm_values/cert/diablo_SHA256.crt"
#   chart      = "enforcer"
#   version    = "5.0.0"
#   values = [
#     file("helm_values/enforcer/values.yaml")
#   ]
#   set {
#     name  = "enforcerToken"
#     value = "2b71d0f1-5b25-4982-b8bc-2c9892155fc5"
#   } 
  
# }

resource "helm_release" "istio_base" {
  count      = var.istio_enable == true ? 1 : 0
  name       = "base"
  create_namespace = true
  namespace  = "istio-system"
  repository = "oci://harbor.scb.co.th/facility/istio"
  chart      = "base"
  version    = "1.28.4"
  values = [
    file("helm_values/istio/values-base.yaml")
  ]

}

resource "helm_release" "istio_istiod" {
  count      = var.istio_enable == true ? 1 : 0
  name       = "istiod"
  create_namespace = false
  namespace  = "istio-system"
  repository = "oci://harbor.scb.co.th/facility/istio"
  chart      = "istiod"
  version    = "1.28.4"
  values = [
    file("helm_values/istio/values-istiod.yaml")
  ]
  depends_on = [
    helm_release.istio_base
  ]
     
}

# resource "helm_release" "adot-exporter-for-eks-on-ec2" {
#   count      = var.adot-exporter-for-eks-on-ec2_enable == true ? 1 : 0
#   name       = "adot-exporter-for-eks-on-ec2"
#   create_namespace = true
#   namespace  = "cw-adot-insight"
#   repository = "oci://harbor.scb.co.th/facility"
#   chart      = "adot-exporter-for-eks-on-ec2"
#   version    = "0.1.0"
#   values = [
#     file("helm_values/adot-exporter-for-eks-on-ec2/values.yaml")
#   ]
#   # set {
#   #   name  = "global.namespaceOverride"
#   #   value = "cw-adot-insight"
#   # }
#   set {
#     name  = "awsRegion"
#     value = "${var.region}"
#   }
#   set {
#     name  = "clusterName"
#     value = "${var.cluster_name}"
#   }
#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = "${aws_iam_role.eks_container_insights_iam_role.arn}"
#   }
#   # set {
#   #   name  = "adotCollector.daemonSet.namespace"
#   #   value = "cw-adot-insight"
#   # }
#   set {
#     name  = "serviceAccount.annotations.name"
#     value = "cw-adot-insight-sa"
#   }
  
#   depends_on = [module.Centralized-EKS]
# }

