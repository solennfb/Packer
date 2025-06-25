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
  default = "learn-packer-vagrant-{{timestamp}}"
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
    script = "setup.sh"
  }

  #post-processor "vagrant" {
   # output = "output/ubuntu-ami-virtualbox.box"
    #keep_input_artifact = true
    #compression_level = 9
  #}
}
