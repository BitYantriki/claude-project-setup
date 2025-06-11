# Claude Code Setup

This component sets up Claude Code with MCP (Model Context Protocol) server integration for development projects.

## What it does

- Installs prerequisites (Node.js, Python packages)
- Sets up MCP server for IntelliJ/IDE integration
- Creates helper commands for project management
- Installs `new-claude` command for generating project-specific CLAUDE.md files

## Files

- `setup-all.sh` - Main setup script that orchestrates everything
- `install-prerequisites.sh` - Installs required dependencies
- `setup-claude-code.sh` - Sets up MCP server and helper commands
- `new-claude.sh` - Interactive tool to create CLAUDE.md files for projects
- `prompt_rules/` - Modular templates for different languages/frameworks/tools
- `intellij-mcp-server.js` - MCP server for IDE integration
- `verify-setup.sh` - Validates the installation

## Setup

Run the main setup script:
```bash
cd components/claude-setup
./setup-all.sh
```

This will:
1. Install prerequisites (Node.js, Python packages)
2. Set up MCP server and helper commands
3. Install the `new-claude` command
4. Add aliases to your shell

## Usage

After setup, you'll have these commands available:

- `mcp-start <project-path>` - Start MCP server for a project
- `mcp-test <project-path>` - Test MCP server interactively  
- `mcp-quick-test` - Verify the installation
- `new-claude <directory>` - Create customized CLAUDE.md for a project

## Creating Project Guidelines

Use the `new-claude` command to create customized CLAUDE.md files:

```bash
# Create new project with CLAUDE.md
new-claude my-new-project

# Add CLAUDE.md to existing project
new-claude /path/to/existing/project
```

The tool will ask about your tech stack and generate a CLAUDE.md file combining relevant guidelines from the modular templates.

## Templates

The `prompt_rules/` directory contains modular templates:

- `base.md` - General development principles (always included)
- `languages/` - Language-specific guidelines (Python, JavaScript, TypeScript, etc.)
- `frameworks/` - Framework-specific rules (React, Django, Express, etc.)
- `cloud/` - Cloud platform guidelines (AWS, GCP, etc.)
- `databases/` - Database-specific practices (PostgreSQL, MongoDB, etc.)
- `caching/` - Caching solutions (Redis, etc.)

## Requirements

- Ubuntu/Debian-based system
- Internet connection for package downloads
- Bash shell

For more detailed information about the MCP server functionality and advanced usage, see the original README sections below.