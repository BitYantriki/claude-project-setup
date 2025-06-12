# Claude Project Creator

**Create intelligent project templates with customized AI guidelines in minutes.**

This tool helps you quickly set up new projects with tailored CLAUDE.md files that give Claude context about your tech stack, coding preferences, and project requirements.

## 🚀 Quick Start (2 minutes)

### 1. Prerequisites

Install these first (click to expand for installation steps):

<details>
<summary><b>📦 Linux/Ubuntu Prerequisites</b></summary>

```bash
# Update package manager
sudo apt update

# Install Node.js 20+
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Python 3 and pip
sudo apt-get install -y python3 python3-pip python3-venv

# Verify installations
node --version  # Should show v20+
python3 --version  # Should show 3.8+
```
</details>

<details>
<summary><b>🍎 macOS Prerequisites</b></summary>

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Node.js and Python
brew install node python

# Verify installations
node --version  # Should show v18+
python3 --version  # Should show 3.8+
```
</details>

<details>
<summary><b>🪟 Windows Prerequisites</b></summary>

**Option 1: Using WSL (Recommended)**
1. Install WSL2 with Ubuntu
2. Follow the Linux/Ubuntu instructions above

**Option 2: Native Windows**
1. Download and install [Node.js](https://nodejs.org/) (v18+)
2. Download and install [Python](https://www.python.org/downloads/) (3.8+)
3. Use Git Bash or PowerShell for commands
</details>

### 2. Install & Setup

```bash
# Clone and setup
git clone <this-repo-url>
cd claude-project-setup
./setup-all.sh

# Refresh your shell
source ~/.bash_aliases
```

### 3. Create Your First Project

```bash
# Create a new project with AI guidelines
new-claude my-awesome-project

# Or add guidelines to existing project
new-claude /path/to/existing/project
```

That's it! 🎉

## ✨ What You Get

- **`new-claude` command** - Interactive project creator
- **Smart templates** - Combines tech-stack specific guidelines
- **Instant setup** - Ready to use with Claude Code in minutes
- **Customizable** - Modular template system you can extend

## 📋 How It Works

1. **Run `new-claude my-project`**
2. **Answer a few questions:**
   - Programming language (Python, JavaScript, TypeScript, etc.)
   - Framework (React, Django, Express, etc.) 
   - Cloud platform (AWS, GCP, Azure, etc.)
   - Databases (PostgreSQL, MongoDB, Redis, etc.)
   - Caching solutions
3. **Get a customized CLAUDE.md file** with relevant guidelines
4. **Start coding with Claude** using your project-specific context

## 🎯 Example Usage

```bash
# Full-stack React + Node.js project
new-claude my-fullstack-app
# → Combines: base + JavaScript + React + Express + PostgreSQL guidelines

# Python data science project  
new-claude data-analysis
# → Combines: base + Python + Django + AWS + PostgreSQL guidelines

# Add to existing project
new-claude /home/user/legacy-project
# → Creates CLAUDE.md in existing codebase
```

## 🧩 Template System

Templates are modular and cover:

- **`base.md`** - Universal development principles (always included)
- **`languages/`** - Python, JavaScript, TypeScript, Java, Go, etc.
- **`frameworks/`** - React, Django, Express, Spring, etc.
- **`cloud/`** - AWS, GCP, Azure, etc.
- **`databases/`** - PostgreSQL, MongoDB, Redis, etc.
- **`caching/`** - Redis, Memcached, etc.

## 🤖 Claude Integration Options

The setup process will detect your Claude setup and guide you:

### Option A: Claude Code CLI (Recommended)
- **Best for:** Developers with Claude Pro/API access
- **Setup:** Automatically detected and configured
- **Usage:** Just run `claude` in your project directory

### Option B: Claude Desktop + MCP Server ⚠️ (Work in Progress)
- **Best for:** Windows/Mac users without Claude Pro/API
- **Setup:** MCP server for IDE/Desktop Claude integration
- **Status:** Coming soon - basic setup available

### Option C: Manual Integration
- **Best for:** Custom setups
- **Usage:** Copy CLAUDE.md content to your preferred Claude interface

## 📁 Directory Structure

```
claude-project-setup/
├── setup-all.sh              # Main setup script
├── new-claude.sh             # Project creator (main tool)
├── install-prerequisites.sh  # Dependencies installer
├── prompt_rules/             # Modular template system
│   ├── base.md              # Core principles
│   ├── languages/           # Language-specific rules
│   ├── frameworks/          # Framework patterns
│   ├── cloud/               # Cloud platform guides
│   ├── databases/           # Database practices
│   └── caching/             # Caching strategies
└── mcp/                     # MCP server (optional)
    └── setup-mcp-server.sh # For Desktop Claude integration
```

## 🔧 Available Commands

After setup:
- `new-claude <directory>` - Create project with AI guidelines
- `mcp-start <project-path>` - Start MCP server (if installed)
- `mcp-test <project-path>` - Test MCP server
- `mcp-quick-test` - Verify MCP installation

## 🆘 Troubleshooting

### Command not found: `new-claude`
```bash
# Refresh your shell
source ~/.bash_aliases

# Or restart your terminal
```

### Prerequisites missing
```bash
# Re-run prerequisites installation
./install-prerequisites.sh
```

### Need help?
```bash
# Show usage
new-claude --help

# Check what's installed
which new-claude
node --version
python3 --version
```

## 🎯 Use Cases

- **Starting new projects** with proper AI context
- **Adding AI guidelines** to existing codebases  
- **Team onboarding** with consistent project standards
- **Multi-stack development** with stack-specific templates
- **Client projects** with customized coding standards

## 🚧 Roadmap

- [ ] **Enhanced MCP Integration** - Full Desktop Claude support
- [ ] **VS Code Extension** - Direct integration with popular IDE
- [ ] **Team Templates** - Shared organizational guidelines
- [ ] **Git Hooks** - Auto-update CLAUDE.md on stack changes
- [ ] **More Templates** - Additional languages and frameworks

---

**Start creating better projects with Claude! 🚀**

*Got questions? Check the troubleshooting section or run `new-claude --help`*