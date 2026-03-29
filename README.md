# Free Web Search for AI Agents - Unlimited Google Search Alternative

> Powered by [SearXNG](https://github.com/searxng/searxng) - Privacy-respecting metasearch engine

No API keys. No rate limits. Unlimited searches. Free forever.

**Self-hosted search engine for AI assistants** - Get unlimited access to Google, Bing, DuckDuckGo, and 70+ search engines without API keys, rate limits, or or monthly fees. Perfect for AI agents, research assistants, and automation tools.

**This skill wraps [SearXNG](https://github.com/searxng/searxng) with Docker for easy integration with OpenClaw.**

Free Forever
No API Key Required
Unlimited Searches
Self-Hosted

---

## 🎯 What This Does

**Replace expensive search APIs** (Tavily, SerpAPI, Google Custom Search) with a free, unlimited, self-hosted alternative that runs locally on your machine. No API keys to manage, no monthly fees, no rate limits.

**Perfect for:**

- ✅ AI agents and assistants
- ✅ Research automation tools
- ✅ Content monitoring systems
- ✅ News aggregation
- ✅ Competitive intelligence
- ✅ Academic research

**Search engines included:**

- Google, Bing, DuckDuckGo, Yahoo, Qwant
- GitHub, Stack Overflow, GitLab
- Reddit, Wikipedia, YouTube
- 70+ more engines

---

## ⚡ Installation

### 🤖 One-Prompt Auto-Install (Recommended)

Just give this prompt to your AI agent (Claude, ChatGPT, Codex, Gemini, Cursor, OpenCode, Pi, etc.):

---

**Copy and paste this to your AI:**

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

---

That's it! Your agent will:
1. ✅ Install Docker (if needed)
2. ✅ Clone the repository
3. ✅ Set up everything automatically
4. ✅ Test the search
5. ✅ Report back with results

**Installation time:** 2-5 minutes (mostly Docker image download)

---

### 🔧 Manual Installation (Alternative)

If you prefer manual installation:

```bash
# Prerequisites: Docker Desktop installed and running

# Clone and setup
git clone https://github.com/vksco/free-web-search.git
cd free-web-search
chmod +x scripts/*.sh

# Start container
bash scripts/docker-manager.sh start
```

**SearXNG is now running on [http://localhost:8888](http://localhost:8888)** 🎉

---

### ✅ Verify Installation

```bash
# Test search
curl 'http://localhost:8888/search?q=AI%20agents&format=json'

# Check status
bash scripts/docker-manager.sh status
```

---

## 💰 Cost Comparison


| Service              | Free Tier     | Above Free        | Your Cost   |
| -------------------- | ------------- | ----------------- | ----------- |
| **This skill**       | **Unlimited** | **$0 forever**    | **Free** ✅  |
| Tavily               | 1,000/month   | $29/month for 10k | $120+/year  |
| SerpAPI              | 100/month     | $50/month for 5k  | $600/year   |
| Google Custom Search | 100/day       | $5/1000 queries   | $1500+/year |
| Bing Search API      | 1000/month    | $3/1000 queries   | Varies      |


**Your savings: $150-$600+ per year** by using this free alternative!

---

## 🚀 Usage Examples

### 1. Basic Web Search

```bash
# Search for anything
curl 'http://localhost:8888/search?q=machine%20learning&format=json'
```

### 2. Code & Documentation Search

```bash
# Search GitHub and Stack Overflow
curl 'http://localhost:8888/search?q=react%20hooks&format=json&engines=github,stackoverflow'
```

### 3. News & Current Events

```bash
# Get latest news
curl 'http://localhost:8888/search?q=artificial%20intelligence&format=json&categories=news&time_range=day'
```

### 4. Python Integration

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

### 5. In OpenClaw Conversations

Just ask OpenClaw to search:

- "Search for the latest AI research"
- "Find documentation on Python async"
- "Look up recent tech news"
- "Search GitHub for React examples"

---

## 🌟 Features

### Unlimited & Free

- ✅ **No API keys** - Completely free, no signup required
- ✅ **No rate limits** - Search as much as you want, 24/7
- ✅ **No monthly fees** - $0 forever
- ✅ **70+ search engines** - More than any paid service

### Privacy-Focused

- ✅ **No tracking** - Your searches stay private
- ✅ **No profiling** - No user data collected
- ✅ **No ads** - Clean search results
- ✅ **Self-hosted** - Full control over your data

### Easy Integration

- ✅ **Docker-based** - One command installation
- ✅ **JSON API** - Easy to integrate
- ✅ **Python support** - Built-in search function
- ✅ **Auto-fallback** - Switches to Tavily if needed

### Automatic Updates

- ✅ **Auto-update** - Checks for updates every hour
- ✅ **Backup system** - Safe updates with rollback
- ✅ **Version tracking** - Know what version you're on
- ✅ **Config preservation** - Updates preserve your settings

---

## 🔧 Management Commands

### Container Management

```bash
# Check if running
bash scripts/docker-manager.sh status

# View logs
bash scripts/docker-manager.sh logs

# Restart container
bash scripts/docker-manager.sh restart

# Stop container
bash scripts/docker-manager.sh stop
```

### Auto-Update Management

```bash
# Manual update check
bash scripts/auto-update.sh

# View update log
cat update.log

# Setup automatic hourly updates (optional)
crontab -e
# Add this line:
0 * * * * /bin/bash /path/to/free-web-search/scripts/auto-update.sh
```

---

## 📊 Available Search Engines

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
- **duckduckgo definitions** - Instant answers

### News

- **google news** - Google News
- **bing news** - Bing News

---

## 🎓 Search Tips

### Faster Searches

```bash
# Use specific engines (faster)
curl 'http://localhost:8888/search?q=python&format=json&engines=google,duckduckgo'

# Instead of all engines (slower)
curl 'http://localhost:8888/search?q=python&format=json'  # Uses all 70+ engines
```

### Better Results

```bash
# Exact phrase search
curl 'http://localhost:8888/search?q="machine%20learning"&format=json'

# Site-specific search
curl 'http://localhost:8888/search?q=python%20site:github.com&format=json'

# Recent results only
curl 'http://localhost:8888/search?q=AI&format=json&time_range=day'

# Exclude terms
curl 'http://localhost:8888/search?q=python%20-snake&format=json'
```

### Category Search

```bash
# Images
curl 'http://localhost:8888/search?q=cats&format=json&categories=images'

# News
curl 'http://localhost:8888/search?q=technology&format=json&categories=news'

# Videos
curl 'http://localhost:8888/search?q=tutorial&format=json&categories=videos'
```

---

## 📁 File Structure

```
searxng-skill/
├── SKILL.md                    # Skill documentation
├── README.md                   # This file
├── VERSION                     # Current version (0.0.1)
├── LICENSE                     # MIT License
├── scripts/
│   ├── docker-manager.sh       # Container management
│   ├── search.py                # Python search function
│   └── auto-update.sh           # Auto-update script
├── docker/
│   └── settings.yml             # SearXNG configuration
├── references/
│   ├── searxng-api.md           # SearXNG API reference
│   └── tavily-api.md            # Tavily API reference
└── SETUP.md                    # Installation guide
```

---

## 🔒 Privacy & Security

### What's Tracked

- ✅ **No search history** - SearXNG doesn't store searches
- ✅ **No user profiling** - No user accounts or tracking
- ✅ **No IP logging** - Searches are anonymous
- ✅ **Local only** - Runs on your machine, not a remote server

### Security Features

- ✅ **Self-hosted** - Full control over your data
- ✅ **No external API calls** - Everything runs locally
- ✅ **Docker isolation** - Containerized for security
- ✅ **Configurable engines** - Disable any engine you don't trust

---

## 🆘 Troubleshooting

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

### Slow searches

```bash
# Use fewer engines
curl 'http://localhost:8888/search?q=test&format=json&engines=google,duckduckgo'

# Reduce timeout in docker/settings.yml
```

---

## 📈 Performance

### Typical Response Times

- **First search**: 2-5 seconds (engine warmup)
- **Subsequent searches**: 0.5-2 seconds
- **Results per page**: ~20 results

### Resource Usage

- **Memory**: 300-600MB typical
- **CPU**: Spikes during search, idle otherwise
- **Network**: Depends on query frequency
- **Disk**: ~500MB for Docker image

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This skill (wrapper/integration code) is MIT licensed.

**Important:** The search functionality is provided by [SearXNG](https://github.com/searxng/searxng), SearXNG is licensed under AGPL-3.0. When you use this skill, you are using SearXNG under its license terms.

## 🆘 Support

- **This Skill**: GitHub Issues (for integration questions)
- **SearXNG Docs**: [https://docs.searxng.org/](https://docs.searxng.org/) (for search engine questions)
- **SearXNG Issues**: [https://github.com/searxng/searxng/issues](https://github.com/searxng/searxng/issues)

---

## 🎉 Credits & Attribution

This skill is made possible by:

- **[SearXNG](https://github.com/searxng/searxng)** - The privacy-respecting, hackable metasearch engine that provides all search functionality. This is the core engine that aggregates 70+ search engines. **Please star SearXNG on GitHub!** ⭐
- **OpenClaw** - AI assistant framework that makes skills like this possible
- **Docker** - Containerization platform for easy deployment

**This is a skill/wrapper that integrates SearXNG with OpenClaw. All search functionality comes from the SearXNG project under AGPL-3.0.**

If you find this useful, please:

1. ⭐ Star SearXNG: [https://github.com/searxng/searxng](https://github.com/searxng/searxng)
2. ⭐ Star this skill (if published to GitHub)
3. Contribute to SearXNG development

---

**Made with ❤️ for the AI community**

**Star ⭐ on GitHub if you find it useful!**