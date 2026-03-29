# Release v0.1.0 - First Stable Release

**Release Date:** March 29, 2026

---

## 🎉 First Stable Release!

Free unlimited web search for AI agents - powered by SearXNG with proper attribution.

---

## ✨ Features

### Core Features
- ✅ **Unlimited free web search** - No API keys, no rate limits
- ✅ **70+ search engines** - Google, Bing, DuckDuckGo, GitHub, Stack Overflow, Reddit, and more
- ✅ **Privacy-focused** - Self-hosted, no tracking, no profiling
- ✅ **Docker-based** - Easy installation and deployment
- ✅ **Auto-update system** - Hourly checks for updates with safe rollback

### Installation
- ✅ **One-prompt AI installation** - Works with Claude, ChatGPT, Codex, Cursor, OpenCode, Pi, Gemini
- ✅ **Simple setup** - Just give a prompt to your AI agent
- ✅ **2-minute installation** - Most time is Docker image download

### Search Features
- ✅ **General search** - Google, Bing, DuckDuckGo, Yahoo, Qwant
- ✅ **Code search** - GitHub, Stack Overflow, GitLab
- ✅ **News search** - Google News, Bing News
- ✅ **Media search** - YouTube, Vimeo
- ✅ **Reference** - Wikipedia, Wikidata

### Integration
- ✅ **JSON API** - Easy REST API for any application
- ✅ **Python support** - Built-in search function
- ✅ **OpenClaw integration** - Native skill support
- ✅ **Curl examples** - Simple HTTP requests

---

## 📦 What's Included

### Scripts
- `scripts/docker-manager.sh` - Container management (start/stop/restart/status)
- `scripts/auto-update.sh` - Automatic update checker
- `scripts/search.py` - Python search function

### Configuration
- `docker/settings.yml` - SearXNG configuration
- `.gitignore` - Git ignore rules

### Documentation
- `README.md` - Main documentation (SEO-optimized)
- `INSTALL.md` - Installation guide with AI prompts
- `SKILL.md` - Skill metadata
- `SETUP.md` - Setup instructions
- `USAGE.md` - Usage examples
- `AUTO_UPDATE.md` - Auto-update documentation
- `QUICKREF.md` - Quick reference guide

### References
- `references/searxng-api.md` - SearXNG API documentation
- `references/tavily-api.md` - Tavily fallback documentation

---

## 🚀 Installation

### Quick Install (Recommended)

Just give this prompt to your AI agent:

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

### Manual Install

```bash
# Clone repository
git clone https://github.com/vksco/free-web-search.git
cd free-web-search

# Make scripts executable
chmod +x scripts/*.sh

# Start container
bash scripts/docker-manager.sh start

# Test
curl 'http://localhost:8888/search?q=test&format=json'
```

---

## 💰 Cost Savings

| Service | Cost | Your Cost with This Skill |
|---------|------|---------------------------|
| Tavily | $120+/year | **Free** ✅ |
| SerpAPI | $600/year | **Free** ✅ |
| Google Custom Search | $1500+/year | **Free** ✅ |

**Save $600+ per year** with this free, unlimited alternative!

---

## 🙏 Credits & Attribution

This skill is powered by:

- **[SearXNG](https://github.com/searxng/searxng)** - The privacy-respecting metasearch engine
- **OpenClaw** - AI assistant framework
- **Docker** - Containerization platform

**Please star SearXNG on GitHub!** ⭐
https://github.com/searxng/searxng

---

## 📋 Requirements

- Docker Desktop (installed and running)
- 2GB RAM available
- Port 8888 available
- Git (for installation)

---

## 🔧 What's Next

### Upcoming Features (v0.2.0+)
- [ ] Web UI for search management
- [ ] Custom search engine configurations
- [ ] Search analytics and logging
- [ ] Multi-language support
- [ ] Browser extension
- [ ] API rate limiting (optional)
- [ ] Search result caching

---

## 🐛 Known Issues

None at this time. Please report issues on GitHub:
https://github.com/vksco/free-web-search/issues

---

## 📄 License

This skill (wrapper/integration code) is MIT licensed.

**Important:** The search functionality is provided by [SearXNG](https://github.com/searxng/searxng) under AGPL-3.0 license.

---

## 📞 Support

- **GitHub Issues**: https://github.com/vksco/free-web-search/issues
- **SearXNG Docs**: https://docs.searxng.org/
- **OpenClaw Discord**: https://discord.com/invite/clawd

---

## 🎯 Quick Start

1. Give installation prompt to your AI agent
2. Wait 2-5 minutes for installation
3. Start searching!

```bash
# Example search
curl 'http://localhost:8888/search?q=AI%20agents&format=json'
```

---

**Made with ❤️ for the AI community**

**Star ⭐ on GitHub if you find it useful!**

https://github.com/vksco/free-web-search
