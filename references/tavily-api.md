# Tavily API Reference (Fallback)

## Overview

Tavily is a search API optimized for AI agents. Used as fallback when SearXNG is unavailable.

## API Key

Get your API key: https://tavily.com/

Set in environment:
```bash
export TAVILY_API_KEY="tvly-your-api-key-here"
```

## Base URL

```
https://api.tavily.com
```

## Endpoints

### Search

```
POST /search
```

## Request Format

```python
import requests

response = requests.post(
    "https://api.tavily.com/search",
    json={
        "api_key": "tvly-your-api-key",
        "query": "machine learning frameworks 2024",
        "search_depth": "basic",  # or "advanced"
        "max_results": 10,
        "include_raw_content": False,
        "include_images": False
    }
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `api_key` | string | required | Your Tavily API key |
| `query` | string | required | Search query |
| `search_depth` | string | "basic" | "basic" or "advanced" |
| `max_results` | int | 5 | Max results (1-10) |
| `include_raw_content` | bool | false | Include raw HTML |
| `include_images` | bool | false | Include related images |
| `include_answer` | bool | false | Include AI-generated answer |
| `include_domains` | array | [] | Only search these domains |
| `exclude_domains` | array | [] | Exclude these domains |

## Response Format

```json
{
  "results": [
    {
      "title": "Result Title",
      "url": "https://example.com",
      "content": "Page content snippet...",
      "score": 0.95,
      "raw_content": null
    }
  ],
  "images": [],
  "answer": null
}
```

## Search Depths

### Basic
- Faster
- ~5 results
- Good for quick searches

### Advanced
- More comprehensive
- Up to 10 results
- Better for research

## Rate Limits

- **Free tier**: 1000 searches/month
- **Pro tier**: 10,000 searches/month
- **Enterprise**: Unlimited

## Best Practices

### 1. Use Basic Depth First

```python
# Try basic first (faster, cheaper)
results = search_tavily(query, search_depth="basic")

# Only use advanced if needed
if not results or need_more:
    results = search_tavily(query, search_depth="advanced")
```

### 2. Limit Results

```python
# Only request what you need
results = search_tavily(query, max_results=5)
```

### 3. Domain Filtering

```python
# Search only specific domains
results = search_tavily(
    query,
    include_domains=["github.com", "stackoverflow.com"]
)
```

### 4. Handle Errors

```python
try:
    response = requests.post(url, json=payload, timeout=10)
    response.raise_for_status()
except requests.exceptions.HTTPError as e:
    if e.response.status_code == 401:
        raise ValueError("Invalid Tavily API key")
    elif e.response.status_code == 429:
        raise RuntimeError("Tavily rate limit exceeded")
    else:
        raise
```

## Advantages

- ✅ Optimized for AI agents
- ✅ Clean, structured results
- ✅ AI-generated answers (optional)
- ✅ Image results (optional)
- ✅ Domain filtering
- ✅ Reliable uptime

## Disadvantages

- ❌ Requires API key
- ❌ Rate limits on free tier
- ❌ Paid for heavy usage
- ❌ Less privacy than SearXNG

## Cost Comparison

| Service | Free Tier | Cost Above Free |
|---------|-----------|-----------------|
| **SearXNG (self-hosted)** | Unlimited | $0 (hosting only) |
| **Tavily** | 1,000/month | $29/month for 10k |
| Google Custom Search | 100/day | $5/1000 queries |
| SerpAPI | 100/month | $50/month for 5k |

## When to Use Tavily

Use Tavily when:
- SearXNG container is down
- Need AI-generated answer
- Need domain-specific filtering
- Need image results
- Self-hosting not possible

## Troubleshooting

### 401 Unauthorized
- Check API key is correct
- Verify key is active in dashboard

### 429 Too Many Requests
- Rate limit exceeded
- Wait or upgrade plan
- Fall back to other methods

### Empty Results
- Query may be too specific
- Try broader search terms
- Check if domains are accessible

## Integration Example

```python
def search_with_fallback(query: str) -> List[Dict]:
    """Search with automatic SearXNG → Tavily fallback"""
    
    # Try SearXNG first
    try:
        return search_searxng(query)
    except Exception as e:
        logger.warning(f"SearXNG failed: {e}")
    
    # Fall back to Tavily
    try:
        return search_tavily(query)
    except Exception as e:
        logger.error(f"Tavily also failed: {e}")
        raise RuntimeError("All search methods failed")
```

## Additional Resources

- Official Docs: https://docs.tavily.com/
- API Reference: https://docs.tavily.com/docs/api-reference
- Dashboard: https://app.tavily.com/
- Pricing: https://tavily.com/#pricing
