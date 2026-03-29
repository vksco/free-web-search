#!/bin/bash
# SearXNG Docker Manager - Universal (Linux/macOS)
# Works on all Unix-like systems with Docker

set -e

CONTAINER_NAME="searxng-openclaw"
IMAGE_NAME="searxng/searxng:latest"
PORT="8888"

# Colors (works on Linux and macOS)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

status() {
    if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        echo "running"
        return 0
    else
        echo "stopped"
        return 1
    fi
}

start() {
    if [ "$(status)" = "running" ]; then
        log_info "SearXNG container is already running"
        return 0
    fi
    
    log_info "Starting SearXNG container..."
    log_info "Detected OS: $(detect_os)"
    
    # Pull image if not exists
    if ! docker image inspect "$IMAGE_NAME" &> /dev/null; then
        log_info "Pulling SearXNG image..."
        docker pull "$IMAGE_NAME"
    fi
    
    # Check if stopped container exists
    if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        log_info "Starting existing container..."
        docker start "$CONTAINER_NAME"
    else
        log_info "Creating new container..."
        
        # Get script directory (works on both Linux and macOS)
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        DOCKER_DIR="$(dirname "$SCRIPT_DIR")/docker"
        
        # Run container with custom settings file
        docker run -d \
            --name "$CONTAINER_NAME" \
            -p "${PORT}:8080" \
            -e "SEARXNG_BASE_URL=http://localhost:${PORT}" \
            -e "INSTANCE_NAME=OpenClaw-Search" \
            -v "$DOCKER_DIR/settings.yml:/etc/searxng/settings.yml:ro" \
            --memory="2g" \
            --cpus="1.0" \
            --restart unless-stopped \
            "$IMAGE_NAME"
    fi
    
    # Wait for container
    log_info "Waiting for container to start..."
    sleep 10
    
    # Check if running
    if [ "$(status)" = "running" ]; then
        log_info "✓ SearXNG started on http://localhost:${PORT}"
        log_warn "Note: JSON API may require additional configuration"
        log_info "Testing web interface: curl http://localhost:${PORT}"
        return 0
    else
        log_error "SearXNG failed to start. Check logs: docker logs $CONTAINER_NAME"
        return 1
    fi
}

stop() {
    if [ "$(status)" != "running" ]; then
        log_info "SearXNG container is not running"
        return 0
    fi
    
    log_info "Stopping SearXNG container..."
    docker stop "$CONTAINER_NAME" > /dev/null
    log_info "✓ SearXNG stopped"
}

restart() {
    log_info "Restarting SearXNG container..."
    stop
    sleep 2
    start
}

logs() {
    docker logs -f "$CONTAINER_NAME"
}

remove() {
    stop
    log_info "Removing SearXNG container..."
    docker rm "$CONTAINER_NAME" > /dev/null 2>&1 || true
    log_info "✓ Container removed"
}

usage() {
    echo "SearXNG Docker Manager - Universal"
    echo ""
    echo "Usage: $0 {start|stop|restart|status|logs|remove}"
    echo ""
    echo "Container: $CONTAINER_NAME"
    echo "Image:     $IMAGE_NAME"
    echo "Port:      $PORT"
    echo "URL:       http://localhost:${PORT}"
    echo ""
    echo "Compatible with: Linux, macOS"
}

case "${1:-}" in
    start) start ;;
    stop) stop ;;
    restart) restart ;;
    status) status ;;
    logs) logs ;;
    remove) remove ;;
    *) usage; exit 1 ;;
esac
