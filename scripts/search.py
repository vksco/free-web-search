#!/usr/bin/env python3
"""
SearXNG Search Function for OpenClaw
Provides web search with automatic fallback to Tavily
"""

import os
import json
import time
import logging
from typing import List, Dict, Optional
from pathlib import Path
import subprocess

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configuration
SEARXNG_URL = os.environ.get("SEARXNG_URL", "http://localhost:8888")
TAVILY_API_KEY = os.environ.get("TAVILY_API_KEY", "")
DEFAULT_ENGINES = "google,duckduckgo,bing"
DEFAULT_TIMEOUT = 10
MAX_RETRIES = 2

# Paths
SKILL_DIR = Path(__file__).parent.parent
DOCKER_MANAGER = SKILL_DIR / "scripts" / "docker-manager.sh"


def ensure_searxng_running() -> bool:
    """Check if SearXNG is running, attempt to start if not"""
    try:
        # Check status
        result = subprocess.run(
            ["bash", str(DOCKER_MANAGER), "status"],
            capture_output=True,
            text=True
        )
        
        if "running" in result.stdout:
            return True
        
        # Try to start
        logger.info("SearXNG not running, attempting to start...")
        result = subprocess.run(
            ["bash", str(DOCKER_MANAGER), "start"],
            capture_output=True,
            text=True,
            timeout=30
        )
        
        if result.returncode == 0:
            logger.info("SearXNG started successfully")
            time.sleep(2)  # Wait for it to be ready
            return True
        else:
            logger.warning(f"Failed to start SearXNG: {result.stderr}")
            return False
            
    except Exception as e:
        logger.error(f"Error checking/starting SearXNG: {e}")
        return False


def search_searxng(
    query: str,
    engines: Optional[str] = None,
    categories: Optional[str] = None,
    pageno: int = 1,
    timeout: int = DEFAULT_TIMEOUT
) -> List[Dict]:
    """
    Search using SearXNG
    
    Args:
        query: Search query
        engines: Comma-separated list of engines (default: google,duckduckgo,bing)
        categories: Search categories (optional)
        pageno: Page number for pagination
        timeout: Request timeout in seconds
    
    Returns:
        List of search results
    """
    import requests
    
    if engines is None:
        engines = DEFAULT_ENGINES
    
    params = {
        "q": query,
        "format": "json",
        "engines": engines,
        "pageno": pageno
    }
    
    if categories:
        params["categories"] = categories
    
    try:
        response = requests.get(
            f"{SEARXNG_URL}/search",
            params=params,
            timeout=timeout
        )
        response.raise_for_status()
        
        data = response.json()
        results = data.get("results", [])
        
        logger.info(f"SearXNG: Found {len(results)} results for '{query}'")
        
        # Standardize result format
        standardized = []
        for r in results:
            standardized.append({
                "title": r.get("title", ""),
                "url": r.get("url", ""),
                "content": r.get("content", ""),
                "snippet": r.get("content", "")[:200] + "...",
                "source": "searxng",
                "engine": r.get("engine", "unknown"),
                "engines": r.get("engines", [])
            })
        
        return standardized
        
    except requests.exceptions.ConnectionError:
        logger.error("SearXNG: Connection refused - container may not be running")
        raise
    except requests.exceptions.Timeout:
        logger.error("SearXNG: Request timeout")
        raise
    except requests.exceptions.HTTPError as e:
        logger.error(f"SearXNG: HTTP error {e.response.status_code}")
        raise
    except Exception as e:
        logger.error(f"SearXNG: Unexpected error: {e}")
        raise


def search_tavily(
    query: str,
    max_results: int = 10,
    search_depth: str = "basic"
) -> List[Dict]:
    """
    Search using Tavily API (fallback)
    
    Args:
        query: Search query
        max_results: Maximum number of results
        search_depth: 'basic' or 'advanced'
    
    Returns:
        List of search results
    """
    import requests
    
    if not TAVILY_API_KEY:
        raise ValueError("TAVILY_API_KEY not set in environment")
    
    try:
        response = requests.post(
            "https://api.tavily.com/search",
            json={
                "api_key": TAVILY_API_KEY,
                "query": query,
                "search_depth": search_depth,
                "max_results": max_results
            },
            timeout=DEFAULT_TIMEOUT
        )
        response.raise_for_status()
        
        data = response.json()
        results = data.get("results", [])
        
        logger.info(f"Tavily: Found {len(results)} results for '{query}'")
        
        # Standardize result format
        standardized = []
        for r in results:
            standardized.append({
                "title": r.get("title", ""),
                "url": r.get("url", ""),
                "content": r.get("content", ""),
                "snippet": r.get("content", "")[:200] + "...",
                "source": "tavily",
                "score": r.get("score", 0)
            })
        
        return standardized
        
    except Exception as e:
        logger.error(f"Tavily: Error: {e}")
        raise


def search_web(
    query: str,
    count: int = 10,
    engines: Optional[str] = None,
    categories: Optional[str] = None,
    prefer_searxng: bool = True
) -> List[Dict]:
    """
    Search the web using SearXNG with automatic fallback to Tavily
    
    Args:
        query: Search query
        count: Maximum number of results to return
        engines: Comma-separated list of engines (SearXNG only)
        categories: Search categories (SearXNG only)
        prefer_searxng: Try SearXNG first (default: True)
    
    Returns:
        List of search results (standardized format)
    
    Example:
        >>> results = search_web("AI agents 2024", count=5)
        >>> for r in results:
        ...     print(r['title'], r['url'])
    """
    results = []
    source_used = None
    
    # Try SearXNG first (if preferred)
    if prefer_searxng:
        try:
            # Ensure container is running
            if ensure_searxng_running():
                results = search_searxng(
                    query=query,
                    engines=engines,
                    categories=categories
                )
                source_used = "searxng"
        except Exception as e:
            logger.warning(f"SearXNG failed, falling back to Tavily: {e}")
    
    # Fall back to Tavily if SearXNG failed or not preferred
    if not results:
        try:
            results = search_tavily(
                query=query,
                max_results=count
            )
            source_used = "tavily"
        except Exception as e:
            logger.error(f"Tavily also failed: {e}")
            raise RuntimeError(
                f"Both SearXNG and Tavily failed. "
                f"SearXNG error: container may not be running. "
                f"Tavily error: {str(e) if TAVILY_API_KEY else 'TAVILY_API_KEY not set'}"
            )
    
    # Limit results
    results = results[:count]
    
    # Log search
    logger.info(f"Search completed: '{query}' → {len(results)} results via {source_used}")
    
    # Add metadata
    for r in results:
        r["query"] = query
        r["timestamp"] = time.time()
    
    return results


# CLI interface for testing
if __name__ == "__main__":
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python search.py <query> [count]")
        sys.exit(1)
    
    query = sys.argv[1]
    count = int(sys.argv[2]) if len(sys.argv) > 2 else 10
    
    print(f"Searching for: {query}")
    print("=" * 60)
    
    try:
        results = search_web(query, count=count)
        
        for i, r in enumerate(results, 1):
            print(f"\n{i}. {r['title']}")
            print(f"   URL: {r['url']}")
            print(f"   Source: {r['source']}")
            print(f"   Snippet: {r['snippet']}")
            
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
