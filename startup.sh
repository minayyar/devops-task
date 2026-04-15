#!/bin/bash
apt update -y
apt install nginx nodejs npm -y

npm install -g pm2
systemctl enable nginx
systemctl start nginx
mkdir -p /app
