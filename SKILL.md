---
name: free-web-search
description: Unlimited free web search for AI agents powered by SearXNG (https://github.com/searxng/searxng). Self-hosted metasearch engine with no API keys, rate limits, or monthly fees. Aggregates 70+ search engines (Google, Bing, DuckDuckGo, GitHub, Stack Overflow, etc.) Use when: (1) searching the web, (2) looking up information online, (3) researching topics, (4) finding current news, (5) searching for code, (6) any web search needed. Privacy-focused alternative to Tavily, SerpAPI, Google Custom Search.
---

# Free Web Search for AI Agents

Powered by [SearXNG](https://github.com/searxng/searxng) - Privacy-respecting, hackable metasearch engine.

## Quick Start

### Installation

Give this prompt to your AI agent (Claude, ChatGPT, Codex, Cursor, OpenCode, Pi, Gemini):

```
Install the free-web-search skill from https://github.com/vksco/free-web-search

Requirements:
- Ensure Docker is installed and running
- Clone the repo to ~/.openclaw/workspace/skills/free-web-search
- Make all scripts executable
- Start the SearXNG container
- Test with a simple search query

After installation, confirm it's working by searching for "AI agents" and showing me 3 results.
```

### Manual Installation

```bash
# Clone repository
git clone https://github.com/vksco/free-web-search.git ~/.openclaw/workspace/skills/free-web-search
cd ~/.openclaw/workspace/skills/free-web-search

# Make scripts executable
chmod +x scripts/*.sh

# Start SearXNG
bash scripts/docker-manager.sh start

# Wait for container to be ready (10-20 seconds)
sleep 20

# Test search
curl 'http://localhost:8888/search?q=test&format=json'
```

## How to Use

### 1. Check for Updates (Runs Automatically)

The skill automatically checks for updates when it loads. To manually check:

```bash
bash scripts/auto-update.sh
```

This will:
1. Check GitHub for latest version
2. Download update if available
3. Create backup of current version
4. Install new version
5. Preserve your configuration

### 2. Search the Web

```bash
# Basic search
curl 'http://localhost:8888/search?q=AI%20agents&format=json'

# Search specific engines
curl 'http://localhost:8888/search?q=python%20async&format=json&engines=github,stackoverflow'

# News search
curl 'http://localhost:8888/search?q=breaking%20news&format=json&categories=news'
```

### 3. Python Integration

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
- ✅ **Privacy-focused** - Self-hosted, no tracking, no profiling
- ✅ **Docker-based** - Easy 2-minute installation
- ✅ **JSON API** - Simple REST API for any application
- ✅ **Python support** - Built-in search function
- ✅ **Production-ready** - Fully tested and documented

## Auto-Update System

The skill automatically checks for updates when loaded:

1. **Version Check** - Compares local VERSION with GitHub
2. **Smart Throttling** - Only checks once per hour (configurable)
3. **Safe Backup** - Creates backup before updating
4. **Config Preservation** - Keeps your custom settings
5. **Seamless Install** - Downloads and installs automatically
6. **No Restart Required** - Update applies on next skill load

### Manual Update

```bash
cd ~/.openclaw/workspace/skills/free-web-search
bash scripts/auto-update.sh
```

### View Update Logs

```bash
tail -20 update.log
```

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

```bash
# Check status
bash scripts/docker-manager.sh status

# View logs
bash scripts/docker-manager.sh logs

# Restart container
bash scripts/docker-manager.sh restart

# Stop container
bash scripts/docker-manager.sh stop
```

## Configuration

### Environment Variables

```bash
# Optional: Fallback to Tavily if SearXNG is down
export TAVILY_API_KEY="tvly-your-key-here"
```

### SearXNG Settings

Configuration file: `docker/settings.yml`

You can customize:
- Enabled search engines
- Request timeouts
- Result formats
- Safe search settings

## Cost Savings

| Service | Cost | Your Cost |
|---------|------|-----------|
| **This skill** | **Free forever** | **$0** ✅ |
| Tavily | $120+/year | **Save $120** |
| SerpAPI | $600/year | **Save $600** |
| Google Custom Search | $1500+/year | **Save $1500** |

## Troubleshooting

### Container won't start

```bash
# Check Docker is running
docker info

# Check port 8888
lsof -i :8888

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
cat update.log

# Restore from backup
tar -xzf backups/skill_TIMESTAMP.tar.gz -C ~/.openclaw/workspace/skills/free-web-search/
```

## Requirements

- Docker Desktop (installed and running)
- 2GB RAM available
- Port 8888 available
- Git (for installation)

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
