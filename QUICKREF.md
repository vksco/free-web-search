# Quick Reference: Free Web Search Skill

**Search the web for free - No API keys needed!**

**Powered by [SearXNG](https://github.com/searxng/searxng)** - Privacy-respecting metasearch engine

## What is this?
Unlimited web search for AI agents using [SearXNG](https://github.com/searxng/searxng) Aggregates Google, Bing, DuckDuckGo, and 70+ search engines. No API keys, no rate limits, no monthly fees. Free forever. This skill provides easy Docker integration for OpenClaw.

## Install (2 minutes)
```bash
git clone https://github.com/vksco/searxng-skill.git
cd searxng-skill
chmod +x scripts/*.sh
bash scripts/docker-manager.sh start
```

## Search Examples
```bash
# Basic search
curl 'http://localhost:8888/search?q=AI%20agents&format=json'

# Code search
curl 'http://localhost:8888/search?q=python&format=json&engines=github,stackoverflow'

# News search
curl 'http://localhost:8888/search?q=tech%20news&format=json&categories=news'
```

## In OpenClaw
Just ask:
- "Search for AI research"
- "Find Python documentation"
- "What's new in tech?"
- "Search GitHub for React"

## Features
- Unlimited searches (no limits!)
- 70+ search engines
- No API key needed
- Privacy-focused
- Auto-updates
- Free forever

## Management
```bash
# Status
bash scripts/docker-manager.sh status

# Logs
bash scripts/docker-manager.sh logs

# Restart
bash scripts/docker-manager.sh restart

# Update
bash scripts/auto-update.sh
```

## Popular Engines
- **General**: Google, Bing, DuckDuckGo, Yahoo
- **Code**: GitHub, Stack Overflow, GitLab
- **News**: Google News, Bing News
- **Q&A**: Reddit, Stack Exchange
- **Media**: YouTube, Wikipedia

## Why Free?
Runs locally on your machine using Docker. No cloud services, no API providers, no middlemen. Just pure, unlimited search.

## Quick Stats
- **Cost**: $0 (forever)
- **Rate limit**: None (unlimited)
- **Engines**: 70+
- **Privacy**: 100% (self-hosted)
- **Setup**: 2 minutes

## Help
- Full docs: See README.md
- Issues: GitHub Issues
- Logs: `cat update.log`

---
**Save $600+/year vs paid APIs!** 
