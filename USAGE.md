# How to Use SearXNG with OpenClaw

## Automatic Integration

The `searxng-integration` skill is now installed and will work automatically with OpenClaw. Here's how:

---

## Method 1: Use in Conversations (Automatic)

Just ask OpenClaw to search, and it will use SearXNG by default:

**Example:**
```
You: "Search for the latest AI agent frameworks"
```

OpenClaw will:
1. Detect the search request
2. Trigger the searxng-integration skill
3. Search using SearXNG (localhost:8888)
4. Return results

---

## Method 2: Direct Python Function

Import and use the search function directly:

```python
import sys
sys.path.insert(0, '/Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts')

from search import search_web

# Basic search
results = search_web("machine learning 2024", count=10)

# With specific engines
results = search_web(
    "python async await",
    engines="google,stackoverflow",
    count=5
)

# Search images
results = search_web(
    "AI architecture diagrams",
    categories="images",
    count=10
)
```

---

## Method 3: HTTP API (curl)

Direct API calls to your SearXNG instance:

```bash
# Basic search
curl 'http://localhost:8888/search?q=docker%20compose&format=json'

# With specific engines
curl 'http://localhost:8888/search?q=python&format=json&engines=google,duckduckgo'

# News search
curl 'http://localhost:8888/search?q=AI%20news&format=json&categories=news'

# Time-limited (last day)
curl 'http://localhost:8888/search?q=breaking%20news&format=json&time_range=day'
```

---

## Method 4: CLI Tool

Use the built-in CLI script:

```bash
python3 /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/search.py "query" 10
```

---

## Integration with Other Skills

You can use SearXNG in your custom skills:

```python
# In your custom skill's Python script
import sys
sys.path.insert(0, '/Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts')
from search import search_web

def research_topic(topic):
    # Search for recent research
    results = search_web(f"{topic} recent research 2024", count=10)

    # Process results
    for r in results:
        print(f"Found: {r['title']}")
        print(f"URL: {r['url']}")
        print(f"Source: {r['source']}")  # 'searxng' or 'tavily'

    return results
```

---

## Available Search Engines

### General
- `google`
- `bing`
- `duckduckgo`
- `yahoo`
- `qwant`

### Code & Development
- `github`
- `stackoverflow`
- `gitlab`
- `bitbucket`

### Q&A Forums
- `reddit`
- `stackoverflow`
- `askubuntu`

### Media
- `youtube`
- `vimeo`

### Reference
- `wikipedia`
- `wikidata`

### News
- `google news`
- `bing news`

---

## Example Use Cases

### 1. Research Agent

```python
from search import search_web

def research_paper(topic):
    # Search academic sources
    results = search_web(
        f"{topic} research paper",
        engines="google,scholar",
        count=20
    )

    papers = []
    for r in results:
        if 'arxiv' in r['url'] or 'scholar' in r['url']:
            papers.append(r)

    return papers
```

### 2. Code Search

```python
def find_code_examples(language, topic):
    results = search_web(
        f"{language} {topic} example",
        engines="github,stackoverflow",
        count=10
    )

    for r in results:
        print(f"Title: {r['title']}")
        print(f"URL: {r['url']}")
```

### 3. News Monitor

```python
def get_latest_news(topic):
    results = search_web(
        topic,
        categories="news",
        count=10
    )

    return results
```

### 4. Documentation Search

```python
def search_docs(framework, query):
    results = search_web(
        f"site:docs.{framework}.io {query}",
        engines="google",
        count=5
    )

    return results
```

---

## Fallback Behavior

### Automatic Fallback

If SearXNG is unavailable:

1. **SearXNG fails** → Skill checks if container running
2. **Not running** → Attempts to start container
3. **Still fails** → Falls back to Tavily API
4. **Tavily fails** → Returns error message

### Result Metadata

Each result includes a `source` field:

```python
{
    "title": "...",
    "url": "...",
    "content": "...",
    "source": "searxng"  # or "tavily"
}
```

---

## Performance Tips

### 1. Use Specific Engines

```python
# Faster (fewer engines)
search_web("query", engines="google,duckduckgo")

# Slower (all engines)
search_web("query")  # Default: all engines
```

### 2. Limit Results

```python
# Only request what you need
search_web("query", count=5)  # Instead of 20
```

### 3. Use Categories

```python
# Faster for specific content
search_web("cats", categories="images")
```

### 4. Cache Frequent Queries

```python
# In your skill, cache results
cache = {}

def cached_search(query):
    if query in cache:
        return cache[query]

    results = search_web(query)
    cache[query] = results
    return results
```

---

## Configuration Options

### Environment Variables

```bash
# SearXNG URL (default: http://localhost:8888)
export SEARXNG_URL="http://localhost:8888"

# Tavily API Key (for fallback)
export TAVILY_API_KEY="tvly-your-key-here"
```

### Custom Configuration

Edit `docker/settings.yml` to:
- Enable/disable specific engines
- Set timeouts
- Configure caching
- Add custom engines

---

## Troubleshooting

### "No module named 'requests'"

```bash
python3 -m pip install --user requests
```

### "Connection refused"

```bash
# Check container is running
bash /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/docker-manager.sh status

# Start if needed
bash /Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts/docker-manager.sh start
```

### "TAVILY_API_KEY not set"

```bash
# Add to your shell profile
echo 'export TAVILY_API_KEY="tvly-your-key"' >> ~/.zshrc
source ~/.zshrc
```

### Slow Searches

- Use specific engines instead of all
- Reduce result count
- Check network connectivity
- Review Docker resource limits

---

## Advanced: Custom Search Function

Create your own search wrapper:

```python
import sys
sys.path.insert(0, '/Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts')
from search import search_web

def smart_search(query, search_type="general"):
    """Intelligent search based on query type"""

    config = {
        "code": {
            "engines": "github,stackoverflow",
            "count": 10
        },
        "news": {
            "categories": "news",
            "count": 10
        },
        "academic": {
            "engines": "google,scholar",
            "count": 20
        },
        "general": {
            "engines": "google,duckduckgo,bing",
            "count": 10
        }
    }

    params = config.get(search_type, config["general"])

    results = search_web(
        query,
        engines=params.get("engines"),
        categories=params.get("categories"),
        count=params["count"]
    )

    return results

# Usage
code_results = smart_search("python async", search_type="code")
news_results = smart_search("AI breakthrough", search_type="news")
```

---

## Summary

✅ **SearXNG is ready to use**
✅ **Automatic integration with OpenClaw**
✅ **Python API available**
✅ **CLI tool available**
✅ **Unlimited free searches**
✅ **Automatic fallback to Tavily**

Just start searching! The skill handles everything automatically.

---

*Need help? Check the SKILL.md or SETUP.md files in the skill directory.*
