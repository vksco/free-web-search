#!/usr/bin/env python3
"""
OpenClaw + SearXNG Integration

This module provides a simple interface for OpenClaw to use SearXNG for web search.
It automatically detects the skill installation path and imports the search module.
"""

import sys
import os
from pathlib import Path

# Get the directory where this script is located
SCRIPT_DIR = Path(__file__).parent.absolute()

# Add scripts directory to Python path
sys.path.insert(0, str(SCRIPT_DIR))

# Import search function
try:
    from search import search_web
except ImportError:
    print("Error: Could not import search module. Make sure search.py exists in the scripts folder.")
    sys.exit(1)


def web_search(query, count=10):
    """
    Web search using SearXNG with automatic fallback to Tavily.
    
    This is the main function to call from OpenClaw or other applications.
    
    Args:
        query (str): Search query string
        count (int): Number of results to return (default: 10, max: 50)
    
    Returns:
        list: List of search results, each containing:
            - title (str): Page title
            - url (str): Page URL
            - snippet (str): Page snippet/description
    
    Example:
        >>> results = web_search("AI agents", count=5)
        >>> for r in results:
        ...     print(f"{r['title']}: {r['url']}")
    
    Raises:
        Exception: If search fails and no fallback is available
    """
    return search_web(query, count=count)


if __name__ == "__main__":
    # Demo/test when run directly
    import json
    
    print("SearXNG Integration Test")
    print("=" * 50)
    
    # Test search
    query = "Python async tutorial"
    print(f"\nSearching for: {query}")
    
    try:
        results = web_search(query, count=5)
        
        print(f"\nFound {len(results)} results:\n")
        
        for i, result in enumerate(results, 1):
            print(f"{i}. {result['title']}")
            print(f"   URL: {result['url']}")
            print(f"   {result['snippet'][:100]}...")
            print()
        
        print("✅ Integration working!")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        print("\nMake sure:")
        print("  1. SearXNG container is running: docker ps")
        print("  2. Port 8888 is accessible: curl http://localhost:8888")
        print("  3. search.py exists in scripts/ folder")
