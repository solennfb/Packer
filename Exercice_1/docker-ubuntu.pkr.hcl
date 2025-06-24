packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = var.docker_image
  commit = true
}

source "docker" "ubuntu-focal" {
  image  = var.ubuntu_focal_image
  commit = true
}

build {
  name    = "learn-packer"
  sources = [
    "source.docker.ubuntu",
    "source.docker.ubuntu-focal",
  ]

  provisioner "shell" {
    environment_vars = ["FOO=hello world"]
    inline = [
      "echo Adding file to Docker Container",
      "echo \"${var.example_text}\" > example.txt",
    ]
  }

  post-processor "docker-tag" {
    repository = "learn-packer"
    tags       = var.docker_tags_jammy
    only       = ["docker.ubuntu"]
  }

  post-processor "docker-tag" {
    repository = "learn-packer"
    tags       = var.docker_tags_focal
    only       = ["docker.ubuntu-focal"]
  }
}

