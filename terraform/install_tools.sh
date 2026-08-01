#!/bin/bash
set -e

# Update system packages and install Java 21 prerequisites
sudo apt-get update -y
sudo apt-get install -y fontconfig openjdk-21-jdk openjdk-21-jre wget curl apt-transport-https gnupg lsb-release snapd

# Configure Jenkins GPG keyring and APT repository
sudo mkdir -p /usr/share/keyrings
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key | sudo gpg --dearmor --yes -o /usr/share/keyrings/jenkins-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install and enable Jenkins service
sudo apt-get update -y
sudo apt-get install -y jenkins
sudo systemctl daemon-reload
sudo systemctl enable --now jenkins

# Install Docker and configure group permissions for ubuntu and jenkins users
sudo apt-get install -y docker.io
sudo usermod -aG docker ubuntu
sudo usermod -aG docker jenkins || true
sudo systemctl restart docker
sudo systemctl restart jenkins

# Configure Trivy GPG keyring, APT repository, and install Trivy
sudo mkdir -p /etc/apt/keyrings
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/trivy.gpg
echo "deb [signed-by=/etc/apt/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb noble main" | sudo tee /etc/apt/sources.list.d/trivy.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y trivy

# Install AWS CLI, Helm, and Kubectl using snap
sudo snap wait system seed.loaded || sleep 10
sudo snap install aws-cli --classic || true
sudo snap install helm --classic || true
sudo snap install kubectl --classic || true
