#!/bin/bash

# Deployment script for mcsi.ai
# This script is called by GitHub Actions to deploy changes

set -e

DEPLOY_DIR="/home/prime/github-deployment/mcsi.ai"
LOG_FILE="/home/prime/github-deployment/mcsi.ai/deploy.log"

echo "=========================================="
echo "🚀 Deploying mcsi.ai"
echo "=========================================="
echo "Time: $(date)"
echo ""

# Navigate to deployment directory
cd "$DEPLOY_DIR"

# Pull latest changes
echo "📥 Pulling latest changes from GitHub..."
git fetch origin main
git reset --hard origin/main

echo "✅ Code updated successfully"

# Log deployment
echo "[$(date)] Deployment successful" >> "$LOG_FILE"

# Check if PM2 service exists and update/restart it
if pm2 list | grep -q "hello-server"; then
    echo "🔄 Updating PM2 service 'hello-server' to new deployment..."
    pm2 delete hello-server
    pm2 start "$DEPLOY_DIR/server.js" --name hello-server
    echo "✅ Service updated and restarted on port 8080"
else
    echo "🆕 Creating new PM2 service 'hello-server'..."
    pm2 start "$DEPLOY_DIR/server.js" --name hello-server
    pm2 save
    echo "✅ Service created and started on port 8080"
fi

echo ""
echo "=========================================="
echo "✅ Deployment Complete!"
echo "=========================================="
