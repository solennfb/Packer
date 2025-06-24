# Déclaration des plugins Packer
packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

# Source 1 : image Docker basée sur Ubuntu Jammy
source "docker" "ubuntu" {
  image  = var.docker_image   # variable définie dans variables.pkr.hcl
  commit = true               # sauvegarde les changements faits dans l'image
}

# Source 2 : image Docker basée sur Ubuntu Focal
source "docker" "ubuntu-focal" {
  image  = var.ubuntu_focal_image  # variable définie dans variables.pkr.hcl
  commit = true
}

# Build
build {
  name    = "learn-packer"
  sources = [
    "source.docker.ubuntu",         # utilise la source ubuntu jammy
    "source.docker.ubuntu-focal",   # utilise la source ubuntu focal
  ]

  # Provisioner FILE : copie le fichier local welcome.txt dans /home/ de l'image
  provisioner "file" {
    source      = "welcome.txt"         # fichier local à copier
    destination = "/home/welcome.txt"   # chemin dans le conteneur
  }

  # Provisioner SHELL : crée un fichier texte avec le contenu via la commande
  provisioner "shell" {
    environment_vars = ["FOO=hello world"]   # variable d'environnement pendant le script
    inline = [
      "echo Adding file to Docker Container",                # simple message
      "echo \"${var.example_text}\" > example.txt",         # écrit du texte dans example.txt
    ]
  }

  # Post-processor : tague l'image Ubuntu Jammy avec des tags depuis une variable
  post-processor "docker-tag" {
    repository = "learn-packer"
    tags       = var.docker_tags_jammy
    only       = ["docker.ubuntu"]   # s'applique uniquement à cette source
  }

  # Post-processor : tague l'image Ubuntu Focal avec des tags depuis une variable
  post-processor "docker-tag" {
    repository = "learn-packer"
    tags       = var.docker_tags_focal
    only       = ["docker.ubuntu-focal"]
  }

  # Post-processor : génère un fichier manifest.json listant les artefacts produits
  post-processor "manifest" {
    output = "manifest.json"
  }
}

