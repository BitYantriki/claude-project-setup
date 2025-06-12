#!/bin/bash

# Claude Project Creator - Main Setup Script
# Creates intelligent project templates with customized AI guidelines

set -e

echo "🚀 Claude Project Creator Setup"
echo "================================="
echo "Create intelligent project templates with customized AI guidelines in minutes."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(pwd)"
cd "$SCRIPT_DIR"

# Function to check if Claude Code is installed
check_claude_code() {
    if command -v claude &> /dev/null; then
        echo -e "${GREEN}✓ Claude Code CLI detected${NC}"
        return 0
    else
        echo -e "${YELLOW}! Claude Code CLI not found${NC}"
        return 1
    fi
}

# Function to detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "macos";;
        CYGWIN*|MINGW*|MSYS*) echo "windows";;
        *)          echo "unknown";;
    esac
}

echo -e "\n${BLUE}🔍 Checking your environment...${NC}"

# Check required files
echo -e "\n${YELLOW}Checking required files...${NC}"

CORE_FILES=(
    "install-prerequisites.sh"
    "setup-claude-code.sh" 
    "new-claude.py"
)

MISSING_CORE=()
for file in "${CORE_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓ Found: $file${NC}"
    else
        MISSING_CORE+=("$file")
        echo -e "${RED}✗ Missing: $file${NC}"
    fi
done

if [ ${#MISSING_CORE[@]} -gt 0 ]; then
    echo -e "\n${RED}Error: Missing essential files!${NC}"
    echo "Required files:"
    for file in "${MISSING_CORE[@]}"; do
        echo "  - $file"
    done
    exit 1
fi

# Make scripts executable
chmod +x install-prerequisites.sh setup-claude-code.sh new-claude.py
if [ -f "mcp/setup-mcp-server.sh" ]; then chmod +x mcp/setup-mcp-server.sh; fi

# Detect OS
OS=$(detect_os)
echo -e "${GREEN}✓ Detected OS: $OS${NC}"

# Check Claude Code installation
echo -e "\n${BLUE}🤖 Checking Claude setup...${NC}"

CLAUDE_DETECTED=false
if check_claude_code; then
    CLAUDE_DETECTED=true
    echo -e "${GREEN}Great! You have Claude Code CLI installed.${NC}"
else
    echo -e "\n${YELLOW}Claude Code CLI not detected.${NC}"
    echo ""
    echo "Choose your Claude setup approach:"
    echo ""
    echo "  ${GREEN}A) Auto-install Claude Code CLI${NC} (Recommended)"
    echo "     • Automatically installs Claude Code CLI via npm"
    echo "     • Best for developers with Claude Pro/API access"
    echo "     • Most features and fastest performance"
    echo ""
    echo "  ${YELLOW}B) Claude Desktop + MCP Server${NC} ⚠️ (Work in Progress)"
    echo "     • Best for Windows/Mac users without Claude Pro/API"  
    echo "     • Basic MCP setup available now"
    echo "     • Full integration coming soon"
    echo ""
    echo "  ${BLUE}C) Manual Integration${NC}"
    echo "     • For custom setups"
    echo "     • Copy CLAUDE.md content to your preferred Claude interface"
    echo ""
    echo "  ${RED}0) Skip Claude setup${NC}"
    echo "     • Continue without Claude Code installation"
    echo ""
    
    while true; do
        read -p "Which option would you like? [A/B/C/0]: " choice
        case $choice in
            [Aa]* )
                echo -e "\n${GREEN}Setting up Claude Code CLI with auto-installation...${NC}"
                echo ""
                echo "This will:"
                echo "1. Check for Node.js/npm prerequisites"
                echo "2. Install Claude Code CLI automatically"
                echo "3. Set up the project creator tool"
                echo ""
                echo -e "${YELLOW}Note: You'll still need Claude Pro or API access to use Claude Code.${NC}"
                echo "Visit https://claude.ai to sign up if you haven't already."
                echo ""
                break
                ;;
            [Bb]* )
                echo -e "\n${YELLOW}Setting up Claude Desktop + MCP Server...${NC}"
                echo ""
                echo "⚠️  Note: Full MCP integration is work in progress."
                echo "Basic MCP server setup will be included."
                echo ""
                break
                ;;
            [Cc]* )
                echo -e "\n${BLUE}Setting up for manual integration...${NC}"
                echo ""
                echo "You'll be able to:"
                echo "• Create CLAUDE.md files with the new-claude command"
                echo "• Copy content to your preferred Claude interface"
                echo ""
                break
                ;;
            [0]* )
                echo -e "\n${RED}Skipping Claude setup...${NC}"
                echo ""
                echo "You can still use the project creator to generate CLAUDE.md files"
                echo "and use them manually with any Claude interface."
                echo ""
                break
                ;;
            * )
                echo "Please answer A, B, C, or 0."
                ;;
        esac
    done
fi

# Install prerequisites
echo -e "\n${GREEN}📦 Step 1: Installing prerequisites...${NC}"
./install-prerequisites.sh

# Run main setup
echo -e "\n${GREEN}⚙️  Step 2: Setting up project creator...${NC}"
./setup-claude-code.sh

# Verify installation
echo -e "\n${GREEN}✅ Step 3: Verifying installation...${NC}"
if grep -q "alias new-claude=" ~/.bash_aliases 2>/dev/null; then
    echo -e "${GREEN}✓ new-claude command installed successfully${NC}"
else
    echo -e "${YELLOW}! Warning: new-claude alias not found in ~/.bash_aliases${NC}"
fi

# Check if Claude Code CLI was installed
if command -v claude &> /dev/null; then
    echo -e "${GREEN}✓ Claude Code CLI is now available${NC}"
    CLAUDE_DETECTED=true
else
    echo -e "${YELLOW}! Claude Code CLI not detected${NC}"
fi

# Final summary
echo -e "\n${GREEN}🎉 Setup Complete!${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✨ Your Claude Project Creator is ready!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🚀 Quick Start:"
echo ""
echo "  1. Activate the command:"
echo -e "     ${BLUE}source ~/.bash_aliases${NC}"
echo ""
echo "  2. Create your first project:"
echo -e "     ${BLUE}new-claude my-awesome-project${NC}"
echo ""
echo "  3. Follow the interactive prompts"
echo ""
echo "📋 Available Commands:"
echo -e "  ${GREEN}new-claude <directory>${NC}    - Create project with AI guidelines"

# Show MCP commands if available
if [ -f "mcp/setup-mcp-server.sh" ]; then
    echo -e "  ${GREEN}mcp-start <project-path>${NC}  - Start MCP server (Desktop Claude)"
    echo -e "  ${GREEN}mcp-test <project-path>${NC}   - Test MCP server"
    echo -e "  ${GREEN}mcp-quick-test${NC}            - Verify MCP installation"
fi

echo ""
echo "📖 Documentation:"
echo -e "  ${GREEN}$SCRIPT_DIR/README.md${NC}      - Full documentation"
echo ""

if [ "$CLAUDE_DETECTED" = true ]; then
    echo "🤖 Ready to use with Claude Code!"
    echo -e "   Run ${BLUE}claude${NC} in any project directory after creating CLAUDE.md"
else
    echo "💡 Next Steps:"
    echo "   • Install Claude Code CLI for best experience"
    echo "   • Or use manual integration with CLAUDE.md files"
fi

echo ""
echo -e "${YELLOW}⚠️  Important:${NC} Run ${GREEN}source ~/.bash_aliases${NC} to activate commands"
echo ""
echo "Happy coding with Claude! 🚀"