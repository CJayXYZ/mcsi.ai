#!/bin/bash

# GitHub Actions Self-Hosted Runner Setup Script for Raspberry Pi
# This script installs and configures a GitHub Actions runner on your Pi

set -e

echo "🚀 GitHub Actions Self-Hosted Runner Setup"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
REPO_OWNER="CJayXYZ"
REPO_NAME="mcsi.ai"
DEPLOY_DIR="/home/prime/github-deployment/mcsi.ai"
RUNNER_DIR="/home/prime/actions-runner"

echo -e "${BLUE}Repository:${NC} ${REPO_OWNER}/${REPO_NAME}"
echo -e "${BLUE}Deploy Directory:${NC} ${DEPLOY_DIR}"
echo -e "${BLUE}Runner Directory:${NC} ${RUNNER_DIR}"
echo ""

# Step 1: Create deployment directory
echo -e "${GREEN}[1/6]${NC} Creating deployment directory..."
mkdir -p "$DEPLOY_DIR"
cd "$DEPLOY_DIR"

# Initialize git repo if not already
if [ ! -d ".git" ]; then
    git init
    git remote add origin "https://github.com/${REPO_OWNER}/${REPO_NAME}.git"
    echo "✅ Git repository initialized"
else
    echo "✅ Git repository already exists"
fi

# Step 2: Create runner directory
echo ""
echo -e "${GREEN}[2/6]${NC} Creating runner directory..."
mkdir -p "$RUNNER_DIR"
cd "$RUNNER_DIR"

# Step 3: Download the latest runner package
echo ""
echo -e "${GREEN}[3/6]${NC} Downloading GitHub Actions runner..."
RUNNER_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | grep -oP '"tag_name": "v\K(.*)(?=")')
echo "Latest version: ${RUNNER_VERSION}"

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ]; then
    RUNNER_ARCH="arm64"
elif [ "$ARCH" = "armv7l" ]; then
    RUNNER_ARCH="arm"
else
    echo "❌ Unsupported architecture: $ARCH"
    exit 1
fi

RUNNER_FILE="actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz"
DOWNLOAD_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${RUNNER_FILE}"

echo "Downloading: ${DOWNLOAD_URL}"
curl -o "${RUNNER_FILE}" -L "${DOWNLOAD_URL}"

# Step 4: Extract the installer
echo ""
echo -e "${GREEN}[4/6]${NC} Extracting runner..."
tar xzf "./${RUNNER_FILE}"
rm "${RUNNER_FILE}"
echo "✅ Runner extracted"

# Step 5: Configure the runner
echo ""
echo -e "${GREEN}[5/6]${NC} Configuring runner..."
echo ""
echo -e "${YELLOW}⚠️  IMPORTANT: You need a GitHub Personal Access Token${NC}"
echo ""
echo "To get your token:"
echo "1. Go to: https://github.com/settings/tokens/new"
echo "2. Give it a name: 'Pi Runner for mcsi.ai'"
echo "3. Select scopes: 'repo' (full control)"
echo "4. Click 'Generate token'"
echo "5. Copy the token (you won't see it again!)"
echo ""
read -p "Enter your GitHub Personal Access Token: " GITHUB_TOKEN
echo ""

# Configure runner
./config.sh \
    --url "https://github.com/${REPO_OWNER}/${REPO_NAME}" \
    --token "${GITHUB_TOKEN}" \
    --name "raspberry-pi" \
    --work "_work" \
    --labels "self-hosted,Linux,ARM" \
    --unattended

echo "✅ Runner configured"

# Step 6: Install and start the service
echo ""
echo -e "${GREEN}[6/6]${NC} Installing runner as a service..."
sudo ./svc.sh install
sudo ./svc.sh start
echo "✅ Runner service installed and started"

# Verify service status
echo ""
echo -e "${GREEN}Checking service status...${NC}"
sudo ./svc.sh status

echo ""
echo -e "${GREEN}=========================================="
echo "✅ Setup Complete!"
echo "==========================================${NC}"
echo ""
echo "Next steps:"
echo "1. Go to: https://github.com/${REPO_OWNER}/${REPO_NAME}/settings/actions/runners"
echo "2. Verify your runner appears as 'Online'"
echo "3. Push code to GitHub and watch it auto-deploy!"
echo ""
echo "Useful commands:"
echo "  Check status:  cd ${RUNNER_DIR} && sudo ./svc.sh status"
echo "  Stop runner:   cd ${RUNNER_DIR} && sudo ./svc.sh stop"
echo "  Start runner:  cd ${RUNNER_DIR} && sudo ./svc.sh start"
echo "  View logs:     journalctl -u actions.runner.* -f"
echo ""
