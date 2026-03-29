#!/bin/bash
# Push to GitHub Script
# Run this script to push your skill to GitHub

set -e

echo "🚀 Pushing Free Web Search Skill to GitHub"
echo "=========================================="
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
    echo "❌ Git not initialized. Run 'git init' first."
    exit 1
fi

# Check if remote exists
if ! git remote | grep -q "origin"; then
    echo "➕ Adding remote repository..."
    git remote add origin https://github.com/vksco/free-web-search.git
fi

# Check current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "📍 Current branch: $CURRENT_BRANCH"

# Ensure we're on main branch
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "🔄 Switching to main branch..."
    git branch -M main
fi

echo ""
echo "📤 Pushing to GitHub..."
echo ""

# Try to push
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ SUCCESS!"
    echo ""
    echo "🎉 Your skill is now live at:"
    echo "   https://github.com/vksco/free-web-search"
    echo ""
    echo "📋 Next steps:"
    echo "   1. ⭐ Star SearXNG: https://github.com/searxng/searxng"
    echo "   2. Add to ClawHub: https://clawhub.ai"
    echo "   3. Share with the OpenClaw community!"
    echo ""
else
    echo ""
    echo "❌ Push failed!"
    echo ""
    echo "Possible solutions:"
    echo "   1. Check if you have write access to vksco/free-web-search"
    echo "   2. Set up SSH keys: https://docs.github.com/en/authentication/connecting-to-github-with-ssh"
    echo "   3. Use personal access token:"
    echo "      - Go to: https://github.com/settings/tokens"
    echo "      - Create token with 'repo' scope"
    echo "      - Run: git push https://YOUR_TOKEN@github.com/vksco/free-web-search.git main"
    echo ""
fi
