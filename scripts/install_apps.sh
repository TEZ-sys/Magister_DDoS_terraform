#!/bin/bash
sudo apt-get update -y
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

echo "<h1>Welcome to DevOps DDoS Protection System</h1>" | sudo tee /var/www/html/index.html
sudo systemctl restart nginx

sudo apt install redis-server