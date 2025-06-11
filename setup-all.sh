#!/bin/bash

# THIS IS THE CORRECT SETUP-ALL.SH FILE - UPDATED VERSION
# Master Setup Script for Claude Code on Ubuntu
# This script ensures all files are present and properly set up

set -e

echo "🚀 Claude Code Complete Setup"
echo "============================="

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Use current directory
SCRIPT_DIR="$(pwd)"
cd "$SCRIPT_DIR"

echo -e "\n${YELLOW}Checking required files...${NC}"

# List of required files with their expected names after download
REQUIRED_FILES=(
    "install-prerequisites.sh"
    "setup-claude-code.sh"
    "intellij-mcp-server.js"
    "mcp-test-client.py"
)

# Alternative names that might be downloaded
declare -A ALT_NAMES=(
    ["install-prerequisites.sh"]="install-prerequisites.txt"
    ["setup-claude-code.sh"]="setup-claude-code.txt"
    ["mcp-test-client.py"]="mcp-test-client.txt"
    ["setup-all.sh"]="master-setup-script.txt"
)

# Function to check and rename files
check_and_rename_file() {
    local expected_name="$1"

    if [ -f "$expected_name" ]; then
        echo -e "${GREEN}✓ Found: $expected_name${NC}"
        return 0
    fi

    # Check alternative names
    if [ -n "${ALT_NAMES[$expected_name]}" ]; then
        for alt_name in ${ALT_NAMES[$expected_name]}; do
            if [ -f "$alt_name" ]; then
                echo -e "${YELLOW}→ Renaming $alt_name to $expected_name${NC}"
                mv "$alt_name" "$expected_name"
                return 0
            fi
        done
    fi

    return 1
}

# Check if all files exist (with renaming support)
MISSING_FILES=()
for file in "${REQUIRED_FILES[@]}"; do
    if ! check_and_rename_file "$file"; then
        MISSING_FILES+=("$file")
        echo -e "${RED}✗ Missing: $file${NC}"
    fi
done

# Check for this script with its alternative name
if [ ! -f "setup-all.sh" ] && [ -f "master-setup-script.txt" ]; then
    echo -e "${YELLOW}→ Renaming master-setup-script.txt to setup-all.sh${NC}"
    mv master-setup-script.txt setup-all.sh
fi

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    echo -e "\n${RED}Error: Missing required files!${NC}"
    echo "Please ensure all artifact files are saved in the current directory:"
    for file in "${MISSING_FILES[@]}"; do
        echo "  - $file"
    done
    echo -e "\n${YELLOW}Note: Files may download with .txt extension. They will be renamed automatically if found.${NC}"
    exit 1
fi

# Make all scripts executable
echo -e "\n${YELLOW}Making scripts executable...${NC}"
chmod +x install-prerequisites.sh
chmod +x setup-claude-code.sh
chmod +x mcp-test-client.py
chmod +x intellij-mcp-server.js

# Run the setup
echo -e "\n${YELLOW}Starting setup process...${NC}"

# Step 1: Install prerequisites
echo -e "\n${GREEN}Step 1: Installing prerequisites...${NC}"
./install-prerequisites.sh

# Step 2: Run main setup
echo -e "\n${GREEN}Step 2: Running main setup...${NC}"
./setup-claude-code.sh

# Add new-claude alias to bashrc
echo -e "\n${YELLOW}Setting up new-claude command...${NC}"
if ! grep -q "alias new-claude=" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Claude project configuration generator" >> ~/.bashrc
    echo "alias new-claude='$SCRIPT_DIR/new-claude.sh'" >> ~/.bashrc
    echo -e "${GREEN}✓ Added new-claude alias to ~/.bashrc${NC}"
else
    echo -e "${YELLOW}✓ new-claude alias already exists in ~/.bashrc${NC}"
fi

# Create verification script
echo -e "\n${YELLOW}Creating verification script...${NC}"
cat > verify-setup.sh << 'EOF'
#!/bin/bash

# Verification script for Claude Code setup

echo "🔍 Verifying Claude Code Setup..."
echo "================================"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERRORS=0

# Check Node.js
if command -v node &> /dev/null; then
    echo -e "${GREEN}✓ Node.js: $(node --version)${NC}"
else
    echo -e "${RED}✗ Node.js not installed${NC}"
    ((ERRORS++))
fi

# Check Python
if command -v python3 &> /dev/null; then
    echo -e "${GREEN}✓ Python: $(python3 --version)${NC}"
else
    echo -e "${RED}✗ Python3 not installed${NC}"
    ((ERRORS++))
fi

# Check MCP server
if [ -f "$HOME/mcp-servers/intellij-mcp-server.js" ]; then
    echo -e "${GREEN}✓ MCP server installed${NC}"
else
    echo -e "${RED}✗ MCP server not found${NC}"
    ((ERRORS++))
fi

# Check for helper scripts
if [ -f "$HOME/.local/bin/mcp-start" ] && [ -f "$HOME/.local/bin/mcp-test" ] && [ -f "$HOME/.local/bin/mcp-quick-test" ]; then
    echo -e "${GREEN}✓ Helper commands installed${NC}"
else
    echo -e "${YELLOW}! Helper commands not found in PATH${NC}"
fi

# Run quick test
echo ""
echo "Running quick test..."
if [ -f "$HOME/mcp-servers/quick-test.sh" ]; then
    if $HOME/mcp-servers/quick-test.sh; then
        echo -e "${GREEN}✓ MCP server is working correctly${NC}"
    else
        echo -e "${YELLOW}! MCP server test failed (setup completed anyway)${NC}"
    fi
else
    echo -e "${YELLOW}! Quick test not available yet${NC}"
fi

echo ""
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed!${NC}"
    echo ""
    echo "Quick commands available:"
    echo "  ${GREEN}mcp-start <project>${NC} - Start MCP server"
    echo "  ${GREEN}mcp-test <project>${NC}  - Test interactively"
    echo "  ${GREEN}mcp-quick-test${NC}      - Verify installation"
    echo ""
    echo "Everything is pre-configured. You never need to access ~/mcp-servers directly."
    echo ""
    echo "With Claude.ai: Just describe what you want to do with your project files."
    echo ""
    echo "Don't forget: ${GREEN}source ~/.bashrc${NC}"
    echo ""
    echo "Documentation: ${GREEN}~/mcp-servers/README.md${NC}"
else
    echo -e "${RED}❌ $ERRORS checks failed${NC}"
    echo "Please fix the issues above and run this script again."
fi
EOF

chmod +x verify-setup.sh

# Final instructions
echo -e "\n${GREEN}🎉 Setup complete!${NC}"
echo ""
echo -e "${YELLOW}MCP Server Setup Complete${NC}"
echo ""
echo "Everything has been configured automatically in ~/mcp-servers/"
echo "You never need to access that directory directly."
echo ""
echo "Available commands:"
echo "  ${GREEN}mcp-start <project-path>${NC}  - Start MCP server for a project"
echo "  ${GREEN}mcp-test <project-path>${NC}   - Test MCP server interactively"
echo "  ${GREEN}mcp-quick-test${NC}            - Verify the installation"
echo "  ${GREEN}new-claude <directory>${NC}    - Create CLAUDE.md for a project"
echo ""
echo "Usage examples:"
echo "  mcp-start ~/projects/MyApp"
echo "  mcp-test ~/projects/MyApp"
echo "  new-claude ~/projects/MyApp"
echo ""
echo "With Claude.ai:"
echo "  Just describe what you want: 'Show me the structure of my project at /home/user/project'"
echo ""
echo -e "${YELLOW}IMPORTANT:${NC} Run this command to activate the shortcuts:"
echo -e "  ${GREEN}source ~/.bashrc${NC}"
echo ""
echo "Documentation: ~/mcp-servers/README.md"
echo ""
echo -e "${GREEN}That's it! Everything is ready to use. 🚀${NC}"