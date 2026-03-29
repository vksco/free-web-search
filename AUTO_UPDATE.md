# Auto-Update Guide for Free Web Search Skill

## Overview
The auto-update script automatically checks for updates from GitHub every hour and installs them seamlessly.

## Setup

### 1. Make Script Executable
```bash
chmod +x scripts/auto-update.sh
```

### 2. Test Auto-Update
```bash
bash scripts/auto-update.sh
```

### 3. Setup Cron Job (Auto-Check Every Hour)
```bash
crontab -e
```

Add this line:
```cron
# Check for skill updates every hour
0 * * * * /bin/bash /path/to/free-web-search/scripts/auto-update.sh
```

**Replace `/path/to/` with your actual installation path.**

Examples for different systems:
```bash
# macOS
0 * * * * /bin/bash /Users/YOUR_USERNAME/.openclaw/workspace/skills/free-web-search/scripts/auto-update.sh

# Linux
0 * * * * /bin/bash /home/YOUR_USERNAME/.openclaw/workspace/skills/free-web-search/scripts/auto-update.sh

# Or use $HOME
0 * * * * /bin/bash $HOME/.openclaw/workspace/skills/free-web-search/scripts/auto-update.sh
```

### 4. Alternative Schedules

Every 6 hours:
```cron
0 */6 * * * /bin/bash /path/to/free-web-search/scripts/auto-update.sh
```

Daily at midnight:
```cron
0 0 * * * /bin/bash /path/to/free-web-search/scripts/auto-update.sh
```

Weekly on Sunday:
```cron
0 0 * * 0 /bin/bash /path/to/free-web-search/scripts/auto-update.sh
```

---

## How It Works

### Update Process (7 Steps)

1. **Version Check** - Compares local VERSION file with GitHub's VERSION file
2. **Create Backup** - Creates backup of current skill files (tar.gz)
3. **Stop Container** - Stops SearXNG Docker container if running
4. **Download** - Pulls latest version from GitHub
5. **Preserve Config** - Keeps your custom configuration and data
6. **Install** - Updates skill files
7. **Restart** - Restarts SearXNG container automatically

### What Gets Updated
- ✅ Scripts (auto-update.sh, docker-manager.sh, search.py)
- ✅ Documentation (README.md, USAGE.md, etc.)
- ✅ Skill metadata (SKILL.md)
- ✅ API references

### What's Preserved (Never Changed)
- 🔒 `docker/settings.yml` - Your SearXNG configuration
- 🔒 `docker/secret_key` - Your secret key
- 🔒 `backups/` - Your backup history
- 🔒 `update.log` - Your update logs

---

## Features

- **Automatic** - Runs via cron on your schedule
- **Safe** - Creates backups before every update
- **Smart** - Preserves your custom configuration
- **Seamless** - Restarts container automatically
- **Logged** - All actions logged to `update.log`
- **Reversible** - Can restore from backups if needed

---

## User Notification (Optional)

### Option 1: macOS Notification
Add to `auto-update.sh` after successful update:
```bash
osascript -e 'display notification "Free Web Search skill updated to v'$NEW_VERSION'" with title "OpenClaw"'
```

### Option 2: Desktop Notification (Linux)
```bash
notify-send "OpenClaw" "Free Web Search skill updated to v$NEW_VERSION"
```

### Option 3: Slack/Discord Webhook
```bash
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"Free Web Search skill updated to v'$NEW_VERSION'"}' \
  YOUR_WEBHOOK_URL
```

---

## Configuration Options

### Auto-Update Frequency

| Schedule | Cron Expression |
|----------|----------------|
| Every hour | `0 * * * *` |
| Every 6 hours | `0 */6 * * *` |
| Daily | `0 0 * * *` |
| Weekly | `0 0 * * 0` |

### Skip Confirmation Prompt

For fully automatic updates without asking, edit `auto-update.sh`:

**Change this:**
```bash
read -p "Update available. Install now? [y/N]: " -n response
response=${response:-n}

if [[ "$response" =~ ^[Yy]$ ]]; then
    perform_update
```

**To this:**
```bash
# Always update without asking
perform_update
```

---

## Version File Format

The VERSION file uses semantic versioning:
```
MAJOR.MINOR.PATCH
```

Example progression:
```
0.1.0 - First stable release
0.1.1 - Bug fixes
0.2.0 - New features (backwards compatible)
1.0.0 - Major release (possible breaking changes)
```

---

## Update Workflow

```
┌─────────────┐
│  Cron Job   │
│ (Scheduled) │
└──────┬──────┘
       │
       v
┌──────────────────┐
│  Check GitHub    │
│  for updates     │
└──────┬───────────┘
       │
       v
  ┌────────────────┐
  │ New version?   │
  └────┬─────┬─────┘
    No │     │ Yes
       │     │
       v     v
    Done   ┌─────────────┐
           │   Backup    │
           │   current   │
           └──────┬──────┘
                  │
                  v
           ┌─────────────┐
           │   Download  │
           │   from GH   │
           └──────┬──────┘
                  │
                  v
           ┌─────────────┐
           │  Preserve   │
           │   config    │
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
           │  Restart    │
           │  container  │
           └──────┬──────┘
                  │
                  v
             ✅ Done
```

---

## Troubleshooting

### "Permission denied"
```bash
chmod +x scripts/auto-update.sh
```

### "Command not found"
```bash
# Ensure bash path is correct
which bash
# Should output: /bin/bash or /usr/bin/bash
```

### "Git clone failed"
```bash
# Check internet connection
ping github.com

# Check repository URL is accessible
curl -I https://github.com/vksco/free-web-search
```

### "Container won't restart"
```bash
# Check container logs
docker logs searxng-openclaw

# Manually start
bash scripts/docker-manager.sh start
```

### Restore from Backup
```bash
# List backups
ls -la backups/

# Restore from backup (replace with your backup filename)
tar -xzf backups/skill_TIMESTAMP.tar.gz -C /path/to/free-web-search/
```

---

## Testing Updates

### Manual Update Check
```bash
# Run update script manually
bash scripts/auto-update.sh
```

### Check Update Logs
```bash
# View recent updates
tail -20 update.log

# Follow live updates
tail -f update.log
```

### View Current Version
```bash
cat VERSION
```

---

## Backup System

### How Backups Work
- Created automatically before every update
- Stored in `backups/` directory
- Named with timestamp: `skill_YYYYMMDD_HHMMSS.tar.gz`
- Last 5 backups retained (older ones auto-deleted)

### Manual Backup
```bash
# Create backup manually
tar -czf backups/manual_backup_$(date +%Y%m%d_%H%M%S).tar.gz \
  --exclude='backups' \
  --exclude='*.log' \
  .
```

### List Backups
```bash
ls -lh backups/
```

---

## Security Considerations

- **HTTPS Only** - Downloads only from HTTPS GitHub URLs
- **Version Verification** - Validates VERSION file format
- **Backup Retention** - Keeps last 5 backups
- **Config Preservation** - Never overwrites user configuration
- **Log Security** - Logs don't contain sensitive data
- **No Remote Execution** - Only updates files, doesn't run remote code

---

## Disable or Remove

### Disable Auto-Update
```bash
# Rename script to prevent execution
mv scripts/auto-update.sh scripts/auto-update.sh.disabled
```

### Remove Cron Job
```bash
crontab -e
# Delete the line containing auto-update.sh
```

### Completely Remove Auto-Update
```bash
# Remove cron job
crontab -e  # Delete auto-update line

# Remove script (optional)
rm scripts/auto-update.sh

# Keep backups and logs if you want history
```

---

## Summary

✅ **Automatic** - Checks for updates on your schedule via cron  
✅ **Safe** - Creates backups before updating  
✅ **Smart** - Preserves custom configuration  
✅ **Seamless** - Restarts container automatically  
✅ **Logged** - All actions logged to `update.log`  
✅ **Reversible** - Can restore from backups  

---

## Quick Start Checklist

- [ ] Make script executable: `chmod +x scripts/auto-update.sh`
- [ ] Test manually: `bash scripts/auto-update.sh`
- [ ] Add to crontab: `crontab -e`
- [ ] Verify cron job: `crontab -l`
- [ ] Check logs: `tail -f update.log`

---

**Need help?** Check `update.log` or open an issue:  
https://github.com/vksco/free-web-search/issues
