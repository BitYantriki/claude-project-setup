# Claude Project Setup

A comprehensive toolkit for setting up Claude Code development environment and creating project-specific AI guidelines.

## What it does

- **Project Creation**: Interactive `new-claude` command for generating customized CLAUDE.md files
- **Modular Templates**: Language/framework-specific AI guidelines that combine intelligently
- **MCP Server Setup**: Optional MCP server for IDE/Desktop Claude integration
- **Prerequisites Management**: Automated installation of required dependencies

## Directory Structure

```
claude-project-setup/
├── setup-all.sh              # Main setup script
├── setup-claude-code.sh      # Core Claude setup
├── install-prerequisites.sh  # Dependencies installation
├── new-claude.sh             # Project CLAUDE.md generator
├── prompt_rules/             # Modular AI guideline templates
│   ├── base.md              # General development principles
│   ├── languages/           # Python, JavaScript, TypeScript, etc.
│   ├── frameworks/          # React, Django, Express, etc.
│   ├── cloud/               # AWS, GCP, Azure, etc.
│   ├── databases/           # PostgreSQL, MongoDB, Redis, etc.
│   └── caching/             # Redis, Memcached, etc.
└── mcp/                     # MCP server components (optional)
    ├── setup-mcp-server.sh # MCP server setup
    ├── intellij-mcp-server.js
    ├── mcp-test-client.py
    └── verify-setup*.sh
```

## Quick Setup

```bash
./setup-all.sh
```

This installs everything you need:
1. Prerequisites (Node.js, Python)
2. `new-claude` command for project creation
3. MCP server for IDE/Desktop Claude integration
4. Command-line shortcuts

## Core Features

### 🎯 Project Creation with `new-claude`

Create intelligent CLAUDE.md files tailored to your tech stack:

```bash
# Create new project with guidelines
new-claude my-web-app

# Add guidelines to existing project  
new-claude /path/to/existing/project
```

**Interactive Process:**
1. Select programming language (Python, JavaScript, TypeScript, etc.)
2. Choose framework (React, Django, Express, etc.)
3. Pick cloud platform (AWS, GCP, Azure, etc.)
4. Select databases (PostgreSQL, MongoDB, Redis, etc.)
5. Choose caching solutions

The tool combines relevant templates into a comprehensive CLAUDE.md file.

### 📋 Modular Template System

Templates are organized by category:
- **`base.md`** - Universal development principles
- **`languages/`** - Language-specific best practices  
- **`frameworks/`** - Framework conventions and patterns
- **`cloud/`** - Cloud platform guidelines
- **`databases/`** - Database-specific practices
- **`caching/`** - Caching strategies and tools

### 🔌 MCP Server (Optional)

For IDE/Desktop Claude integration:

```bash
# Start MCP server for a project
mcp-start /path/to/project

# Test interactively
mcp-test /path/to/project

# Verify installation
mcp-quick-test
```

**Note**: Claude Code CLI already provides equivalent functionality built-in.

## Available Commands

After setup:
- `new-claude <directory>` - Create project-specific CLAUDE.md
- `mcp-start <project-path>` - Start MCP server (IDE integration)
- `mcp-test <project-path>` - Test MCP server interactively
- `mcp-quick-test` - Verify MCP installation

## Use Cases

### For Claude Code CLI Users
- Use `new-claude` to create project-specific guidelines
- Skip MCP server (redundant with Claude Code's built-in capabilities)

### For Claude Desktop Users  
- Use `new-claude` for project guidelines
- Use MCP server for direct project file access

### For IDE Integration
- Set up MCP server for Claude integration in your IDE
- Use `new-claude` for consistent project conventions

## Examples

```bash
# Full-stack React + Node.js project
new-claude my-fullstack-app
# -> Combines: base + JavaScript + React + Express + PostgreSQL rules

# Python data science project  
new-claude data-analysis
# -> Combines: base + Python + Django + AWS + PostgreSQL rules

# Existing project
new-claude /home/user/legacy-project
# -> Adds CLAUDE.md to existing codebase
```

## Requirements

- Linux/macOS with Bash
- Internet connection for package downloads
- sudo privileges for prerequisite installation

## Documentation

After setup, see `~/claude-setup-guide.md` for detailed usage instructions.