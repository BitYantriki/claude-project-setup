#!/bin/bash

# Claude Code Setup Script
# Sets up Claude Code environment and project creation tools

set -e

echo "Setting up Claude Code development environment..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Step 1: Install prerequisites
echo -e "\n${YELLOW}Step 1: Installing prerequisites...${NC}"
if [ -f "$SCRIPT_DIR/install-prerequisites.sh" ]; then
    echo "Running prerequisites installation..."
    "$SCRIPT_DIR/install-prerequisites.sh"
else
    echo "Prerequisites script not found. Running inline installation..."
    # Inline prerequisites installation if script is missing
    sudo apt-get update
    if ! command -v node &> /dev/null; then
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
    if ! command -v python3 &> /dev/null; then
        sudo apt-get install -y python3 python3-pip python3-venv
    fi
fi
echo -e "${GREEN}✓ Prerequisites installed${NC}"

# Step 2: Set up MCP server (for IDE/Desktop Claude integration)
echo -e "\n${YELLOW}Step 2: Setting up MCP server...${NC}"
if [ -f "$SCRIPT_DIR/mcp/setup-mcp-server.sh" ]; then
    echo "Running MCP server setup..."
    "$SCRIPT_DIR/mcp/setup-mcp-server.sh"
else
    echo -e "${YELLOW}! MCP setup script not found, skipping MCP server setup${NC}"
fi

# Step 3: Set up new-claude command
echo -e "\n${YELLOW}Step 3: Setting up new-claude command...${NC}"
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

# Ensure ~/.local/bin is in PATH
if ! echo "$PATH" | grep -q "$LOCAL_BIN"; then
    echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> ~/.bashrc
    echo -e "${GREEN}✓ Added ~/.local/bin to PATH in ~/.bashrc${NC}"
fi

# Create new-claude command
if [ -f "$SCRIPT_DIR/new-claude.sh" ]; then
    # Create a wrapper script that calls the actual new-claude.sh
    cat > "$LOCAL_BIN/new-claude" << EOF
#!/bin/bash
exec "$SCRIPT_DIR/new-claude.sh" "\$@"
EOF
    chmod +x "$LOCAL_BIN/new-claude"
    echo -e "${GREEN}✓ Created new-claude command${NC}"
else
    echo -e "${RED}! new-claude.sh not found${NC}"
fi

# Step 4: Create documentation
echo -e "\n${YELLOW}Step 4: Creating documentation...${NC}"
cat > "$HOME/claude-setup-guide.md" << 'EOF'
# Claude Code Setup Guide

## Available Commands

### Project Creation
- `new-claude <directory>` - Create customized CLAUDE.md for a project
  - For new projects: `new-claude my-project` (creates directory)
  - For existing projects: `new-claude /path/to/existing`

### MCP Server (for IDE/Desktop Claude integration)
- `mcp-start <project-path>` - Start MCP server for a project
- `mcp-test <project-path>` - Test MCP server interactively
- `mcp-quick-test` - Verify MCP installation

## Creating Project Guidelines

The `new-claude` command helps you create customized CLAUDE.md files by:
1. Asking about your tech stack (language, framework, cloud, databases)
2. Combining relevant templates from the modular rule system
3. Creating a comprehensive guidelines file for Claude to follow

## Templates

The prompt rules are modular and cover:
- **Base**: General development principles (always included)
- **Languages**: Python, JavaScript, TypeScript, etc.
- **Frameworks**: React, Django, Express, etc.
- **Cloud**: AWS, GCP, Azure, etc.
- **Databases**: PostgreSQL, MongoDB, Redis, etc.

## Usage Examples

```bash
# Create new project with guidelines
new-claude my-web-app

# Add guidelines to existing project
new-claude /home/user/existing-project

# Start MCP server for IDE integration
mcp-start /home/user/my-project

# Test MCP server
mcp-test /home/user/my-project
```

## Integration

- **Claude Code CLI**: Already has equivalent functionality built-in
- **Claude Desktop**: Use MCP server for project access
- **IDEs**: Use MCP server for Claude integration

## Next Steps

1. Run `new-claude --help` to see usage options
2. Create CLAUDE.md files for your projects
3. Use MCP server if you need IDE/Desktop integration

Remember to run `source ~/.bashrc` to refresh your shell!
EOF

echo -e "${GREEN}✓ Created setup guide at ~/claude-setup-guide.md${NC}"

# Final summary
echo -e "\n${GREEN}🎉 Claude Code setup completed!${NC}"
echo ""
echo "Available commands:"
echo "  ${GREEN}new-claude <directory>${NC}    - Create CLAUDE.md for a project"
echo "  ${GREEN}mcp-start <project-path>${NC}  - Start MCP server (IDE integration)"
echo "  ${GREEN}mcp-test <project-path>${NC}   - Test MCP server interactively"
echo "  ${GREEN}mcp-quick-test${NC}            - Verify MCP installation"
echo ""
echo "Documentation: ${GREEN}~/claude-setup-guide.md${NC}"
echo ""
echo "Remember to run: ${GREEN}source ~/.bashrc${NC}"
echo ""
echo "Start creating better projects with Claude! 🚀"