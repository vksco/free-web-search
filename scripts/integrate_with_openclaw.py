# OpenClaw + SearXNG Integration

Import sys
import os
sys.path.insert(0, '/Users/vikashsharma/.openclaw/workspace/skills/searxng-integration/scripts')

from search import search_web

def web_search(query, count=10):
    """
    Web search using SearXNG with automatic fallback to Tavily.
    
    Args:
        query: Search query
        count: Number of results (default 10)
    
    Returns:
        List of search results with title, url, and snippet
    """
    return search_web(query, count=count)

