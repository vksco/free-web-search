# Auto-Update System - Free Web Search Skill

## Overview

The skill automatically checks and installs updates from GitHub when it loads. No cron jobs or manual intervention required.

---

## How It Works

### Automatic Update Process

When the skill loads (every time you use it):

```
1. Skill loads → Runs auto-update.sh
                ↓
2. Check: Has it been 1 hour since last check?
                ↓
          No → Skip (too soon)
          Yes → Continue
                ↓
3. Get local VERSION file
   Example: 0.1.0
                ↓
4. Get remote VERSION from GitHub
   https://raw.githubusercontent.com/vksco/free-web-search/main/VERSION
   Example: 0.2.0
                ↓
5. Compare versions
                ↓
          Same → No update, exit
          Different → Update available!
                ↓
6. Create backup
   backups/skill_20260329_220000.tar.gz
                ↓
7. Download new version to /tmp
                ↓
8. Preserve your config
   - docker/settings.yml
   - docker/secret_key
                ↓
9. Copy new files to skill directory
                ↓
10. Clean up temp folder
                ↓
11. Log update to update.log
                ↓
12. Done! Update installed ✅
```

---

## Key Features

### ✅ Automatic
- Runs every time the skill loads
- No cron jobs required
- No user intervention needed

### ✅ Smart Throttling
- Only checks once per hour (configurable)
- Prevents excessive GitHub API calls
- Uses `.last_update_check` timestamp file

### ✅ Safe Updates
- Creates backup before every update
- Preserves your configuration files
- Can restore from backup if needed

### ✅ Seamless
- Updates download in background
- No service interruption
- Update applies on next skill load

### ✅ Config Preservation
These files are **never overwritten**:
- `docker/settings.yml` - Your SearXNG config
- `docker/secret_key` - Your secret key
- `backups/` - Your backup history
- `update.log` - Your update logs

---

## Update Frequency

### Default: Once Per Hour

The skill checks for updates **once per hour** when loaded.

To change this, edit `scripts/auto-update.sh`:

```bash
# Change CHECK_INTERVAL (in seconds)
local CHECK_INTERVAL=3600  # 1 hour

# Examples:
local CHECK_INTERVAL=1800   # 30 minutes
local CHECK_INTERVAL=7200   # 2 hours
local CHECK_INTERVAL=86400  # 24 hours
local CHECK_INTERVAL=0      # Always check (not recommended)
```

---

## Manual Update Check

To manually check and install updates:

```bash
cd ~/.openclaw/workspace/skills/free-web-search
bash scripts/auto-update.sh
```

---

## What Gets Updated

### ✅ Updated Automatically
- `scripts/` - All scripts (auto-update.sh, docker-manager.sh, search.py)
- `SKILL.md` - Skill documentation
- `README.md` - Main documentation
- `USAGE.md` - Usage examples
- `references/` - API references
- `VERSION` - Version number

### 🔒 Never Changed
- `docker/settings.yml` - Your custom SearXNG configuration
- `docker/secret_key` - Your secret key
- `backups/` - Your backup history
- `update.log` - Your update logs
- `.last_update_check` - Last check timestamp

---

## Backup System

### Automatic Backups

Before every update, the skill creates a full backup:

```bash
backups/skill_YYYYMMDD_HHMMSS.tar.gz
```

Example:
```
backups/skill_20260329_220000.tar.gz
backups/skill_20260329_223000.tar.gz
backups/skill_20260330_100000.tar.gz
```

### Backup Retention

- Keeps **last 5 backups**
- Older backups automatically deleted
- Saves disk space

### Manual Backup

```bash
cd ~/.openclaw/workspace/skills/free-web-search
tar -czf backups/manual_backup_$(date +%Y%m%d_%H%M%S).tar.gz \
  --exclude='backups' \
  --exclude='*.log' \
  .
```

### Restore from Backup

```bash
cd ~/.openclaw/workspace/skills/free-web-search

# List backups
ls -lh backups/

# Restore (replace with your backup filename)
tar -xzf backups/skill_20260329_220000.tar.gz
```

---

## Update Log

All update actions are logged to `update.log`:

### View Update Log

```bash
# View recent updates
tail -20 update.log

# Follow live updates
tail -f update.log

# Search for updates
grep "Updated to" update.log
```

### Example Log Entry

```
[2026-03-29 22:00:15] [INFO] Update available: v0.1.0 → v0.2.0
[2026-03-29 22:00:15] [INFO] Creating backup before update...
[2026-03-29 22:00:16] [INFO] Backup created: /path/to/backups/skill_20260329_220016.tar.gz
[2026-03-29 22:00:16] [INFO] Downloading v0.2.0 from GitHub...
[2026-03-29 22:00:45] [INFO] Installing update...
[2026-03-29 22:00:47] [INFO] ✅ Updated to v0.2.0
```

---

## Configuration

### Skip Update Check

To disable auto-updates:

```bash
# Create a skip file
touch ~/.openclaw/workspace/skills/free-web-search/.skip_updates
```

Edit `scripts/auto-update.sh` to check for this file:

```bash
# Add after main() function starts
if [ -f "$SCRIPT_DIR/.skip_updates" ]; then
    log "INFO" "Updates skipped (.skip_updates found)"
    exit 0
fi
```

### Change Update Source

To use a different branch or fork:

Edit `scripts/auto-update.sh`:

```bash
# Change these lines:
REPO_URL="https://github.com/YOUR_USERNAME/free-web-search"
BRANCH="develop"  # or "main", "beta", etc.
```

---

## Troubleshooting

### "Update check failed"

**Cause**: No internet connection or GitHub is down

**Solution**:
```bash
# Test connection
ping github.com
curl -I https://github.com/vksco/free-web-search
```

### "Permission denied"

**Cause**: Script not executable

**Solution**:
```bash
chmod +x scripts/auto-update.sh
```

### "Backup failed"

**Cause**: Insufficient disk space or permissions

**Solution**:
```bash
# Check disk space
df -h

# Check permissions
ls -la backups/

# Create backup directory
mkdir -p backups
chmod 755 backups
```

### "Download failed"

**Cause**: Git not installed or repository inaccessible

**Solution**:
```bash
# Install git
# macOS: brew install git
# Linux: sudo apt install git

# Test clone
git clone https://github.com/vksco/free-web-search.git /tmp/test-clone
```

### Restore After Failed Update

```bash
# 1. Stop the skill (if container running)
bash scripts/docker-manager.sh stop

# 2. Restore from backup
cd ~/.openclaw/workspace/skills/free-web-search
tar -xzf backups/skill_TIMESTAMP.tar.gz

# 3. Restart the skill
bash scripts/docker-manager.sh start
```

---

## How to Disable Auto-Update

### Method 1: Skip File (Recommended)

```bash
touch ~/.openclaw/workspace/skills/free-web-search/.skip_updates
```

### Method 2: Rename Script

```bash
cd ~/.openclaw/workspace/skills/free-web-search
mv scripts/auto-update.sh scripts/auto-update.sh.disabled
```

### Method 3: Delete Script

```bash
rm scripts/auto-update.sh
```

---

## Testing Updates

### Test Update System

```bash
# 1. Check current version
cat VERSION

# 2. Force update check (ignore time throttling)
rm .last_update_check

# 3. Run update manually
bash scripts/auto-update.sh

# 4. Check logs
tail -20 update.log
```

### Simulate Version Change

```bash
# 1. Change local version to older
echo "0.0.1" > VERSION

# 2. Run update
bash scripts/auto-update.sh

# 3. Should detect v0.1.0 (or latest) and update
```

---

## Security

### Safe Update Process

1. ✅ **HTTPS Only** - Downloads only from GitHub over HTTPS
2. ✅ **Version Validation** - Checks VERSION format before updating
3. ✅ **Config Preservation** - Never overwrites user configuration
4. ✅ **Backup System** - Always creates backup before update
5. ✅ **No Remote Execution** - Only downloads files, doesn't execute remote code
6. ✅ **Log Security** - Logs don't contain sensitive data

---

## Version Format

The skill uses semantic versioning:

```
MAJOR.MINOR.PATCH
```

Examples:
- `0.1.0` - First stable release
- `0.1.1` - Bug fixes
- `0.2.0` - New features
- `1.0.0` - Major release

---

## Summary

✅ **Automatic** - Checks for updates when skill loads
✅ **Smart** - Only checks once per hour
✅ **Safe** - Creates backups before updating
✅ **Preserves** - Keeps your custom configuration
✅ **Seamless** - No user intervention required
✅ **Logged** - All actions logged to update.log
✅ **Reversible** - Can restore from backups

---

## Quick Reference

| Command | Action |
|---------|--------|
| `bash scripts/auto-update.sh` | Manually check for updates |
| `cat VERSION` | View current version |
| `tail -20 update.log` | View recent updates |
| `ls -lh backups/` | List backups |
| `tar -xzf backups/skill_*.tar.gz` | Restore from backup |

---

**Need help?** Check `update.log` or open an issue:
https://github.com/vksco/free-web-search/issues
