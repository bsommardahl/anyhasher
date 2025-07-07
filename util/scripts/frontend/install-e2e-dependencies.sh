#!/bin/bash
set -e

echo "📦 Installing system dependencies for E2E tests..."

sudo apt-get update
sudo apt-get install -y \
  libnss3-dev \
  libatk-bridge2.0-dev \
  libdrm2 \
  libxkbcommon0 \
  libgtk-3-dev \
  libgbm-dev

echo "✅ System dependencies installed successfully"