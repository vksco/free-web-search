# Auto-Update Guide for SearXNG Skill

## Overview
The auto-update script automatically checks for updates from GitHub every hour and installs them seamlessly.

## Setup
### 1. Publish to GitHub
First, publish this skill to GitHub:
```bash
cd /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration
git init
git add .
git commit -m "Initial commit - SearXNG integration skill v0.0.1"
git branch -M main
git remote add origin https://github.com/vksco/searxng-skill.git
git push -u origin main
```

### 2. Configure Auto-Update Script
Edit `/Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/auto-update.sh`:

Replace `vksco` with your actual GitHub username:
```bash
REPO_URL="https://github.com/vksco/searxng-skill"
REMOTE_VERSION_URL="https://raw.githubusercontent.com/vksco/searxng-skill/main/VERSION"
```

### 3. Test Auto-Update
```bash
chmod +x /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/auto-update.sh
bash /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/auto-update.sh
```

### 4. Setup Cron Job (Auto-Check Every Hour)
```bash
# Add to crontab
crontab -e
```

Add this line:
```cron
# Check for SearXNG skill updates every hour
0 * * * * /bin/bash /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/auto-update.sh
```

Or for a more controlled approach (every 6 hours):
```cron
0 */6 * * * /bin/bash /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/auto-update.sh
```

### 5. Manual Update Check
```bash
bash /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/auto-update.sh
```

## How It Works
1. **Version Check**: Compares local VERSION file with GitHub's VERSION file
2. **Backup**: Creates backup of current skill files
3. **Download**: Pulls latest version from GitHub
4. **Preserve**: Keeps your configuration and data
5. **Install**: Updates skill files
6. **Restart**: Restarts SearXNG container if it was running
7. **Notify**: Logs update completion

## Features
- **Automatic**: Runs via cron every hour
- **Safe**: Creates backups before updating
- **Smart**: Preserves your custom config
- **Seamless**: Restarts container automatically
- **Logged**: All actions logged to update.log
- **Reversible**: Can restore from backups

## User Notification (Optional)
To notify users when an update is installed, you notification system like:

**Option 1: macOS Notification**
```bash
# Add to auto-update.sh after successful update
osascript -e 'display notification "SearXNG skill updated to v'$NEW_VERSION'" with title "OpenClaw"'
```

**Option 2: Log File Monitoring**
OpenClaw can check the update log:
```python
# In your skill or agent code
with open('/path/to/update.log', 'r') as f:
    if 'Update complete' in f.read():
        # Notify user via OpenClaw messaging
```

**Option 3: Slack/Discord Webhook**
```bash
# Add webhook notification in auto-update.sh
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"SearXNG skill updated to v'$NEW_VERSION'"}' \
  YOUR_WEBHOOK_URL
```

## Configuration Options
### Auto-Update Frequency
Edit cron schedule:
```bash
# Every hour
0 * * * * /path/to/auto-update.sh

# Every 6 hours
0 */6 * * * /path/to/auto-update.sh

# Daily at midnight
0 0 * * * /path/to/auto-update.sh

# Weekly on Sunday at midnight
0 0 * * 0 /path/to/auto-update.sh
```

### Update Branch
Change which different branch for testing:
```bash
BRANCH="develop"  # instead of "main"
```

### Skip Confirmation Prompt
For fully automatic updates without user confirmation, change in auto-update.sh:
```bash
# Comment out or remove the read -p line
# read -p "Update available. Install now? [y/N]: " -n response
# response=${response:-n}

# Always update without asking
perform_update
```

## Version File Format
The VERSION file should contain a semantic version:
```
MAJOR.MINOR.PATCH
```

Example progression:
```
0.0.1 - Initial release
0.0.2 - Bug fixes
0.1.0 - New features (backwards compatible)
1.0.0 - Breaking changes
```

## Update Workflow
```
┌─────────────┐
│   Cron Job   │
│  (hourly)    │
└──────┬──────┘
       │
       v
┌──────────────────┐
│ Check GitHub    │
│  for updates    │
└──────┬───────────┘
       │
       v
  ┌────────────────┐
  │ New version?  │
  └────┬─────┬─────┘
       No │          │ Yes
       │            │
       v            v
    Done      ┌─────────────┐
              │   Backup     │
              │   current    │
              └──────┬──────┘
                     │
                     v
              ┌─────────────┐
              │   Download  │
              │   from GH    │
              └──────┬──────┘
                     │
                     v
              ┌─────────────┐
              │  Preserve   │
              │   config     │
              └──────┬──────┘
                     │
                     v
              ┌─────────────┐
              │   Install   │
              │   update    │
              └──────┬──────┘
                     │
                     v
              ┌─────────────┐
              │  Restart   │
              │  container   │
              └─────────────┘
                     │
                     v
                ✅ Done
```

## Troubleshooting
### "Permission denied"
```bash
chmod +x /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/auto-update.sh
```

### "Command not found"
```bash
# Ensure bash path is correct
which bash
# Update script she use:
#!/bin/bash
```

### "Git clone failed"
```bash
# Check internet connection
ping github.com

# Check repository URL
curl -I https://github.com/vksco/searxng-skill
```

### "Container won't restart"
```bash
# Check container logs
docker logs searxng-openclaw

# Manually start
bash /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/docker-manager.sh start
```

### Restore from Backup
```bash
# List backups
ls -la /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/backups/

# Restore latest backup
tar -xzf /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/backups/skill_*.tar.gz -C /
```

## Security Considerations
- **HTTPS Only**: Only download from HTTPS GitHub URLs
- **Version Verification**: Checks VERSION file format
- **Backup Retention**: Keeps last 5 backups
- **Config Preservation**: Never overwrites user config
- **Log Security**: Logs don't contain sensitive data

## Testing Updates
### Test Workflow
1. Make a small change to your local files
2. Increment VERSION file
3. Push to GitHub
4. Wait for cron to run (or run manually)
5. Verify update installed

6. Check container still running

### Simulate Update
```bash
# Increment version locally
echo "0.0.2" > /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/VERSION

# Run update script
bash /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/auto-update.sh
```

## Uninstallation
To remove auto-update cron job:
```bash
crontab -e
# Delete the line containing searxng-integration
```

To disable auto-update
```bash
mv /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/auto-update.sh \
   /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/auto-update.sh.disabled
```

## Summary
✅ **Automatic**: Checks for updates every hour via cron
✅ **Safe**: Creates backups before updating
✅ **Smart**: Preserves custom config
✅ **Seamless**: Restarts container automatically
✅ **Logged**: All actions logged
✅ **Reversible**: Can restore from backups

## Quick Start
```bash
# 1. Edit auto-update.sh with your GitHub username
# 2. Make executable
chmod +x /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/auto-update.sh

# 3. Add to crontab
crontab -e
# Add: 0 * * * * /bin/bash /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/auto-update.sh

# 4. Test manually
bash /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/auto-update.sh
```

The skill will now auto-update every hour! 
