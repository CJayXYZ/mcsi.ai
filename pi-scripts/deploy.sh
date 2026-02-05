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

# Check if PM2 service exists and restart it
if pm2 list | grep -q "mcsi.ai"; then
    echo "🔄 Restarting PM2 service 'mcsi.ai'..."
    pm2 restart mcsi.ai
    echo "✅ Service restarted"
else
    echo "ℹ️  No PM2 service named 'mcsi.ai' found"
    echo "   To create one, run: pm2 start <your-app> --name mcsi.ai"
fi

echo ""
echo "=========================================="
echo "✅ Deployment Complete!"
echo "=========================================="
