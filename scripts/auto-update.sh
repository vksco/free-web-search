#!/bin/bash
# SearXNG Integration - Auto-Update Script
# Checks for updates every hour via cron

set -e

# Configuration
SKILL_NAME="searxng-integration"
REPO_URL="https://github.com/vksco/free-web-search"
BRANCH="main"
LOCAL_VERSION_FILE="/Users/vikashsharma/.openclaw/workspace/skills/$SKILL_NAME/VERSION"
REMOTE_VERSION_URL="https://raw.githubusercontent.com/vksco/free-web-search/$BRANCH/VERSION"
LOG_FILE="/Users/vikashsharma/.openclaw/workspace/skills/$SKILL_NAME/update.log"
BACKUP_DIR="/Users/vikashsharma/.openclaw/workspace/skills/$SKILL_NAME/backups"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging function
log() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    
    case $level in
        INFO)
            echo -e "${GREEN}[INFO]${NC} $message"
            ;;
        WARN)
            echo -e "${YELLOW}[WARN]${NC} $message"
            ;;
        ERROR)
            echo -e "${RED}[ERROR]${NC} $message"
            ;;
    esac
}

# Create backup
create_backup() {
    log "INFO" "Creating backup before update..."
    mkdir -p "$BACKUP_DIR"
    
    # Backup current version
    if [ -f "$LOCAL_VERSION_FILE" ]; then
        cp "$LOCAL_VERSION_FILE" "$BACKUP_DIR/VERSION.$(date +%Y%m%d_%H%M%S).bak"
        log "INFO" "Backup created"
    fi
    
    # Backup entire skill directory
    tar -czf "$BACKUP_DIR/skill_$(date +%Y%m%d_%H%M%S).tar.gz" \
        -C "/Users/vikashsharma/.openclaw/workspace/skills/$SKILL_NAME" \
        --exclude="backups" \
        .
    
    log "INFO" "Full skill backup created"
}

# Check for updates
check_for_updates() {
    log "INFO" "Checking for updates..."
    
    # Get local version
    if [ ! -f "$LOCAL_VERSION_FILE" ]; then
        log "WARN" "No local version file found. Assuming first installation."
        echo "0.0.0" > "$LOCAL_VERSION_FILE"
    fi
    
    local LOCAL_VERSION=$(cat "$LOCAL_VERSION_FILE")
    log "INFO" "Local version: $LOCAL_VERSION"
    
    # Get remote version
    local REMOTE_VERSION=$(curl -s "$REMOTE_VERSION_URL" 2>/dev/null)
    
    if [ $? -ne 0 ]; then
        log "ERROR" "Failed to check remote version"
        return 1
    fi
    
    log "INFO" "Remote version: $REMOTE_VERSION"
    
    # Compare versions
    if [ "$LOCAL_VERSION" = "$REMOTE_VERSION" ]; then
        log "INFO" "Skill is up to date (v$LOCAL_VERSION)"
        return 0
    fi
    
    log "INFO" "Update available: v$LOCAL_VERSION → v$REMOTE_VERSION"
    return 0
}

# Perform update
perform_update() {
    log "INFO" "Starting update process..."
    
    # Create backup first
    create_backup
    
    # Stop container if running
    if docker ps --format '{{.Names}}' | grep -q "searxng-openclaw"; then
        log "INFO" "Stopping SearXNG container for update..."
        bash "/Users/vikashsharma/.openclaw/workspace/skills/$SKILL_NAME/scripts/docker-manager.sh" stop
        CONTAINER_WAS_RUNNING=true
    fi
    
    # Download update
    log "INFO" "Downloading update from GitHub..."
    cd "/Users/vikashsharma/.openclaw/workspace/skills"
    
    # Remove old version (keep config and data)
    if [ -d "$SKILL_NAME" ]; then
        # Preserve important files
        mkdir -p /tmp/searxng-preserve
        cp -r "$SKILL_NAME/docker" /tmp/searxng-preserve/ 2>/dev/null || true
        cp -r "$SKILL_NAME/backups" /tmp/searxng-preserve/ 2>/dev/null || true
        
        # Remove old skill
        rm -rf "$SKILL_NAME"
    fi
    
    # Clone new version
    git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$SKILL_NAME-temp" 2>&1 | tee -a "$LOG_FILE"
    
    if [ $? -ne 0 ]; then
        log "ERROR" "Failed to download update"
        
        # Restore backup
        tar -xzf "$BACKUP_DIR/skill_*.tar.gz" -C /
        log "INFO" "Restored from backup"
        return 1
    fi
    
    # Move new files into place
    mv "$SKILL_NAME-temp" "$SKILL_NAME"
    
    # Restore preserved files
    if [ -d /tmp/searxng-preserve ]; then
        cp -r /tmp/searxng-preserve/* "$SKILL_NAME/" 2>/dev/null || true
        rm -rf /tmp/searxng-preserve
    fi
    
    # Update version file
    echo "$(cat /tmp/searxng-temp/VERSION)" > "$LOCAL_VERSION_FILE"
    
    log "INFO" "Update installed successfully"
    
    # Restart container if it was running
    if [ "$CONTAINER_WAS_RUNNING" = true ]; then
        log "INFO" "Restarting SearXNG container..."
        bash "/Users/vikashsharma/.openclaw/workspace/skills/$SKILL_NAME/scripts/docker-manager.sh" start
    fi
    
    # Notify user
    log "INFO" "✅ Update complete! SearXNG skill updated to v$(cat $LOCAL_VERSION_FILE)"
    
    # Send notification to user (optional - requires notification setup)
    # notify_user "SearXNG skill updated to v$(cat $LOCAL_VERSION_FILE)"
    
    return 0
}

# Main update check
main() {
    log "INFO" "=== SearXNG Skill Update Checker ==="
    log "INFO" "Running at: $(date)"
    
    # Check for updates
    if ! check_for_updates; then
        log "INFO" "No update needed"
        exit 0
    fi
    
    # Ask for confirmation (optional - can be skipped for auto-update)
    read -p "Update available. Install now? [y/N]: " -n response
    response=${response:-n}
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        perform_update
        exit $?
    else
        log "INFO" "Update deferred by user"
        exit 0
    fi
}

# Run main
main
