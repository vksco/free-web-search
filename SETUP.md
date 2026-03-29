# SearXNG Setup Guide for OpenClaw

Complete setup instructions for self-hosted SearXNG search engine.

## Prerequisites

- Docker Desktop or Docker Engine installed
- Docker running and accessible
- 2GB RAM available (minimum 512MB)
- Port 8888 available

## Quick Start

### 1. Install the Skill

The skill is already installed at:
```
/Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/
```

### 2. Start SearXNG

```bash
bash /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/docker-manager.sh start
```

This will:
- Pull the SearXNG Docker image
- Create container with proper configuration
- Start on http://localhost:8888
- Enable JSON API format

### 3. Verify Installation

```bash
# Test search
curl 'http://localhost:8888/search?q=test&format=json'

# Or using the Python script
python /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/search.py "hello world" 5
```

### 4. Configure Tavily (Fallback)

Get your Tavily API key from https://tavily.com/

```bash
# Add to your shell profile
echo 'export TAVILY_API_KEY="tvly-your-key-here"' >> ~/.zshrc
source ~/.zshrc
```

## Detailed Setup

### Docker Configuration

The container is configured with:

**Resource Limits:**
- Memory: 2GB
- CPU: 1.0 cores
- Restart policy: unless-stopped

**Networking:**
- Port: 8888
- Bind: 0.0.0.0 (accessible from localhost only)

**Volume Mounts:**
- `docker/settings.yml` → `/usr/local/searxng/searx/settings.yml`

### Configuration File

Located at: `docker/settings.yml`

**Key Settings:**

```yaml
search:
  formats:
    - json  # ← REQUIRED for API access

server:
  limiter: false  # ← No rate limiting

engines:
  - name: google
  - name: duckduckgo
  - name: bing
  - name: github
  - name: stackoverflow
```

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `SEARXNG_URL` | http://localhost:8888 | SearXNG instance URL |
| `TAVILY_API_KEY` | (required for fallback) | Tavily API key |

## Usage

### Python API

```python
from skills.searxng-integration.scripts.search import search_web

# Basic search
results = search_web("AI agents 2024", count=10)

# With specific engines
results = search_web(
    "python async",
    engines="google,stackoverflow"
)

# With categories
results = search_web(
    "machine learning",
    categories="images"
)
```

### Direct HTTP API

```python
import requests

response = requests.get(
    "http://localhost:8888/search",
    params={
        "q": "search query",
        "format": "json",
        "engines": "google,duckduckgo"
    }
)
results = response.json()["results"]
```

### CLI

```bash
# Search from command line
python scripts/search.py "docker compose" 10
```

## Management

### Start Container

```bash
bash scripts/docker-manager.sh start
```

### Stop Container

```bash
bash scripts/docker-manager.sh stop
```

### Restart Container

```bash
bash scripts/docker-manager.sh restart
```

### Check Status

```bash
bash scripts/docker-manager.sh status
# Output: "running" or "stopped"
```

### View Logs

```bash
bash scripts/docker-manager.sh logs
# Or directly:
docker logs -f searxng-openclaw
```

### Remove Container

```bash
bash scripts/docker-manager.sh remove
```

## Integration with OpenClaw

### Automatic Usage

The skill integrates automatically with OpenClaw's web search:

1. Agent receives web search request
2. Skill triggers automatically
3. Uses SearXNG by default
4. Falls back to Tavily if needed

### Skill Triggers

The skill activates when:
- User asks to "search the web"
- User requests information from online sources
- User wants current/recent information
- Research task requires web data

### Integration Example

```python
# In your OpenClaw workflow
def research_topic(topic: str):
    """Research a topic using web search"""
    
    # Import search function
    from skills.searxng-integration.scripts.search import search_web
    
    # Perform search
    results = search_web(f"{topic} latest research 2024")
    
    # Process results
    for result in results:
        print(f"Title: {result['title']}")
        print(f"URL: {result['url']}")
        print(f"Source: {result['source']}")
    
    return results
```

## Monitoring

### Container Health

```bash
# Check if container is running
docker ps | grep searxng

# Resource usage
docker stats searxng-openclaw

# Health check
curl -s http://localhost:8888/healthz
```

### Search Logs

All searches are logged in Python script:
```
[INFO] SearXNG: Found 10 results for 'query'
[INFO] Search completed: 'query' → 10 results via searxng
```

### Performance Metrics

Monitor these metrics:
- Response time (should be <3s)
- Memory usage (typically 300-600MB)
- CPU usage (spikes during search)
- Result count (should be ~20 per page)

## Troubleshooting

### Container Won't Start

**Check port availability:**
```bash
lsof -i :8888
```

**Check Docker:**
```bash
docker ps
docker info
```

**View logs:**
```bash
docker logs searxng-openclaw
```

### JSON Format Not Working

**Error:** 403 Forbidden when using `format=json`

**Fix:**
1. Check `docker/settings.yml` has `formats: [json]`
2. Restart container: `bash scripts/docker-manager.sh restart`
3. Verify: `curl http://localhost:8888/search?q=test&format=json`

### Slow Searches

**Causes:**
- Too many engines
- Network latency
- Resource limits

**Solutions:**
- Use specific engines: `engines=google,duckduckgo`
- Increase timeout in search.py
- Adjust Docker memory limits

### No Results

**Causes:**
- Engines blocked
- Invalid query syntax
- Network issues

**Solutions:**
- Check Docker logs
- Try different engines
- Test with simple query

### Tavily Fallback Not Working

**Check API key:**
```bash
echo $TAVILY_API_KEY
```

**Test Tavily directly:**
```python
import requests
response = requests.post(
    "https://api.tavily.com/search",
    json={
        "api_key": "tvly-your-key",
        "query": "test"
    }
)
print(response.status_code)
```

## Advanced Configuration

### Custom Engines

Edit `docker/settings.yml`:

```yaml
engines:
  - name: my_custom_engine
    engine: json_engine
    search_url: https://api.example.com/search?q={query}
    url_query: url
    title_query: title
    content_query: description
```

### Add Redis Caching

```bash
# Start Redis
docker run -d --name searxng-redis redis:alpine

# Update settings.yml
redis:
  url: redis://searxng-redis:6379/0
```

### Enable Metrics

In `docker/settings.yml`:

```yaml
general:
  enable_metrics: true

server:
  bind_address: "0.0.0.0"
```

Access metrics at: `http://localhost:8888/metrics`

### HTTPS Setup

For production use:

1. Use reverse proxy (nginx/traefik)
2. Configure SSL certificates
3. Update `SEARXNG_BASE_URL`

## Updates

### Update SearXNG Image

```bash
# Pull latest image
docker pull searxng/searxng:latest

# Recreate container
bash scripts/docker-manager.sh remove
bash scripts/docker-manager.sh start
```

### Update Skill

```bash
cd /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration
git pull  # If using git
```

## Security Considerations

### Local Only

By default, SearXNG is accessible only from localhost:
- Binds to 0.0.0.0:8888
- No external access without port forwarding

### Rate Limiting

Rate limiting is **disabled** for unlimited API access.

**To enable (not recommended for self-hosted):**
```yaml
server:
  limiter: true
```

### Secret Key

Auto-generated secret key stored in:
```
docker/secret_key
```

**Regenerate:**
```bash
openssl rand -hex 32 > docker/secret_key
bash scripts/docker-manager.sh restart
```

### API Key Protection

Tavily API key should be:
- Stored in environment variable
- Never committed to git
- Rotated periodically

## Performance Tuning

### Resource Allocation

Adjust in `scripts/docker-manager.sh`:

```bash
--memory="4g" \        # Increase memory
--memory-swap="4g" \
--cpus="2.0" \         # Increase CPU
```

### Connection Pool

In `docker/settings.yml`:

```yaml
outgoing:
  pool_connections: 200    # Increase pool
  pool_maxsize: 50
  request_timeout: 10.0
```

### Engine Selection

Use fewer engines for faster results:

```python
# Fast: 2-3 engines
engines = "google,duckduckgo"

# Slow: all engines
engines = None  # Default: all
```

## Backup & Restore

### Backup Configuration

```bash
# Backup settings
cp docker/settings.yml docker/settings.yml.backup
cp docker/secret_key docker/secret_key.backup
```

### Restore Configuration

```bash
cp docker/settings.yml.backup docker/settings.yml
cp docker/secret_key.backup docker/secret_key
bash scripts/docker-manager.sh restart
```

## Uninstall

```bash
# Stop and remove container
bash scripts/docker-manager.sh remove

# Remove image
docker rmi searxng/searxng:latest

# Remove skill (optional)
rm -rf /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration
```

## Support

- **SearXNG Docs**: https://docs.searxng.org/
- **Docker Hub**: https://hub.docker.com/r/searxng/searxng
- **Community**: https://github.com/searxng/searxng/issues
- **OpenClaw Docs**: /Users/vikashsharma/.nvm/versions/node/v24.14.1/lib/node_modules/openclaw/docs

## Checklist

- [ ] Docker installed and running
- [ ] Port 8888 available
- [ ] Container started successfully
- [ ] JSON search works: `curl http://localhost:8888/search?q=test&format=json`
- [ ] Tavily API key configured (optional)
- [ ] Python search script works
- [ ] Fallback tested (stop container, verify Tavily works)
