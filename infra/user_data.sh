#!/bin/bash
sudo dnf update -y
amazon-linux-extras enable epel -y
sudo dnf install -y git nodejs npm mysql jq
 
# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo \https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo dnf upgrade -y
sudo dnf install -y java-17-amazon-corretto jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
 
# Clone repo
sudo cd /home/ec2-user
sudo git clone https://github.com/pranjalM0408/doctor-appointment.git
 
# Install Node app dependencies
sudo cd doctor-appointment/node_app
sudo npm install
 
# Start app
sudo nohup node server.js > output.log 2>&1 &