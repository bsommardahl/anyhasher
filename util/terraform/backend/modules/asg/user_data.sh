#!/bin/bash
set -e

# Logging setup
exec > >(tee /var/log/user-data.log) 2>&1
echo "Starting user data script at $(date)"

# Variables from Terraform
VERSION="${version}"
S3_BUCKET="${s3_bucket}"
ENVIRONMENT="${environment}"

# Update system
echo "Updating system packages..."
sudo apt-get update

# Install dependencies
echo "Installing Node.js, npm, unzip, and curl..."
sudo apt-get install -y nodejs npm unzip curl

# Install AWS CLI v2
echo "Installing AWS CLI v2..."
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
sudo rm -rf awscliv2.zip aws/

# Install pm2 globally
echo "Installing PM2..."
sudo npm install -g pm2

# Create application directory
echo "Creating application directory..."
sudo mkdir -p /opt/anyhasher
cd /opt/anyhasher

# Download artifact from S3
echo "Downloading artifact version $VERSION from S3..."
sudo aws s3 cp s3://$S3_BUCKET/backend/$VERSION/backend-artifact-$VERSION.tar.gz ./

# Extract artifact
echo "Extracting artifact..."
sudo tar -xzf backend-artifact-$VERSION.tar.gz
sudo rm backend-artifact-$VERSION.tar.gz

# Set permissions
sudo chown -R ubuntu:ubuntu /opt/anyhasher

# Install application dependencies (if package.json exists)
if [ -f "/opt/anyhasher/package.json" ]; then
    echo "Installing application dependencies..."
    sudo npm install --production
fi

# Start application with PM2
echo "Starting application with PM2..."
sudo pm2 start server.js --name anyhasher-backend

# Configure PM2 to start on boot
sudo pm2 startup systemd -u ubuntu --hp /home/ubuntu
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u ubuntu --hp /home/ubuntu
sudo pm2 save

echo "User data script completed successfully at $(date)"
