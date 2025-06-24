packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

# Source Ubuntu
source "docker" "ubuntu" {
  image  = var.ubuntu_image
  commit = true
}

# Source Alpine
source "docker" "alpine" {
  image  = var.alpine_image
  commit = true
}

build {
  name    = "multi-os-build"
  sources = [
    "source.docker.ubuntu",
    "source.docker.alpine",
  ]

  # Copier le script dans l'image
  provisioner "file" {
    source      = "show-info.sh"
    destination = "/usr/local/bin/show-info.sh"
  }

  # Provisionnement selon la distrib (Ubuntu)
  provisioner "shell" {
    only = ["docker.ubuntu"]
    inline = [
      "apt-get update",
      "apt-get install -y curl wget",
      "chmod +x /usr/local/bin/show-info.sh",
      "/usr/local/bin/show-info.sh > /system-info.txt"
    ]
  }

  # Provisionnement selon la distrib (Alpine)
  provisioner "shell" {
    only = ["docker.alpine"]
    inline = [
      "apk update",
      "apk add curl wget",
      "chmod +x /usr/local/bin/show-info.sh",
      "/usr/local/bin/show-info.sh > /system-info.txt"
    ]
  }

  # Tag Ubuntu
  post-processor "docker-tag" {
    repository = "multi-os-ubuntu"
    tags       = ["latest"]
    only       = ["docker.ubuntu"]
  }

  # Tag Alpine
  post-processor "docker-tag" {
    repository = "multi-os-alpine"
    tags       = ["latest"]
    only       = ["docker.alpine"]
  }

  # Manifest
  post-processor "manifest" {
    output = "manifest.json"
  }
}
