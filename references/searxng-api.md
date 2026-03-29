# SearXNG API Reference

## Overview

SearXNG is a metasearch engine that aggregates results from 70+ search engines. This reference covers the API usage for the self-hosted instance.

## Base URL

```
http://localhost:8888
```

## Endpoints

### Search

```
GET /search
POST /search
```

## Parameters

### Required

| Parameter | Type | Description |
|-----------|------|-------------|
| `q` | string | Search query |

### Optional

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `format` | string | html | Output format: `json`, `csv`, `rss`, `html` |
| `engines` | string | all | Comma-separated list of engines |
| `categories` | string | - | Search categories |
| `pageno` | int | 1 | Page number for pagination |
| `time_range` | string | - | `day`, `month`, `year` |
| `language` | string | auto | Language code |
| `safesearch` | int | 0 | 0=off, 1=moderate, 2=strict |
| `image_proxy` | bool | true | Proxy images through SearXNG |

## Examples

### Basic Search (JSON)

```bash
curl 'http://localhost:8888/search?q=python&format=json'
```

### Specific Engines

```bash
curl 'http://localhost:8888/search?q=machine%20learning&format=json&engines=google,duckduckgo'
```

### Pagination

```bash
# Page 1
curl 'http://localhost:8888/search?q=docker&format=json&pageno=1'

# Page 2
curl 'http://localhost:8888/search?q=docker&format=json&pageno=2'
```

### Time Range

```bash
curl 'http://localhost:8888/search?q=AI%20news&format=json&time_range=day'
```

### Categories

```bash
curl 'http://localhost:8888/search?q=python&format=json&categories=images'
```

## Response Format

### JSON Response Structure

```json
{
  "query": "python",
  "number_of_results": 42,
  "results": [
    {
      "title": "Welcome to Python.org",
      "url": "https://www.python.org/",
      "content": "The official home of the Python Programming Language...",
      "engine": "google",
      "engines": ["google", "duckduckgo"],
      "parsed_url": [
        "https",
        "www.python.org",
        "/",
        "",
        ""
      ],
      "thumbnail": null
    }
  ],
  "answers": [],
  "corrections": [],
  "infoboxes": [],
  "suggestions": [],
  "unresponsive_engines": []
}
```

### Result Fields

| Field | Type | Description |
|-------|------|-------------|
| `title` | string | Page title |
| `url` | string | Result URL |
| `content` | string | Page snippet/description |
| `engine` | string | Primary engine that returned this result |
| `engines` | array | All engines that returned this result |
| `thumbnail` | string | Thumbnail URL (if available) |
| `parsed_url` | array | URL components [scheme, netloc, path, query, fragment] |

## Available Engines

### General Search
- `google` - Google Search
- `bing` - Microsoft Bing
- `duckduckgo` - DuckDuckGo
- `yahoo` - Yahoo Search
- `qwant` - Qwant

### Code & Development
- `github` - GitHub
- `stackoverflow` - Stack Overflow
- `gitlab` - GitLab
- `bitbucket` - Bitbucket
- `codeberg` - Codeberg

### Q&A Forums
- `stackoverflow` - Stack Overflow
- `askubuntu` - Ask Ubuntu
- `superuser` - Super User
- `reddit` - Reddit

### Media
- `youtube` - YouTube
- `vimeo` - Vimeo
- `dailymotion` - Dailymotion

### Reference
- `wikipedia` - Wikipedia
- `duckduckgo_definitions` - DuckDuckGo Definitions
- `wikidata` - Wikidata

### News
- `google news` - Google News
- `bing news` - Bing News
- `duckduckgo news` - DuckDuckGo News

### Images
- `google images` - Google Images
- `bing images` - Bing Images
- `duckduckgo images` - DuckDuckGo Images

## Categories

- `general` - General web search
- `images` - Image search
- `videos` - Video search
- `news` - News articles
- `map` - Map/location search
- `music` - Music search
- `it` - IT/tech resources
- `science` - Scientific articles
- `files` - File search
- `social media` - Social networks

## Search Syntax

### Exact Phrase
```
"machine learning"
```

### Site-Specific
```
python site:github.com
```

### Exclude Terms
```
python -snake
```

### OR Operator
```
(python OR java) tutorial
```

### File Type
```
python filetype:pdf
```

### Title Search
```
intitle:python
```

### URL Search
```
inurl:python
```

## Rate Limiting

**Self-hosted instance**: Rate limiting is **DISABLED**

The `limiter: false` setting in `settings.yml` ensures unlimited API access.

## Error Responses

### 403 Forbidden
- **Cause**: JSON format not enabled
- **Fix**: Check `settings.yml` has `formats: [json]`

### 429 Too Many Requests
- **Cause**: Rate limiting triggered
- **Fix**: Should not occur on self-hosted with limiter disabled

### 500 Internal Server Error
- **Cause**: Engine failure or configuration issue
- **Fix**: Check Docker logs: `docker logs searxng-openclaw`

## Performance Tips

1. **Use specific engines** instead of all engines for faster results:
   ```
   engines=google,duckduckgo
   ```

2. **Limit categories** when searching specific content types:
   ```
   categories=images
   ```

3. **Cache frequent queries** in your application to reduce load

4. **Use Redis** for improved caching (optional configuration)

## Best Practices

### 1. Timeout Handling

Always set a timeout:
```python
response = requests.get(
    "http://localhost:8888/search",
    params={"q": query, "format": "json"},
    timeout=10
)
```

### 2. Error Handling

```python
try:
    response = requests.get(url, params=params, timeout=10)
    response.raise_for_status()
    data = response.json()
except requests.exceptions.ConnectionError:
    # Container not running
    handle_error()
except requests.exceptions.Timeout:
    # Request took too long
    handle_error()
except requests.exceptions.HTTPError as e:
    # HTTP error (4xx, 5xx)
    handle_error()
```

### 3. Pagination

For large result sets:
```python
all_results = []
page = 1

while True:
    results = search(query, pageno=page)
    if not results:
        break
    all_results.extend(results)
    page += 1
    if len(all_results) >= max_results:
        break
```

### 4. Engine Rotation

Distribute load across engines:
```python
engines_rotation = [
    "google,duckduckgo",
    "bing,duckduckgo",
    "google,bing"
]

# Rotate through engine combinations
engines = engines_rotation[request_count % len(engines_rotation)]
```

## Limitations

- **Results per page**: Fixed at ~20 (varies by engine)
- **No max_results parameter**: Use pagination or slice results
- **No sorting**: Results come in engine-defined order
- **Rate limits on underlying engines**: Even with limiter disabled, Google/Bing may rate limit if overused

## Docker API

### Container Management

```bash
# Check status
curl http://localhost:8888/healthz

# Metrics (if enabled)
curl http://localhost:8888/metrics
```

## Troubleshooting

### Empty Results

1. Check engines are not blocked
2. Verify query syntax
3. Check Docker logs for engine errors
4. Try different engines

### Slow Responses

1. Reduce number of engines
2. Enable Redis caching
3. Check network connectivity
4. Review resource limits

### Missing Results

1. Some engines may timeout
2. Check `unresponsive_engines` in response
3. Try specific engine only

## Additional Resources

- Official Docs: https://docs.searxng.org/
- Search Syntax: https://docs.searxng.org/user/search-syntax.html
- Admin Guide: https://docs.searxng.org/admin/
- Engine List: https://docs.searxng.org/user/configured_engines.html
