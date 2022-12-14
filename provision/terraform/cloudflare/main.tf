terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.24.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.1.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.1"
    }
  }
}

data "sops_file" "cloudflare_secrets" {
  source_file = "cloudflare_secrets.sops.yaml"
}

provider "cloudflare" {
  # ? Email is optional and not needed when using token
  #email     = data.sops_file.cloudflare_secrets.data["email"]
  api_token = data.sops_file.cloudflare_secrets.data["api_token"]
}

data "cloudflare_zones" "domain" {
  filter {
    name = data.sops_file.cloudflare_secrets.data["domain"]
  }
}