packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
    docker = {
      source  = "github.com/hashicorp/docker"
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
  default = "nginx-multi-ami-{{timestamp}}"
}

variable "docker_image_name" {
  type    = string
  default = "nginx-packer"
}

# --- AWS Builder ---
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

# --- Docker Builder ---
source "docker" "ubuntu" {
  image  = "ubuntu:22.04"
  commit = true
}

# --- Build AWS ---
build {
  name    = "aws-ami-build"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    script = "setup.sh"
  }
}

# --- Build Docker ---
build {
  name    = "docker-image-build"
  sources = ["source.docker.ubuntu"]

  provisioner "shell" {
    script = "setup.sh"
  }

  post-processor "docker-tag" {
  repository = var.docker_image_name
  tag        = ["latest"]
}

  post-processor "docker-save" {
    path = "output/docker-nginx.tar"
  }
}