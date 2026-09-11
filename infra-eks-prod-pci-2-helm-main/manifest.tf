provider "kubectl" {
  apply_retry_count      = 15
  host                   = data.aws_eks_cluster.my_eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.my_eks.certificate_authority[0].data)
  config_path            = "~/kubeconfig/config-prod-pci-2"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name, "--profile", var.aws_profile]
  }
}

resource "null_resource" "standard" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/helm_values/istio/standard-install.yaml"
    environment = {
      KUBECONFIG = pathexpand("~/kubeconfig/config-prod-pci-2")
    }
  }
}

resource "kubectl_manifest" "istio-gateway" {
  yaml_body = file("${path.module}/helm_values/istio/istio-gateway.yaml")
  depends_on = [
    helm_release.istio_base,
    null_resource.standard,
  ]    
}

resource "kubectl_manifest" "istio-gateway-accesslog-filter" {
  yaml_body = file("${path.module}/helm_values/istio/istio-gateway-accesslog-filter.yaml")
  depends_on = [
    helm_release.istio_base,
    null_resource.standard,
    kubectl_manifest.istio-gateway,
  ]      
}

resource "null_resource" "set-option-istio-ingress" {
  triggers = {
    config_hash = filesha1("${path.module}/helm_values/istio/istio-gateway.yaml")
  }
  provisioner "local-exec" {
    command = <<EOT
     kubectl patch svc istio-gateway-istio -n istio-ingress -p '{"spec": {"externalTrafficPolicy": "Cluster"}}'
     kubectl scale deploy/istio-gateway-istio --replicas=3 -n istio-ingress
     kubectl patch deployment istio-gateway-istio -n istio-ingress --type=json \
     -p='[
       {
         "op": "add",
         "path": "/spec/template/spec/nodeSelector",
         "value": { "role": "infra" }
       }
     ]'
    EOT
    environment = {
      KUBECONFIG = pathexpand("~/kubeconfig/config-prod-pci-2")
    }
  } 
  depends_on = [
    kubectl_manifest.istio-gateway
  ]            
}