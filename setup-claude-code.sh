#!/bin/bash

# Claude Project Creator - Core Setup Script
# Sets up the new-claude command for creating intelligent project templates

set -e

echo "Setting up Claude Project Creator..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Step 1: Install prerequisites (if not already done)
echo -e "\n${YELLOW}Step 1: Checking prerequisites...${NC}"
if [ -f "$SCRIPT_DIR/install-prerequisites.sh" ]; then
    echo "Running prerequisites check..."
    "$SCRIPT_DIR/install-prerequisites.sh"
else
    echo "Prerequisites script not found. Checking manually..."
    if ! command -v node &> /dev/null; then
        echo -e "${RED}Node.js not found. Please install Node.js first.${NC}"
        exit 1
    fi
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}Python3 not found. Please install Python3 first.${NC}"
        exit 1
    fi
fi
echo -e "${GREEN}✓ Prerequisites checked${NC}"

# Step 1.5: Install Claude Code CLI if not present
echo -e "\n${YELLOW}Step 1.5: Checking Claude Code CLI...${NC}"
if command -v claude &> /dev/null; then
    echo -e "${GREEN}✓ Claude Code CLI already installed${NC}"
else
    echo "Claude Code CLI not found. Installing..."
    
    # Check if npm is available
    if command -v npm &> /dev/null; then
        echo "Installing Claude Code CLI via npm..."
        npm install -g @anthropic-ai/claude-code
        
        if command -v claude &> /dev/null; then
            echo -e "${GREEN}✓ Claude Code CLI installed successfully${NC}"
        else
            echo -e "${YELLOW}! Claude Code CLI installation may have failed${NC}"
            echo "Please visit https://claude.ai/code for manual installation instructions"
        fi
    else
        echo -e "${YELLOW}! npm not found. Cannot auto-install Claude Code CLI${NC}"
        echo "Please install Node.js/npm first, or visit https://claude.ai/code for installation instructions"
    fi
fi

# Step 2: Set up new-claude command
echo -e "\n${YELLOW}Step 2: Installing new-claude command...${NC}"

# Create ~/.bash_aliases if it doesn't exist
if [ ! -f ~/.bash_aliases ]; then
    touch ~/.bash_aliases
    echo -e "${GREEN}✓ Created ~/.bash_aliases${NC}"
fi

# Add new-claude alias to ~/.bash_aliases
if [ -f "$SCRIPT_DIR/new-claude.py" ]; then
    if ! grep -q "alias new-claude=" ~/.bash_aliases 2>/dev/null; then
        {
            echo ""
            echo "# Claude Project Creator"
            echo "alias new-claude='python3 $SCRIPT_DIR/new-claude.py'"
        } >> ~/.bash_aliases
        echo -e "${GREEN}✓ Added new-claude command to ~/.bash_aliases${NC}"
    else
        echo -e "${YELLOW}✓ new-claude command already exists in ~/.bash_aliases${NC}"
        echo -e "${YELLOW}Note: If upgrading from shell version, manually remove old alias and re-run setup${NC}"
    fi
else
    echo -e "${RED}! new-claude.py not found${NC}"
    exit 1
fi

# Step 3: Optional MCP Server setup (for Desktop Claude integration)
echo -e "\n${YELLOW}Step 3: Checking MCP server setup...${NC}"
if [ -f "$SCRIPT_DIR/mcp/setup-mcp-server.sh" ]; then
    echo "MCP server setup available."
    echo "Note: MCP server is for Claude Desktop integration (optional)."
    echo "Run mcp/setup-mcp-server.sh separately if needed."
    echo -e "${GREEN}✓ MCP setup available (optional)${NC}"
else
    echo -e "${YELLOW}! MCP setup not available (this is fine for most users)${NC}"
fi

# Step 4: Verify template system
echo -e "\n${YELLOW}Step 4: Verifying template system...${NC}"
if [ -d "$SCRIPT_DIR/prompt_rules" ]; then
    template_count=$(find "$SCRIPT_DIR/prompt_rules" -name "*.md" | wc -l)
    echo -e "${GREEN}✓ Found $template_count template files${NC}"
else
    echo -e "${RED}! Template directory not found${NC}"
    exit 1
fi

# Final summary
echo -e "\n${GREEN}🎉 Claude Project Creator setup completed!${NC}"
echo ""
echo "Available commands:"
echo -e "  ${GREEN}new-claude <directory>${NC}    - Create project with AI guidelines"

# Show MCP commands if available
if [ -f "$SCRIPT_DIR/mcp/setup-mcp-server.sh" ]; then
    echo ""
    echo "Optional MCP commands (for Desktop Claude):"
    echo -e "  ${GREEN}mcp-start <project-path>${NC}  - Start MCP server"
    echo -e "  ${GREEN}mcp-test <project-path>${NC}   - Test MCP server"
    echo -e "  ${GREEN}mcp-quick-test${NC}            - Verify MCP installation"
    echo ""
    echo -e "${YELLOW}Note:${NC} Run ./mcp/setup-mcp-server.sh to set up MCP integration"
fi

echo ""
echo -e "Documentation: ${GREEN}$SCRIPT_DIR/README.md${NC}"
echo ""
echo -e "Remember to run: ${GREEN}source ~/.bash_aliases${NC}"
echo ""
echo "Start creating intelligent projects with Claude! 🚀"