output "public_ip" {
  value = aws_instance.nginx.public_ip
  description = "IP publique de l'instance Nginx"
}
