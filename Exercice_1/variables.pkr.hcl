variable "docker_image" {
  default = "ubuntu:jammy"
}

variable "ubuntu_focal_image" {
  default = "ubuntu:focal"
}

variable "example_text" {
  default = "FOO is hello world"
}

variable "docker_tags_jammy" {
  default = ["ubuntu-jammy", "packer-rocks"]
}

variable "docker_tags_focal" {
  default = ["ubuntu-focal", "packer-rocks"]
}
