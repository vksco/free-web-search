---
name: free-web-search
description: Unlimited free web search for AI agents powered by SearXNG (https://github.com/searxng/searxng). Self-hosted metasearch engine with no API keys, rate limits, or monthly fees. Aggregates 70+ search engines (Google, Bing, DuckDuckGo, GitHub, Stack Overflow, etc.) Use when: (1) searching the web, (2) looking up information online, (3) researching topics, (4) finding current news, (5) searching for code, (6) any web search needed. Privacy-focused alternative to Tavily, SerpAPI, Google Custom Search.
---

# Free Web Search for AI Agents

Powered by [SearXNG](https://github.com/searxng/searxng) - Privacy-respecting, hackable metasearch engine.

## Quick Start

### One-Prompt Installation

Give this prompt to your AI agent (Claude, ChatGPT, Codex, Cursor, OpenCode, Pi, Gemini):

```
Install the free-web-search skill from https://github.com/vksco/free-web-search

Requirements:
- Ensure Docker is installed and running
- Clone the repo to ~/.openclaw/workspace/skills/free-web-search
- Make all scripts executable (Linux/macOS only)
- Start the SearXNG container
- Test with a simple search query

After installation, confirm it's working by searching for "AI agents" and showing me 3 results.
```

### Manual Installation

**Linux/macOS:**
```bash
# Clone repository
git clone https://github.com/vksco/free-web-search.git ~/.openclaw/workspace/skills/free-web-search
cd ~/.openclaw/workspace/skills/free-web-search

# Make scripts executable
chmod +x scripts/*.sh

# Start SearXNG
bash scripts/docker-manager.sh start

# Wait for container (10-20 seconds)
sleep 20

# Test search
curl 'http://localhost:8888/search?q=test&format=json'
```

**Windows:**
```cmd
# Clone repository
git clone https://github.com/vksco/free-web-search.git %USERPROFILE%\.openclaw\workspace\skills\free-web-search
cd %USERPROFILE%\.openclaw\workspace\skills\free-web-search

# Start SearXNG
scripts\docker-manager.bat start

# Wait for container (10-20 seconds)
timeout /t 20

# Test search (use PowerShell)
curl http://localhost:8888/search?q=test&format=json
```

## Cross-Platform Support

This skill works on all major operating systems:

- ✅ **Linux** - Bash scripts (.sh)
- ✅ **macOS** - Bash scripts (.sh)
- ✅ **Windows 10/11** - Batch scripts (.bat)

### Available Scripts

**Linux/macOS (scripts/):**
- `docker-manager.sh` - Manage SearXNG container
- `auto-update.sh` - Automatic updates
- `search.py` - Python search wrapper
- `integrate_with_openclaw.py` - Integration helper

**Windows (scripts/):**
- `docker-manager.bat` - Manage SearXNG container
- `auto-update.bat` - Automatic updates

## Auto-Update System

The skill automatically checks and installs updates when it loads (no cron jobs needed):

### How It Works:
1. **Skill loads** → Runs auto-update check
2. **Version check** → Compares local VERSION with GitHub
3. **Smart throttling** → Only checks once per hour
4. **Download** → If update available, downloads to temp folder
5. **Backup** → Creates backup of current version
6. **Install** → Replaces files, preserves your config
7. **Cleanup** → Removes temp folder
8. **Done** → Update complete!

### Manual Update Check:
```bash
# Linux/macOS
bash scripts/auto-update.sh

# Windows
scripts\auto-update.bat
```

### What's Preserved During Updates:
- ✅ `docker/settings.yml` - Your SearXNG configuration
- ✅ `docker/secret_key` - Your secret key
- ✅ `backups/` - Your backup history
- ✅ `update.log` - Your update logs

## How to Use

### Basic Search
```bash
# Basic search
curl 'http://localhost:8888/search?q=AI%20agents&format=json'

# Search specific engines
curl 'http://localhost:8888/search?q=python%20async&format=json&engines=github,stackoverflow'

# News search
curl 'http://localhost:8888/search?q=breaking%20news&format=json&categories=news'
```

### Python Integration
```python
import requests

# Unlimited free searches
response = requests.get(
    'http://localhost:8888/search',
    params={
        'q': 'AI agent frameworks',
        'format': 'json',
        'engines': 'google,github'
    }
)

results = response.json()['results']
for r in results:
    print(f"{r['title']}: {r['url']}")
```

## Features

- ✅ **Unlimited searches** - No rate limits or quotas
- ✅ **No API keys** - Completely free forever
- ✅ **70+ search engines** - Google, Bing, DuckDuckGo, GitHub, Stack Overflow, Reddit, YouTube, Wikipedia, and more
- ✅ **Auto-updates** - Automatically checks and installs updates
- ✅ **Cross-platform** - Linux, macOS, Windows
- ✅ **Privacy-focused** - Self-hosted, no tracking, no profiling
- ✅ **Docker-based** - Easy 2-minute installation
- ✅ **JSON API** - Simple REST API for any application
- ✅ **Python support** - Built-in search function
- ✅ **Production-ready** - Fully tested and documented

## Search Engines Available

### General Search
- **google** - Google Search
- **bing** - Microsoft Bing
- **duckduckgo** - DuckDuckGo (privacy-focused)
- **yahoo** - Yahoo Search
- **qwant** - Qwant (European, privacy-focused)

### Code & Development
- **github** - GitHub repositories
- **stackoverflow** - Stack Overflow Q&A
- **gitlab** - GitLab projects
- **bitbucket** - Bitbucket repos

### Q&A Forums
- **reddit** - Reddit discussions
- **askubuntu** - Ask Ubuntu
- **superuser** - Super User

### Media
- **youtube** - YouTube videos
- **vimeo** - Vimeo videos
- **dailymotion** - Dailymotion

### Reference
- **wikipedia** - Wikipedia articles
- **wikidata** - Wikidata knowledge base

### News
- **google news** - Google News
- **bing news** - Bing News

## Management Commands

**Linux/macOS:**
```bash
bash scripts/docker-manager.sh status    # Check status
bash scripts/docker-manager.sh logs      # View logs
bash scripts/docker-manager.sh restart   # Restart container
bash scripts/docker-manager.sh stop      # Stop container
```

**Windows:**
```cmd
scripts\docker-manager.bat status        # Check status
scripts\docker-manager.bat logs          # View logs
scripts\docker-manager.bat restart       # Restart container
scripts\docker-manager.bat stop          # Stop container
```

## Configuration

### Environment Variables (Optional)
```bash
# Optional: Fallback to Tavily if SearXNG is down
export TAVILY_API_KEY="tvly-your-key-here"
```

### SearXNG Settings
Configuration file: `docker/settings.yml`

Customize:
- Enabled search engines
- Request timeouts
- Result formats
- Safe search settings

## Cost Savings

| Service | Annual Cost | Your Cost |
|---------|-------------|-----------|
| **This skill** | **Free forever** | **$0** ✅ |
| Tavily | $120/year | **Save $120** |
| SerpAPI | $600/year | **Save $600** |
| Google Custom Search | $1500+/year | **Save $1500** |

## Troubleshooting

### Container won't start
```bash
# Check Docker is running
docker info

# Check port 8888
lsof -i :8888  # Linux/macOS
netstat -ano | findstr :8888  # Windows

# View container logs
docker logs searxng-openclaw
```

### No search results
```bash
# Try different engines
curl 'http://localhost:8888/search?q=test&format=json&engines=google'

# Check if engines are blocked
docker logs searxng-openclaw 2>&1 | grep -i "error"
```

### Update failed
```bash
# View update logs
cat update.log  # Linux/macOS
type update.log  # Windows

# Restore from backup
tar -xzf backups/skill_TIMESTAMP.tar.gz -C ~/.openclaw/workspace/skills/free-web-search/
```

## Requirements

- **Docker Desktop** - Installed and running
- **2GB RAM** - Available for container
- **Port 8888** - Available
- **Git** - For installation and updates

## Credits & Attribution

This skill is powered by:

- **[SearXNG](https://github.com/searxng/searxng)** - The privacy-respecting, hackable metasearch engine that provides all search functionality. **Please star SearXNG on GitHub!** ⭐
- **OpenClaw** - AI assistant framework
- **Docker** - Containerization platform

**This is a skill/wrapper that integrates SearXNG with OpenClaw. All search functionality comes from the SearXNG project under AGPL-3.0.**

## Support

- **GitHub Issues**: https://github.com/vksco/free-web-search/issues
- **SearXNG Docs**: https://docs.searxng.org/
- **OpenClaw Discord**: https://discord.com/invite/clawd

## License

This skill (wrapper/integration code) is MIT licensed.

**Important:** The search functionality is provided by [SearXNG](https://github.com/searxng/searxng) under AGPL-3.0 license.

---

**Made with ❤️ for the AI community**

**Star ⭐ on GitHub if you find it useful!**

https://github.com/vksco/free-web-search
