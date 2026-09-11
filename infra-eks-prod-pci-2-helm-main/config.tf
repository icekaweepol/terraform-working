# AWS configuration should be set in your configuration file at
# ~/.aws/config

# Setup plugin config
provider "aws" {
  region = "ap-southeast-1"
  assume_role {
  role_arn = "arn:aws:iam::099115147891:role/SCBJenkinAppEC2Role"
}
  default_tags {
    tags = {
      Company                   = "scb"
      AppLevel                  = "0"
      AppType                   = "prod"
      AppName                   = "Centralized EKS"
      AdminName                 = "kaweepol.khajaroenying@scb.co.th"
      AdminName2                = "chindanai.umsakul@scb.co.th"      
      Environment               = "prod"
      Provisioner               = "terraform"
      AppModule                 = "Kubernetes Cluster"
      Function                  = "app"
      Inuse                     = "yes"
    }
  }  
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.100.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.20.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }    
    helm = {
      source = "hashicorp/helm"
      version = "2.17.0"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }    
  }
}

# Push tfstate from s3
terraform {
  backend "s3" {
    bucket = "scb-aws-terraform-state-prod"
    key    = "scb-eks/states/platform/infra-eks-prod-pci-2-helm.tfstate"
    region = "ap-southeast-1" #hardcoded on purpose
  }
}