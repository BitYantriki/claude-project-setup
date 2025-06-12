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
if [ -f "$HOME/.local/bin/mcp-start" ] && [ -f "$HOME/.local/bin/mcp-test" ]; then
    echo -e "${GREEN}✓ Helper scripts installed${NC}"
else
    echo -e "${YELLOW}! Helper scripts not found in PATH${NC}"
fi

echo ""
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed!${NC}"
    echo ""
    echo "How to use the MCP server:"
    echo ""
    echo "1. Start the server:"
    echo "   mcp-start /path/to/your/project"
    echo ""
    echo "2. Test the server:"
    echo "   mcp-test /path/to/your/project"
    echo ""
    echo "3. Use with Claude.ai:"
    echo "   Describe what you want to do with your project files"
    echo "   Example: 'I have a Java project at /home/user/myapp. Can you help me understand its structure?'"
    echo ""
    echo "Full documentation: ~/mcp-usage-guide.md"
else
    echo -e "${RED}❌ $ERRORS checks failed${NC}"
    echo "Please fix the issues above and run this script again."
fi
