#!/bin/bash
# Update package repository and install Apache
yum update -y
yum install -y httpd

# Start Apache service and enable it to start on boot
systemctl start httpd
systemctl enable httpd

# Create a simple HTML page
echo "<html><body><h1>Welcome to the Apache Web Server on EC2!</h1></body></html>" > /var/www/html/index.html

# Ensure Apache is running
systemctl status httpd
