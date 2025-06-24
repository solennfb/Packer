packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "node" {
  image  = "node:24"
  commit = true
  changes = [
    "WORKDIR /app/ci-cd-main", #repertoire chemin 
    "EXPOSE 3000 3000", # ouvre port 3000
    "CMD [\"npm\", \"start\"]" # commande cmd par defaut
  ]
}

build {
  name    = "ci-cd-build"
  sources = ["source.docker.node"]

  provisioner "file" {
    source      = var.archive
    destination = "/tmp/app.tar.gz"
  }

  provisioner "shell" {
    inline = [
      "mkdir -p /app", #cree le dossier /app
      "tar -xvzf /tmp/app.tar.gz -C /app", #decompresse l'archive
      "chmod -R 755 /app/ci-cd-main", #droits
      "cd /app/ci-cd-main", #deplacement
      "npm install" #installe les dependances node
    ]
  }

  post-processor "docker-tag" {
    repository = "ci-cd-app"
    tags       = ["latest"]
  }
}
