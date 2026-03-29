#!/bin/bash
# Auto-Update Script for Free Web Search Skill
# Automatically checks and installs updates when the skill runs

set -e

# Get script directory (works on any system)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_NAME="free-web-search"
REPO_URL="https://github.com/vksco/free-web-search"
BRANCH="main"
LOCAL_VERSION_FILE="$SCRIPT_DIR/VERSION"
REMOTE_VERSION_URL="https://raw.githubusercontent.com/vksco/free-web-search/main/VERSION"
LOG_FILE="$SCRIPT_DIR/update.log"
TEMP_DIR="/tmp/free-web-search-update-$$"
BACKUP_DIR="$SCRIPT_DIR/backups"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging function
log() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Write to log file
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    
    # Only show INFO messages to stdout (for skill visibility)
    if [ "$level" = "INFO" ]; then
        echo -e "${GREEN}[UPDATE]${NC} $message" >&2
    fi
}

# Check if update is available
check_for_update() {
    # Check if VERSION file exists
    if [ ! -f "$LOCAL_VERSION_FILE" ]; then
        log "WARN" "VERSION file not found, assuming first run"
        echo "0.0.0" > "$LOCAL_VERSION_FILE"
    fi
    
    # Get local version
    local LOCAL_VERSION=$(cat "$LOCAL_VERSION_FILE" 2>/dev/null || echo "0.0.0")
    
    # Get remote version (with timeout)
    local REMOTE_VERSION=$(curl -s --max-time 5 "$REMOTE_VERSION_URL" 2>/dev/null)
    
    # Check if we got a valid response
    if [ -z "$REMOTE_VERSION" ] || [[ ! "$REMOTE_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        log "WARN" "Could not fetch remote version, skipping update check"
        return 1
    fi
    
    # Compare versions
    if [ "$LOCAL_VERSION" = "$REMOTE_VERSION" ]; then
        # No update available
        return 1
    fi
    
    # Update available!
    log "INFO" "Update available: v$LOCAL_VERSION → v$REMOTE_VERSION"
    echo "$REMOTE_VERSION"
    return 0
}

# Create backup before update
create_backup() {
    log "INFO" "Creating backup before update..."
    
    # Create backup directory if it doesn't exist
    mkdir -p "$BACKUP_DIR"
    
    # Create backup tarball
    local BACKUP_FILE="$BACKUP_DIR/skill_$(date +%Y%m%d_%H%M%S).tar.gz"
    tar -czf "$BACKUP_FILE" \
        -C "$SCRIPT_DIR" \
        --exclude="backups" \
        --exclude="*.log" \
        --exclude=".git" \
        . 2>/dev/null || true
    
    log "INFO" "Backup created: $BACKUP_FILE"
    
    # Keep only last 5 backups
    cd "$BACKUP_DIR"
    ls -t skill_*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm -f 2>/dev/null || true
    cd - > /dev/null
}

# Download and install update
install_update() {
    local NEW_VERSION=$1
    
    log "INFO" "Downloading v$NEW_VERSION from GitHub..."
    
    # Create temporary directory
    mkdir -p "$TEMP_DIR"
    
    # Clone repository to temp directory
    if ! git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TEMP_DIR" 2>/dev/null; then
        log "WARN" "Failed to download update"
        rm -rf "$TEMP_DIR"
        return 1
    fi
    
    log "INFO" "Installing update..."
    
    # Preserve important files before update
    local PRESERVE_DIR="/tmp/free-web-search-preserve-$$"
    mkdir -p "$PRESERVE_DIR"
    
    # Preserve user configuration
    if [ -f "$SCRIPT_DIR/docker/settings.yml" ]; then
        cp "$SCRIPT_DIR/docker/settings.yml" "$PRESERVE_DIR/" 2>/dev/null || true
    fi
    
    if [ -f "$SCRIPT_DIR/docker/secret_key" ]; then
        cp "$SCRIPT_DIR/docker/secret_key" "$PRESERVE_DIR/" 2>/dev/null || true
    fi
    
    # Copy new files (excluding preserved directories)
    rsync -a --exclude="backups" \
              --exclude="*.log" \
              --exclude=".git" \
              --exclude="docker/settings.yml" \
              --exclude="docker/secret_key" \
              "$TEMP_DIR/" "$SCRIPT_DIR/" 2>/dev/null || \
    cp -r "$TEMP_DIR/"* "$SCRIPT_DIR/" 2>/dev/null || true
    
    # Restore preserved files
    if [ -f "$PRESERVE_DIR/settings.yml" ]; then
        cp "$PRESERVE_DIR/settings.yml" "$SCRIPT_DIR/docker/" 2>/dev/null || true
    fi
    
    if [ -f "$PRESERVE_DIR/secret_key" ]; then
        cp "$PRESERVE_DIR/secret_key" "$SCRIPT_DIR/docker/" 2>/dev/null || true
    fi
    
    # Clean up
    rm -rf "$TEMP_DIR"
    rm -rf "$PRESERVE_DIR"
    
    log "INFO" "✅ Updated to v$NEW_VERSION"
    
    return 0
}

# Main function
main() {
    # Check if we should skip update (e.g., if last check was less than 1 hour ago)
    local LAST_CHECK_FILE="$SCRIPT_DIR/.last_update_check"
    local CHECK_INTERVAL=3600  # 1 hour in seconds
    
    if [ -f "$LAST_CHECK_FILE" ]; then
        local LAST_CHECK=$(cat "$LAST_CHECK_FILE" 2>/dev/null || echo "0")
        local CURRENT_TIME=$(date +%s)
        local ELAPSED=$((CURRENT_TIME - LAST_CHECK))
        
        if [ $ELAPSED -lt $CHECK_INTERVAL ]; then
            # Skip update check (checked recently)
            exit 0
        fi
    fi
    
    # Update last check time
    date +%s > "$LAST_CHECK_FILE"
    
    # Check for updates
    local NEW_VERSION=$(check_for_update)
    
    if [ $? -ne 0 ] || [ -z "$NEW_VERSION" ]; then
        # No update available or error occurred
        exit 0
    fi
    
    # Create backup before updating
    create_backup
    
    # Install the update
    if install_update "$NEW_VERSION"; then
        log "INFO" "Update complete! Restart skill to use v$NEW_VERSION"
        exit 0
    else
        log "WARN" "Update failed, continuing with current version"
        exit 1
    fi
}

# Run main
main
