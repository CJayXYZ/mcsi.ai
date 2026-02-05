# mcsi.ai

Auto-deploying web application hosted on Raspberry Pi with GitHub Actions.

## 🚀 Features

- ✅ **Auto-Deploy**: Push to GitHub → Automatically deploys to Pi within seconds
- ✅ **Self-Hosted Runner**: GitHub Actions runs directly on your Pi (100% free)
- ✅ **PM2 Integration**: Automatically restarts services after deployment
- ✅ **Zero Cost**: Completely free forever (no paid services)

## 📦 How It Works

1. You push code to GitHub (`main` branch)
2. GitHub Actions triggers workflow
3. Self-hosted runner on Pi receives the job
4. Code is pulled to `/home/prime/github-deployment/mcsi.ai`
5. PM2 service restarts automatically (if configured)
6. Deployment complete! ✨

## 🛠️ Setup Instructions

### One-Time Setup on Raspberry Pi

1. **SSH into your Pi**:
   ```bash
   ssh prime@<your-pi-ip>
   ```

2. **Download and run the setup script**:
   ```bash
   # Clone this repo (or download the setup script)
   git clone https://github.com/CJayXYZ/mcsi.ai.git
   cd mcsi.ai/pi-scripts
   
   # Make script executable
   chmod +x setup-runner.sh
   
   # Run setup
   ./setup-runner.sh
   ```

3. **Follow the prompts**:
   - You'll need a GitHub Personal Access Token
   - Go to: https://github.com/settings/tokens/new
   - Select scope: `repo` (full control)
   - Copy the token and paste when prompted

4. **Verify runner is online**:
   - Go to: https://github.com/CJayXYZ/mcsi.ai/settings/actions/runners
   - You should see "raspberry-pi" with status "Idle" (green)

### First Deployment

1. **Push code to GitHub**:
   ```bash
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```

2. **Watch the magic happen**:
   - Go to: https://github.com/CJayXYZ/mcsi.ai/actions
   - You'll see the workflow running
   - Code automatically deploys to your Pi!

## 📁 Project Structure

```
mcsi.ai/
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions workflow
├── pi-scripts/
│   ├── setup-runner.sh         # One-time Pi setup script
│   └── deploy.sh               # Deployment script (called by workflow)
└── README.md
```

## 🔧 PM2 Service (Optional)

If you're running a Node.js app or service, set up PM2:

```bash
# On your Pi
cd /home/prime/github-deployment/mcsi.ai
pm2 start your-app.js --name mcsi.ai
pm2 save
pm2 startup
```

Now deployments will automatically restart your service!

## 📊 Monitoring

### View deployment logs on Pi:
```bash
tail -f /home/prime/github-deployment/mcsi.ai/deploy.log
```

### View runner logs:
```bash
journalctl -u actions.runner.* -f
```

### Check runner status:
```bash
cd /home/prime/actions-runner
sudo ./svc.sh status
```

## 🐛 Troubleshooting

### Runner shows offline
```bash
cd /home/prime/actions-runner
sudo ./svc.sh start
```

### Deployment failed
- Check GitHub Actions logs: https://github.com/CJayXYZ/mcsi.ai/actions
- Check Pi logs: `journalctl -u actions.runner.* -f`

### Need to reconfigure runner
```bash
cd /home/prime/actions-runner
sudo ./svc.sh stop
./config.sh remove
# Then run setup-runner.sh again
```

## 💡 Tips

- **Free Forever**: GitHub Actions is free for public repos with unlimited minutes on self-hosted runners
- **Always Online**: The runner service auto-starts on Pi boot
- **Instant Deploy**: Changes appear on Pi within 5-10 seconds of pushing
- **No External Services**: Everything runs on your infrastructure

## 🔗 Links

- **Repository**: https://github.com/CJayXYZ/mcsi.ai
- **Actions**: https://github.com/CJayXYZ/mcsi.ai/actions
- **Runners**: https://github.com/CJayXYZ/mcsi.ai/settings/actions/runners

---

**Deployment Directory on Pi**: `/home/prime/github-deployment/mcsi.ai`
