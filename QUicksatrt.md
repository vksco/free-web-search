# How to Use SearXNG with OpenClaw

## Quick Start
Your SearXNG integration is now fully operational! Use it to search for anything.

## Method 1: Ask OpenClaw (Automatic)
Just ask OpenClaw to search for something:
- OpenClaw will automatically use SearXNG
- SearXNG will search  web using 70+ search engines
- Results are returned to you

**Example:**
```
You: "Search for the latest AI agent frameworks"
OpenClaw: [Searches SearXNG, returns results]
```

## Method 2: Python Integration
```python
import sys
sys.path.insert(0, '/Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts')
from search import search_web

# Basic search
results = search_web("AI agents 2026", count=10)
for r in results:
    print(f"{r['title']}\n{r['url']}\n")
# Search with specific engines
results = search_web(
    "python async tutorial",
    engines="github,stackoverflow",
    count=5
)
# Search for recent news
results = search_web(
    "AI breakthrough",
    categories="news",
    count=5
)
```
## Method 3: CLI
```bash
# Search for anything
python3 /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/search.py "your query" 5

# Check container status
docker ps | grep searxng
```
## Container Management
```bash
# Start container
bash /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/docker-manager.sh start

# Stop container
bash /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/docker-manager.sh stop
# Restart container
bash /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/docker-manager.sh restart
# View logs
bash /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/docker-manager.sh logs
```
## Available Search Engines
### General Search
- `google` - Google Search
- `duckduckgo` - DuckDuckGo
- `bing` - Microsoft Bing

- `yahoo` - Yahoo Search
- `qwant` - Qwant

### Code & Development
- `github` - GitHub
- `stackoverflow` - Stack Overflow
- `gitlab` - GitLab
### Q&A Forums
- `reddit` - Reddit
- `askubuntu` - Ask Ubuntu
### Media
- `youtube` - YouTube
- `vimeo` - Vimeo
### Reference
- `wikipedia` - Wikipedia
- `wikidata` - Wikidata
### News
- `google news` - Google News
- `bing news` - Bing News
## Search Examples
### Latest News
```python
# Search for AI breakthrough news
results = search_web(
    "artificial intelligence breakthrough 2026",
    categories="news",
    count=5
)
```
### Code Documentation
```python
# Search for Python async documentation
results = search_web(
    "python asyncio tutorial",
    engines="github,stackoverflow",
    count=5
)
```
### Academic Papers
```python
# Search for recent research papers
results = search_web(
    "transformer neural networks arxiv",
    engines="google,scholar",
    count=10
)
```
## Tips
### Faster Searches
Use specific engines instead of all:
```python
# Fast: 2 seconds
search_web("query", engines="google,duckduckgo", count=5)
# Slow: 10+ seconds
search_web("query")  # Uses all engines
```
### Reduce Results
Only request what you need
```python
search_web("query", count=5)  # instead of 10
```
### Use Categories
For specific content types
```python
# Images
search_web("cats", categories="images", count=5)
# News
search_web("breaking news", categories="news", count=5)
```
## Error Handling
If SearXNG fails (e.g., container stops):
```python
# Automatic fallback to Tavily
results = search_web("query")  # Will use Tavily if available
if TAVILY_API_KEY set
```
## Troubleshooting
### Container not starting
```bash
docker start searxng-openclaw
```
### Port 8888 in use
```bash
lsof -i :8888
```
### No results
- Try different query
- Check specific engines
- Verify network connection
```
## Files Created
- `SKILL.md` - This file (skill documentation)
- `scripts/docker-manager.sh` - Container management
- `scripts/search.py` - Python search function
- `docker/settings.yml` - SearXNG configuration
- `references/searxng-api.md` - SearXNG API docs
- `references/tavily-api.md` - Tavily API docs
- `README.md` - Quick start guide
- `USAGE.md` - Usage examples
- `SETup.md` - Installation guide
## Support
- **SearXNG Docs:** https://docs.searxng.org/
- **OpenClaw Skills:** `README.md`, `USAGE.md`
