#!/bin/bash
set -e

# Logging setup
exec > >(tee /var/log/user-data.log) 2>&1
echo "Starting user data script at $(date)"

# Variables from Terraform
VERSION="${version}"
S3_BUCKET="${s3_bucket}"
ENVIRONMENT="${environment}"

# Install only essential tools for Ansible
echo "Installing essential tools..."
sudo apt-get update
sudo apt-get install -y unzip curl ansible

# Install AWS CLI v2
echo "Installing AWS CLI v2..."
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
sudo rm -rf awscliv2.zip aws/

# Create application directory
echo "Creating application directory..."
sudo mkdir -p /home/ubuntu/anyhasher/build
cd /home/ubuntu/anyhasher

# Download artifact from S3
echo "Downloading artifact version $VERSION from S3..."
sudo aws s3 cp s3://$S3_BUCKET/backend/$VERSION/backend-artifact-$VERSION.tar.gz ./

# Extract artifact to the path Ansible expects
echo "Extracting artifact..."
sudo tar -xzf backend-artifact-$VERSION.tar.gz -C build/
sudo rm backend-artifact-$VERSION.tar.gz

# Set permissions
sudo chown -R ubuntu:ubuntu /home/ubuntu/anyhasher

# Download Ansible playbooks from S3
echo "Downloading Ansible playbooks from S3..."
sudo aws s3 cp s3://$S3_BUCKET/ansible/ /tmp/ansible/ --recursive || echo "No Ansible files found in S3, skipping..."

# Run Ansible playbook if it exists
if [ -f "/tmp/ansible/deploy.yml" ]; then
    echo "Running Ansible configuration..."
    cd /tmp/ansible
    # Create simple inventory for localhost
    echo "localhost ansible_connection=local" > /tmp/ansible/inventory
    # Run playbook
    sudo -u ubuntu ansible-playbook -i inventory deploy.yml --connection=local || echo "Ansible playbook failed, continuing..."
else
    echo "No Ansible playbook found, skipping configuration..."
fi

echo "User data script completed successfully at $(date)"
