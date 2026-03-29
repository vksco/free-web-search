# How Auto-Update Works - Free Web Search Skill

## 🔄 Update System Overview

The auto-update system automatically checks GitHub for new versions and updates your skill seamlessly.

---

## 📋 How It Works

### 1. Version Checking
**Every hour** (via cron job), the script:

```bash
# Reads your local version
cat ~/.openclaw/workspace/skills/free-web-search/VERSION
# Example: 0.1.0

# Checks GitHub for latest version
curl https://raw.githubusercontent.com/vksco/free-web-search/main/VERSION
# Example: 0.2.0

# Compares versions
if [ "$LOCAL_VERSION" != "$REMOTE_VERSION" ]; then
    echo "Update available!"
fi
```

### 2. Update Process
When an update is found:

#### Step 1: Create Backup
```bash
# Backs up entire skill directory
tar -czf backup_20260329_223100.tar.gz \
    ~/.openclaw/workspace/skills/free-web-search/
```

#### Step 2: Stop Container
```bash
# Stops SearXNG if running
docker stop searxng-openclaw
```

#### Step 3: Download Update
```bash
# Downloads latest version from GitHub
git clone --depth 1 \
    https://github.com/vksco/free-web-search.git \
    free-web-search-temp
```

#### Step 4: Preserve Your Config
```bash
# Keeps your custom files
preserve:
  - docker/settings.yml     # Your SearXNG config
  - docker/secret_key       # Your secret key
  - backups/                # Your backup history
  - update.log              # Your update logs
```

#### Step 5: Install Update
```bash
# Removes old files (except preserved)
rm -rf free-web-search/

# Moves new files into place
mv free-web-search-temp/ free-web-search/

# Restores your preserved config
cp -r /tmp/preserved/* free-web-search/
```

#### Step 6: Restart Container
```bash
# Restarts SearXNG with new code
bash scripts/docker-manager.sh start
```

#### Step 7: Log Update
```bash
# Logs to update.log
echo "✅ Updated to v0.2.0" >> update.log
```

---

## ⏰ Scheduling Options

### Option 1: Every Hour (Default)
```bash
# Runs at minute 0 of every hour
0 * * * * /bin/bash ~/.openclaw/workspace/skills/free-web-search/scripts/auto-update.sh
```

### Option 2: Every 6 Hours
```bash
# Runs at 00:00, 06:00, 12:00, 18:00
0 */6 * * * /bin/bash ~/.openclaw/workspace/skills/free-web-search/scripts/auto-update.sh
```

### Option 3: Once Daily
```bash
# Runs at 2:00 AM every day
0 2 * * * /bin/bash ~/.openclaw/workspace/skills/free-web-search/scripts/auto-update.sh
```

### Option 4: Manual Only
```bash
# No cron job - check manually when you want
bash scripts/auto-update.sh
```

---

## 🔧 Setup Instructions

### Step 1: Open Crontab
```bash
crontab -e
```

### Step 2: Add Cron Job
```bash
# Add this line (choose your schedule)
0 * * * * /bin/bash /Users/YOUR_USERNAME/.openclaw/workspace/skills/free-web-search/scripts/auto-update.sh
```

### Step 3: Save and Exit
- **Vim**: Press `Esc`, type `:wq`, press `Enter`
- **Nano**: Press `Ctrl+O`, `Enter`, `Ctrl+X`

### Step 4: Verify
```bash
crontab -l
```

---

## 📊 What Gets Updated

### ✅ Updated Files
- Scripts (docker-manager.sh, auto-update.sh, search.py)
- Documentation (README.md, USAGE.md, etc.)
- Skill metadata (SKILL.md)
- Docker config templates
- API references

### 🔒 Preserved Files (Never Changed)
- `docker/settings.yml` - Your custom SearXNG config
- `docker/secret_key` - Your secret key
- `backups/` - Your backup history
- `update.log` - Your update logs

---

## 🛡️ Safety Features

### 1. Automatic Backups
- Creates full backup before every update
- Stored in `backups/` directory
- Timestamped: `skill_20260329_223100.tar.gz`

### 2. Rollback Capability
If update fails:
```bash
# Restore from backup
cd ~/.openclaw/workspace/skills/free-web-search
tar -xzf backups/skill_20260329_223100.tar.gz
```

### 3. Container Management
- Stops container before update
- Restarts automatically after update
- Preserves running state

### 4. Config Preservation
- Your custom settings never overwritten
- Secret key preserved
- Personal modifications kept

### 5. Detailed Logging
All actions logged to `update.log`:
```bash
tail -f ~/.openclaw/workspace/skills/free-web-search/update.log
```

---

## 🧪 Testing Updates

### Manual Update Check
```bash
cd ~/.openclaw/workspace/skills/free-web-search
bash scripts/auto-update.sh
```

### Check Logs
```bash
# View recent updates
tail -20 update.log

# Follow live updates
tail -f update.log
```

### Simulate Update (Dry Run)
```bash
# Check if update available without installing
curl https://raw.githubusercontent.com/vksco/free-web-search/main/VERSION
cat VERSION
# Compare manually
```

---

## 📱 Notifications (Optional)

### macOS Notifications
Add to `auto-update.sh` after successful update:
```bash
osascript -e 'display notification "SearXNG skill updated to v'$REMOTE_VERSION'" with title "OpenClaw"'
```

### Email Notifications
```bash
echo "SearXNG updated to v$REMOTE_VERSION" | mail -s "OpenClaw Update" your@email.com
```

### Slack Notifications
```bash
curl -X POST -H 'Content-type: application/json' \
    --data '{"text":"SearXNG skill updated to v'$REMOTE_VERSION'"}' \
    YOUR_SLACK_WEBHOOK_URL
```

---

## ❓ FAQ

### Q: Will I lose my configuration?
**A:** No! Your `docker/settings.yml` and custom files are preserved.

### Q: What if the update fails?
**A:** The script automatically restores from backup.

### Q: Can I disable auto-update?
**A:** Yes, just remove the cron job: `crontab -e` and delete the line.

### Q: How do I know if an update installed?
**A:** Check `update.log` or run: `cat VERSION`

### Q: Can I update manually?
**A:** Yes: `bash scripts/auto-update.sh`

### Q: What's backed up?
**A:** Complete skill directory (except excluded files like logs).

---

## 🔍 Monitoring

### Check Update Status
```bash
# View current version
cat ~/.openclaw/workspace/skills/free-web-search/VERSION

# Check when last updated
ls -lt ~/.openclaw/workspace/skills/free-web-search/backups/

# View update history
cat ~/.openclaw/workspace/skills/free-web-search/update.log | grep "Updated to"
```

### Check Cron is Running
```bash
# List cron jobs
crontab -l

# Check cron logs (macOS)
log show --predicate 'process == "cron"' --last 1h

# Check cron logs (Linux)
grep CRON /var/log/syslog
```

---

## 🎯 Best Practices

1. **Keep cron job running** - Ensures you get security updates
2. **Check logs periodically** - Ensure updates are working
3. **Don't modify core files** - Your changes may be overwritten
4. **Use backups** - If something breaks, restore from backup
5. **Test manually first** - Before enabling auto-update

---

## 📝 Example Update Log

```
[2026-03-29 22:00:00] [INFO] === SearXNG Skill Update Checker ===
[2026-03-29 22:00:00] [INFO] Running at: Sun Mar 29 22:00:00 IST 2026
[2026-03-29 22:00:00] [INFO] Checking for updates...
[2026-03-29 22:00:00] [INFO] Local version: 0.1.0
[2026-03-29 22:00:01] [INFO] Remote version: 0.2.0
[2026-03-29 22:00:01] [INFO] Update available: v0.1.0 → v0.2.0
[2026-03-29 22:00:05] [INFO] Creating backup before update...
[2026-03-29 22:00:06] [INFO] Backup created
[2026-03-29 22:00:06] [INFO] Stopping SearXNG container for update...
[2026-03-29 22:00:10] [INFO] Downloading update from GitHub...
[2026-03-29 22:00:45] [INFO] Update installed successfully
[2026-03-29 22:00:45] [INFO] Restarting SearXNG container...
[2026-03-29 22:01:00] [INFO] ✅ Update complete! SearXNG skill updated to v0.2.0
```

---

## 🚀 Summary

**Auto-update ensures you always have:**
- ✅ Latest features
- ✅ Security patches
- ✅ Bug fixes
- ✅ Performance improvements

**All automatically, safely, and without losing your custom configuration!**

---

**Need help?** Check `update.log` or open an issue:
https://github.com/vksco/free-web-search/issues
