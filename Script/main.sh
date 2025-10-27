#!/bin/bash

# Step 1: Install required dependencies
sudo su

echo "==================================="
echo "      Instaling dependencies       "
echo "==================================="
sleep 2
yum -y install nginx python3 python3-pip & wait


echo "==================================="
echo "      Creating project files       "
echo "==================================="
sleep 2

# Step 2: Create project folders path
mkdir -p /var/www/flask
cd /var/www/flask

# Step 3: Create a virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Step 4: Installing Gunicorn and Flask
echo "==================================="
echo "  Installing Gunicorn and Flask    "
echo "==================================="
sleep 2
pip install --upgrade pip
pip3 install gunicorn flask & wait


echo "==================================="
echo "       gninx configuration         "
echo "==================================="

# Step 5: Create an endpoint
curl https://raw.githubusercontent.com/jgarta-codesource/cloudflare-free-tier-demo/refs/heads/main/Endpoint%20server%20files/app.py -o app.py


# Step 7: Configure SSL cert (self-signed)
mkdir -p /etc/ssl/mycert/
chmod 700 /etc/ssl/mycert/

echo "==================================="
echo " Type your domain configuration    "
echo "==================================="

sleep 3
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/mycert/selfsigned.key -out /etc/ssl/certs/selfsigned.crt -f

# Step 8: Configure Nginx

rm -f /etc/nginx/nginx.conf
curl https://raw.githubusercontent.com/jgarta-codesource/cloudflare-free-tier-demo/refs/heads/main/Endpoint%20server%20files/nginx.conf -o /etc/nginx/nginx.conf

setsebool -P httpd_can_network_connect 1


### commands
1. sudo su

2. vi main.sh
1. chmod +x main.sh
2. ./main.sh


vi nginx.conf
cd /var/www/flask
source .venv/bin/activate
systemctl start nginx
gunicorn -b 127.0.0.1:8080 app:app


troubleshoot 
cd /var/www/flask
cd /etc/nginx

