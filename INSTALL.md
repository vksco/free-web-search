# Installation Guide - Free Web Search Skill

## 🤖 One-Prompt Auto-Install (Recommended)

Just copy this prompt and give it to your AI agent:

---

### For Claude / ChatGPT / Gemini / Pi:

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

### For Codex / Claude Code / Cursor / OpenCode:

```
Install free-web-search skill from GitHub repo vksco/free-web-search

Steps:
1. Check if Docker is installed and running, install if needed
2. Clone https://github.com/vksco/free-web-search to ~/.openclaw/workspace/skills/free-web-search
3. Make scripts executable: chmod +x scripts/*.sh
4. Run: bash scripts/docker-manager.sh start
5. Wait for container to be ready (health check)
6. Test: curl 'http://localhost:8888/search?q=test&format=json'
7. Report success with sample results

Use your tool permissions to install packages if needed.
```

---

### For OpenClaw Users:

Just say in your conversation:

```
Install the free-web-search skill from vksco/free-web-search
```

OpenClaw will automatically:
- ✅ Clone the repository
- ✅ Install dependencies
- ✅ Start the container
- ✅ Test the installation

---

## 📋 What Your AI Agent Will Do

1. **Check Docker** - Verify Docker is installed and running
2. **Clone Repository** - Download from GitHub
3. **Setup Permissions** - Make scripts executable
4. **Start Container** - Launch SearXNG Docker container
5. **Verify Installation** - Test with sample search
6. **Report Results** - Show you it's working

**Total time:** 2-5 minutes (mostly Docker image download)

---

## ✅ Verify Installation

After your agent completes, verify:

```bash
# Check container is running
docker ps | grep searxng

# Test search (should return JSON)
curl 'http://localhost:8888/search?q=test&format=json'

# Check skill status
cd ~/.openclaw/workspace/skills/free-web-search
bash scripts/docker-manager.sh status
```

---

## 🔧 Manual Installation

If you prefer to install manually:

### Step 1: Prerequisites

```bash
# Check Docker is installed
docker --version

# If not installed, install Docker Desktop:
# macOS: https://docs.docker.com/desktop/install/mac-install/
# Linux: https://docs.docker.com/engine/install/
# Windows: https://docs.docker.com/desktop/install/windows-install/
```

### Step 2: Clone Repository

```bash
# Create skills directory if needed
mkdir -p ~/.openclaw/workspace/skills

# Clone the skill
cd ~/.openclaw/workspace/skills
git clone https://github.com/vksco/free-web-search.git
cd free-web-search
```

### Step 3: Setup Permissions

```bash
# Make scripts executable
chmod +x scripts/*.sh
```

### Step 4: Start Container

```bash
# Start SearXNG
bash scripts/docker-manager.sh start

# Wait for it to be ready (about 10-20 seconds)
sleep 20
```

### Step 5: Test

```bash
# Test search
curl 'http://localhost:8888/search?q=hello%20world&format=json'

# Should return JSON with results
```

---

## 🆘 Troubleshooting

### Docker not installed

Your AI agent should handle this automatically. If manual:

```bash
# macOS
brew install --cask docker

# Linux (Ubuntu/Debian)
curl -fsSL https://get.docker.com | sh

# Then start Docker Desktop or Docker daemon
```

### Port 8888 already in use

```bash
# Check what's using port 8888
lsof -i :8888

# Kill the process if needed, or change port in docker/settings.yml
```

### Container won't start

```bash
# Check Docker logs
docker logs searxng-openclaw

# Restart Docker daemon
# macOS: Restart Docker Desktop
# Linux: sudo systemctl restart docker
```

### Permission denied

```bash
# Make sure scripts are executable
chmod +x scripts/*.sh

# If Docker permission issues (Linux)
sudo usermod -aG docker $USER
# Log out and back in
```

---

## 📊 Installation Checklist

- [ ] Docker installed and running
- [ ] Repository cloned to `~/.openclaw/workspace/skills/free-web-search`
- [ ] Scripts are executable (`ls -la scripts/`)
- [ ] Container running (`docker ps | grep searxng`)
- [ ] Search works (`curl http://localhost:8888/search?q=test&format=json`)
- [ ] Auto-update configured (optional)

---

## 🎯 After Installation

Once installed, you can:

1. **Use in OpenClaw** - Just ask "search for..."
2. **Use via API** - `curl http://localhost:8888/search?q=your_query&format=json`
3. **Use in Python** - Import `scripts/search.py`
4. **Configure auto-updates** - See `AUTO_UPDATE.md`

---

## 💡 Pro Tips

1. **Bookmark this page** - Easy to copy the install prompt
2. **Share with team** - They can use the same prompt
3. **Star on GitHub** - Help others discover this
4. **Configure cron** - Auto-update every hour (optional)

---

## 📞 Need Help?

- **GitHub Issues**: https://github.com/vksco/free-web-search/issues
- **SearXNG Docs**: https://docs.searxng.org/
- **OpenClaw Discord**: https://discord.com/invite/clawd

---

**Made with ❤️ for the AI community**

Installation should be simple. If it's not, please open an issue!
