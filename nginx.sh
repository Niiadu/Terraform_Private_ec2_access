#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install nginx -y
sudo systemctl enable nginx
sudo -i
echo "<h1>welcome to Nii Adu personal blog</h1>" > /var/www/html/index.html