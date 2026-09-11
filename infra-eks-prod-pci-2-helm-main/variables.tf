################################################################################
# Commons
################################################################################

variable "aws_account_id" {
  description = "aws-scb-prod-pci account"
  default = "099115147891"
}
variable "region" {
  default = "ap-southeast-1"
}
variable "aws_profile" {
  default = "eks-prod-pci"
}
variable "common_tags" {
  description = "A common tags which should be utilised by all resources."
  type        = map(string)

  default = {
    Owner       = "SSPU"
    Project     = "Centralized EKS"
    Environment = "PROD"
    Provisioner = "Terraform"
  }
}


################################################################################
# VPC
################################################################################

variable "vpc_id" {
  description = "prod-pci-vpc"
  default = "vpc-07134ca16a56e05f4"
}

################################################################################
# EKS
################################################################################

variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  default     = "SCB-PROD-PCI-2-EKS"
}


variable "env_prefix" {
  description = "what is this env called"
  default     = "SCB-PROD-PCI-2-EKS"
}

################################################################################
# Security Group default
################################################################################
variable "sys_sg_id" {
  description = "SG-AP-PRD-P-SYSTEM-001"
  default     = "sg-0eeff00a141a11795" #SG name:SG-AP-NPR-N-SYSTEM-001
}

################################################################################
# Enable Install helm
################################################################################

variable "ingress-nginx_enable" {
  type        = bool
  default     = true
  description = "Enabling nginx ingress on eks cluster"
}
variable "metrics-server_enable" {
  type        = bool
  default     = true
  description = "Enabling metrics-server on eks cluster"
}
variable "cluster-autoscaler_enable" {
  type        = bool
  default     = true
  description = "Enabling cluster-autoscaler on eks cluster"
}
variable "kube-downscaler_enable" {
  type        = bool
  default     = false
  description = "Enabling kube-downscaler on eks cluster"
}
variable "external-dns_enable" {
  type        = bool
  default     = true
  description = "Enabling external-dns on eks cluster"
}
variable "fluent-bit_enable" {
  type        = bool
  default     = true
  description = "Enabling fluent-bit on eks cluster"
}
variable "prometheus_enable" {
  type        = bool
  default     = false
  description = "Enabling prometheus on eks cluster"
}
variable "kube-state-metrics_enable" {
  type        = bool
  default     = true
  description = "Enabling kube-state-metrics on eks cluster"
}
variable "aws-efs-csi-driver_enable" {
  type        = bool
  default     = true
  description = "Enabling aws-efs-csi-driver on eks cluster"
}

variable "aws-node-termination-handler_enable" {
  type        = bool
  default     = false
  description = "Enabling aws-node-termination-handler on eks cluster"
}

variable "enforcer_enable" {
  type        = bool
  default     = false
  description = "Enabling enforcer on eks cluster"
}

variable "adot-exporter-for-eks-on-ec2_enable" {
  type        = bool
  default     = false
  description = "Enabling adot-exporter-for-eks-on-ec2 on eks cluster"
}

variable "istio_enable" {
  type        = bool
  default     = true
  description = "Enabling istio on eks cluster"
}

################################################################################
# EKS-Multicluster-2 ARN
################################################################################

variable "SCB-PROD-PCI-2-EKS_Cluster_IAM_role_ARN" {
  description = ""
  default     = "arn:aws:iam::099115147891:role/SCB-PROD-PCI-2-EKS2023060214412094730000000c"
}

variable "SCB-PROD-PCI-2-EKS_jenkins_role_ARN" {
  description = ""
  default     = "arn:aws:iam::099115147891:role/SCB-PROD-PCI-2-EKS-jenkins"
}

variable "SCB-PROD-PCI-2-EKS_jumpbox_role_ARN" {
  description = ""
  default     = "arn:aws:iam::099115147891:role/SCB-PROD-PCI-2-EKS-jumpbox"
}

variable "SCB-PROD-PCI-2-EKS_autoscaler_role_ARN" {
  description = ""
  default     = "arn:aws:iam::099115147891:role/SCB-PROD-PCI-2-EKS_autoscaler_role"
}
variable "SCB-PROD-PCI-2-EKS_external_dns_internal_zone_role_ARN" {
  description = ""
  default     = "arn:aws:iam::099115147891:role/SCB-PROD-PCI-2-EKS_external_dns_internal_zone_role"
}
variable "SCB-PROD-PCI-2-EKS_efs_csi_role_ARN" {
  description = ""
  default     = "arn:aws:iam::099115147891:role/SCB-PROD-PCI-2-EKS_efs_csi_role"
}

variable "SCB-PROD-PCI-2-EKS_ebs_csi_role_ARN" {
  description = ""
  default     = "arn:aws:iam::099115147891:role/SCB-PROD-PCI-2-EKS_ebs_csi_role"
}
