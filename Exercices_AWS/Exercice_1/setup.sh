#!/bin/bash
echo "Hello from Vagrant-ready Packer!" > index.html
nohup busybox httpd -f -p 8080 &
