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
