terraform {
  cloud {
    organization = "nodejs"

    workspaces {
      name = "nodejs-cloudflare"
    }
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "cloudflare" {
}
