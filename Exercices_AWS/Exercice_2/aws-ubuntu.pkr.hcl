packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ami_name" {
  type    = string
  default = "node-env-ami-{{timestamp}}"
}

variable "env" {
  type    = string
  default = "dev"
  validation {
    condition     = contains(["dev", "staging", "production"], var.env)
    error_message = "La variable env doit être soit dev, staging ou production."
  }
}

variable "node_version" {
  type = string
  default = "20.12.1"
  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+$", var.node_version))
    error_message = "La version de Node doit être au format x.y.z (exemple : 20.12.1)."
}
}

source "amazon-ebs" "ubuntu" {
  region           = var.region
  instance_type    = "t2.micro"
  ami_name         = var.ami_name
  ssh_username     = "ubuntu"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    script = "install_node.sh"
    environment_vars = [
      "ENV=${var.env}",
      "NODE_VERSION=${var.node_version}"
    ]
  }
}
