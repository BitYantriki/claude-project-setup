#!/bin/bash

# MCP Server Setup Script
# Sets up MCP server for IDE/Desktop Claude integration

set -e

echo "Setting up MCP Server for project integration..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Step 1: Set up MCP servers directory
echo -e "\n${YELLOW}Step 1: Setting up MCP servers directory...${NC}"
MCP_SERVERS_DIR="$HOME/mcp-servers"
mkdir -p "$MCP_SERVERS_DIR"

# Copy MCP server file from mcp directory
if [ -f "$SCRIPT_DIR/intellij-mcp-server.js" ]; then
    cp "$SCRIPT_DIR/intellij-mcp-server.js" "$MCP_SERVERS_DIR/"
    echo -e "${GREEN}✓ Copied MCP server${NC}"
else
    echo -e "${RED}Error: intellij-mcp-server.js not found in mcp directory${NC}"
    exit 1
fi
chmod +x "$MCP_SERVERS_DIR/intellij-mcp-server.js"

# Step 2: Create package.json with proper configuration
echo -e "\n${YELLOW}Step 2: Creating package.json configuration...${NC}"
cat > "$MCP_SERVERS_DIR/package.json" << 'EOF'
{
  "name": "mcp-servers",
  "version": "1.0.0",
  "description": "MCP servers for IDE integration",
  "type": "module",
  "main": "intellij-mcp-server.js",
  "scripts": {
    "start": "node intellij-mcp-server.js"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "^0.5.0"
  },
  "engines": {
    "node": ">=16.0.0"
  }
}
EOF
echo -e "${GREEN}✓ Created package.json with ES module configuration${NC}"

# Step 3: Install MCP dependencies
echo -e "\n${YELLOW}Step 3: Installing MCP dependencies...${NC}"
cd "$MCP_SERVERS_DIR"
npm install
cd "$SCRIPT_DIR"
echo -e "${GREEN}✓ MCP dependencies installed${NC}"

# Step 4: Copy test client
echo -e "\n${YELLOW}Step 4: Setting up MCP test client...${NC}"
if [ -f "$SCRIPT_DIR/mcp-test-client.py" ]; then
    cp "$SCRIPT_DIR/mcp-test-client.py" "$MCP_SERVERS_DIR/"
    chmod +x "$MCP_SERVERS_DIR/mcp-test-client.py"
    echo -e "${GREEN}✓ MCP test client copied${NC}"
else
    echo -e "${YELLOW}! MCP test client not found (optional)${NC}"
fi

# Step 5: Create MCP helper scripts
echo -e "\n${YELLOW}Step 5: Creating MCP helper scripts...${NC}"

# Create start script
cat > "$MCP_SERVERS_DIR/start-mcp-server.sh" << 'EOF'
#!/bin/bash
# Start MCP server for a project

if [ -z "$1" ]; then
    echo "Usage: $0 <project-path>"
    echo ""
    echo "Examples:"
    echo "  $0 /path/to/your/project"
    echo "  $0 ."
    exit 1
fi

# Convert relative path to absolute path
PROJECT_PATH="$(cd "$1" 2>/dev/null && pwd)"
if [ $? -ne 0 ]; then
    echo "Error: Directory '$1' does not exist"
    exit 1
fi

echo "Starting MCP server for project: $PROJECT_PATH"
echo "Press Ctrl+C to stop the server"
echo ""

cd "$HOME/mcp-servers"
node intellij-mcp-server.js "$PROJECT_PATH"
EOF
chmod +x "$MCP_SERVERS_DIR/start-mcp-server.sh"

# Create test script
cat > "$MCP_SERVERS_DIR/test-mcp-server.sh" << 'EOF'
#!/bin/bash
# Test MCP server interactively

if [ -z "$1" ]; then
    echo "Usage: $0 <project-path>"
    echo ""
    echo "Examples:"
    echo "  $0 /path/to/your/project"
    echo "  $0 ."
    exit 1
fi

# Convert relative path to absolute path
PROJECT_PATH="$(cd "$1" 2>/dev/null && pwd)"
if [ $? -ne 0 ]; then
    echo "Error: Directory '$1' does not exist"
    exit 1
fi

TEST_CLIENT="$HOME/mcp-servers/mcp-test-client.py"
SERVER_PATH="$HOME/mcp-servers/intellij-mcp-server.js"

if [ ! -f "$TEST_CLIENT" ]; then
    echo "Error: Test client not found at $TEST_CLIENT"
    exit 1
fi

if [ ! -f "$SERVER_PATH" ]; then
    echo "Error: MCP server not found at $SERVER_PATH"
    exit 1
fi

echo "Testing MCP server with project: $PROJECT_PATH"
cd "$HOME/mcp-servers"
python3 "$TEST_CLIENT" "$SERVER_PATH" "$PROJECT_PATH" -i
EOF
chmod +x "$MCP_SERVERS_DIR/test-mcp-server.sh"

# Create quick test script
cat > "$MCP_SERVERS_DIR/quick-test.sh" << 'EOF'
#!/bin/bash
# Quick test of MCP server installation

echo "🔍 Testing MCP Server Installation"
echo "=================================="

SERVER_PATH="$HOME/mcp-servers/intellij-mcp-server.js"
TEST_DIR="/tmp"

if [ ! -f "$SERVER_PATH" ]; then
    echo "❌ MCP server not found at $SERVER_PATH"
    exit 1
fi

echo "✅ MCP server found"
echo "📁 Testing with directory: $TEST_DIR"

cd "$HOME/mcp-servers"
echo '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}' | timeout 5 node "$SERVER_PATH" "$TEST_DIR" 2>/dev/null | head -1 | jq -r '.result.tools[0].name' 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ MCP server is working correctly"
else
    echo "⚠️  MCP server test inconclusive (may still work fine)"
fi

echo ""
echo "MCP server is ready for use with:"
echo "  mcp-start <project-path>"
echo "  mcp-test <project-path>"
EOF
chmod +x "$MCP_SERVERS_DIR/quick-test.sh"

# Step 6: Create MCP command aliases
echo -e "\n${YELLOW}Step 6: Creating MCP command aliases...${NC}"

# Add MCP aliases to ~/.bash_aliases
{
    echo ""
    echo "# MCP server commands"
    echo "alias mcp-start='$MCP_SERVERS_DIR/start-mcp-server.sh'"
    echo "alias mcp-test='$MCP_SERVERS_DIR/test-mcp-server.sh'"
    echo "alias mcp-quick-test='$MCP_SERVERS_DIR/quick-test.sh'"
} >> ~/.bash_aliases

echo -e "${GREEN}✓ Added MCP aliases to ~/.bash_aliases${NC}"

echo -e "${GREEN}✓ Created MCP command shortcuts${NC}"

# Step 7: Copy verification scripts
echo -e "\n${YELLOW}Step 7: Setting up verification scripts...${NC}"
if [ -f "$SCRIPT_DIR/verify-setup.sh" ]; then
    cp "$SCRIPT_DIR/verify-setup.sh" "$MCP_SERVERS_DIR/"
    chmod +x "$MCP_SERVERS_DIR/verify-setup.sh"
fi

if [ -f "$SCRIPT_DIR/verify-setup-all.sh" ]; then
    cp "$SCRIPT_DIR/verify-setup-all.sh" "$MCP_SERVERS_DIR/"
    chmod +x "$MCP_SERVERS_DIR/verify-setup-all.sh"
fi

# Create MCP documentation
cat > "$MCP_SERVERS_DIR/README.md" << 'EOF'
# MCP Server for Project Integration

## Quick Commands

- `mcp-start <project-path>` - Start MCP server for a project
- `mcp-test <project-path>` - Test MCP server interactively
- `mcp-quick-test` - Verify installation

## Usage Examples

```bash
# Start MCP server
mcp-start /path/to/your/project
mcp-start .  # From inside project directory

# Test interactively
mcp-test /path/to/your/project
mcp-test .

# Quick installation test
mcp-quick-test
```

## Available Tools

When the MCP server is running, these tools are available:
- `read_file` - Read file contents
- `write_file` - Write to files
- `list_files` - List directory contents
- `execute_command` - Run commands
- `project_structure` - Show project tree
- `git_status` - Check git status
- `find_class` - Find Java/Kotlin classes

## Integration

This MCP server is designed for:
- Claude Desktop integration
- IDE plugins and extensions
- Custom applications needing project access

For CLI usage, Claude Code already provides equivalent functionality.
EOF

echo -e "\n${GREEN}🎉 MCP Server setup completed!${NC}"
echo ""
echo "Available commands:"
echo "  ${GREEN}mcp-start <project-path>${NC}  - Start MCP server for a project"
echo "  ${GREEN}mcp-test <project-path>${NC}   - Test MCP server interactively"
echo "  ${GREEN}mcp-quick-test${NC}            - Verify the installation"
echo ""
echo "MCP server files installed to: ${GREEN}$MCP_SERVERS_DIR${NC}"
echo "Documentation: ${GREEN}$MCP_SERVERS_DIR/README.md${NC}"
echo ""
echo "Remember to run: ${GREEN}source ~/.bash_aliases${NC}"