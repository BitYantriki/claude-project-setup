#!/bin/bash

# MCP Server Setup for IntelliJ Projects
# Sets up MCP server as a standalone tool with all configurations

set -e

echo "Setting up MCP Server for IntelliJ projects..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Use current directory as source
CURRENT_DIR="$(pwd)"

# Step 1: Check if prerequisites script exists and run it
echo -e "\n${YELLOW}Step 1: Checking prerequisites...${NC}"
if [ -f "$CURRENT_DIR/install-prerequisites.sh" ]; then
    echo "Prerequisites script found in current directory"
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

# Step 2: Set up MCP servers directory
echo -e "\n${YELLOW}Step 2: Setting up MCP servers directory...${NC}"
MCP_SERVERS_DIR="$HOME/mcp-servers"
mkdir -p "$MCP_SERVERS_DIR"

# Copy MCP server file from current directory
if [ -f "$CURRENT_DIR/intellij-mcp-server.js" ]; then
    cp "$CURRENT_DIR/intellij-mcp-server.js" "$MCP_SERVERS_DIR/"
    echo -e "${GREEN}✓ Copied MCP server from current directory${NC}"
else
    echo "Error: intellij-mcp-server.js not found in current directory"
    exit 1
fi
chmod +x "$MCP_SERVERS_DIR/intellij-mcp-server.js"

# Step 3: Create package.json with proper configuration
echo -e "\n${YELLOW}Step 3: Creating package.json configuration...${NC}"
cat > "$MCP_SERVERS_DIR/package.json" << 'EOF'
{
  "name": "mcp-servers",
  "version": "1.0.0",
  "description": "MCP servers for IntelliJ integration",
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

# Step 4: Install dependencies including Claude Code locally
echo -e "\n${YELLOW}Step 4: Installing dependencies...${NC}"
cd "$MCP_SERVERS_DIR"
npm install
# Install Claude Code locally to avoid permission issues
echo -e "${YELLOW}Installing Claude Code locally...${NC}"
npm install @anthropic-ai/claude-code
cd "$CURRENT_DIR"
echo -e "${GREEN}✓ Dependencies and Claude Code installed locally${NC}"

# Step 5: Copy test client
echo -e "\n${YELLOW}Step 5: Setting up test client...${NC}"
if [ -f "$CURRENT_DIR/mcp-test-client.py" ]; then
    cp "$CURRENT_DIR/mcp-test-client.py" "$MCP_SERVERS_DIR/"
    chmod +x "$MCP_SERVERS_DIR/mcp-test-client.py"
    echo -e "${GREEN}✓ Test client copied${NC}"
else
    echo -e "${YELLOW}! Test client not found (optional)${NC}"
fi

# Step 6: Create all helper scripts
echo -e "\n${YELLOW}Step 6: Creating helper scripts...${NC}"

# Create start script
cat > "$MCP_SERVERS_DIR/start-mcp-server.sh" << 'EOF'
#!/bin/bash
# Start MCP server for a project

if [ -z "$1" ]; then
    echo "Usage: $0 <project-path>"
    exit 1
fi

# Convert relative path to absolute path
PROJECT_PATH="$(cd "$1" 2>/dev/null && pwd)"
if [ -z "$PROJECT_PATH" ]; then
    echo "Error: Invalid project path: $1"
    exit 1
fi

SERVER_PATH="$HOME/mcp-servers/intellij-mcp-server.js"

if [ ! -f "$SERVER_PATH" ]; then
    echo "Error: MCP server not found at $SERVER_PATH"
    echo "Please run the setup script first."
    exit 1
fi

echo "Starting MCP server for: $PROJECT_PATH"
cd "$HOME/mcp-servers"
node "$SERVER_PATH" "$PROJECT_PATH"
EOF
chmod +x "$MCP_SERVERS_DIR/start-mcp-server.sh"

# Create test script
cat > "$MCP_SERVERS_DIR/test-mcp-server.sh" << 'EOF'
#!/bin/bash
# Test MCP server

if [ -z "$1" ]; then
    echo "Usage: $0 <project-path>"
    exit 1
fi

# Convert relative path to absolute path
PROJECT_PATH="$(cd "$1" 2>/dev/null && pwd)"
if [ -z "$PROJECT_PATH" ]; then
    echo "Error: Invalid project path: $1"
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
# Quick test to verify MCP server works

cd "$HOME/mcp-servers"
echo "Running quick MCP server test..."

# Test with a simple tools/list request
RESPONSE=$(echo '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}' | timeout 2s node intellij-mcp-server.js /tmp 2>/dev/null || true)

if echo "$RESPONSE" | grep -q '"tools"'; then
    echo "✅ MCP server is working correctly!"
    echo "Available tools found:"
    echo "$RESPONSE" | grep -o '"name":"[^"]*"' | cut -d'"' -f4 | sed 's/^/  - /'
else
    echo "❌ MCP server test failed"
    echo "Response: $RESPONSE"
    exit 1
fi
EOF
chmod +x "$MCP_SERVERS_DIR/quick-test.sh"

# Step 7: Create convenience scripts in local bin
echo -e "\n${YELLOW}Step 7: Creating convenience commands...${NC}"
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

# Create mcp-start command
cat > "$LOCAL_BIN/mcp-start" << 'EOF'
#!/bin/bash
exec "$HOME/mcp-servers/start-mcp-server.sh" "$@"
EOF
chmod +x "$LOCAL_BIN/mcp-start"

# Create mcp-test command
cat > "$LOCAL_BIN/mcp-test" << 'EOF'
#!/bin/bash
exec "$HOME/mcp-servers/test-mcp-server.sh" "$@"
EOF
chmod +x "$LOCAL_BIN/mcp-test"

# Create mcp-quick-test command
cat > "$LOCAL_BIN/mcp-quick-test" << 'EOF'
#!/bin/bash
exec "$HOME/mcp-servers/quick-test.sh"
EOF
chmod +x "$LOCAL_BIN/mcp-quick-test"

# Create mcp-help command
cat > "$LOCAL_BIN/mcp-help" << 'EOF'
#!/bin/bash
# Show MCP documentation
if [ -f "$HOME/mcp-servers/README.md" ]; then
    less "$HOME/mcp-servers/README.md"
else
    echo "Documentation not found. Please run the setup script."
    exit 1
fi
EOF
chmod +x "$LOCAL_BIN/mcp-help"

# Create claude command wrapper for local installation
cat > "$LOCAL_BIN/claude" << 'EOF'
#!/bin/bash
# Claude Code local wrapper - runs the locally installed version

CLAUDE_PATH="$HOME/mcp-servers/node_modules/.bin/claude"

if [ ! -f "$CLAUDE_PATH" ]; then
    echo "Error: Claude Code not found at $CLAUDE_PATH"
    echo "Please run the setup script to install Claude Code locally."
    exit 1
fi

# Pass all arguments to the local claude installation
exec "$CLAUDE_PATH" "$@"
EOF
chmod +x "$LOCAL_BIN/claude"

echo -e "${GREEN}✓ Convenience commands created${NC}"

# Step 8: Test installation
echo -e "\n${YELLOW}Step 8: Testing installation...${NC}"
if "$MCP_SERVERS_DIR/quick-test.sh"; then
    echo -e "${GREEN}✓ MCP server test passed${NC}"
else
    echo -e "${YELLOW}! MCP server test failed, but setup completed${NC}"
fi

# Step 9: Create comprehensive usage guide
echo -e "\n${YELLOW}Step 9: Creating documentation...${NC}"
cat > "$MCP_SERVERS_DIR/README.md" << 'EOF'
# MCP Server Usage Guide

## Overview
The MCP (Model Context Protocol) server provides programmatic access to your IntelliJ projects.
Everything is pre-configured and ready to use.

## Quick Start

You have three simple commands available:

### 1. Start the MCP server:
```bash
# From anywhere with full path
mcp-start /path/to/your/project

# From inside your project directory
cd /path/to/your/project
mcp-start .
```

### 2. Test the MCP server interactively:
```bash
# From anywhere with full path
mcp-test /path/to/your/project

# From inside your project directory
cd /path/to/your/project
mcp-test .
```

### 3. Quick test to verify installation:
```bash
mcp-quick-test
```

## Available MCP Tools

When the server is running, these tools are available:

1. **read_file** - Read file contents
   ```json
   {"name": "read_file", "arguments": {"path": "src/Main.java"}}
   ```

2. **write_file** - Write to files
   ```json
   {"name": "write_file", "arguments": {"path": "test.txt", "content": "Hello"}}
   ```

3. **list_files** - List directory contents
   ```json
   {"name": "list_files", "arguments": {"directory": "src"}}
   ```

4. **execute_command** - Run shell commands
   ```json
   {"name": "execute_command", "arguments": {"command": "ls -la"}}
   ```

5. **project_structure** - Show project tree
   ```json
   {"name": "project_structure", "arguments": {"maxDepth": 3}}
   ```

6. **git_status** - Check git status
   ```json
   {"name": "git_status", "arguments": {}}
   ```

7. **find_class** - Find Java/Kotlin classes
   ```json
   {"name": "find_class", "arguments": {"className": "Main"}}
   ```

## Using with Claude.ai

Simply describe what you want to do with your project files:
- "I have a Java project at /home/user/myapp. Show me its structure."
- "Read the UserController.java file from /home/user/myapp"
- "List all Java files in the src directory of my project"

## Interactive Test Mode Commands

When using `mcp-test`, these commands are available:
- `list` - Show available tools
- `read <file>` - Read a file
- `structure` - Show project structure
- `files [dir]` - List files in directory
- `git` - Show git status
- `quit` - Exit

## Troubleshooting

If commands aren't found, run:
```bash
source ~/.bashrc
```

For any issues, run the quick test:
```bash
mcp-quick-test
```

## Integration Example

To use programmatically from Python:
```python
import subprocess
import json

proc = subprocess.Popen(
    ['mcp-start', '/path/to/project'],
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
    text=True
)

request = {
    "jsonrpc": "2.0",
    "id": 1,
    "method": "tools/call",
    "params": {
        "name": "list_files",
        "arguments": {"directory": "."}
    }
}

proc.stdin.write(json.dumps(request) + '\n')
proc.stdin.flush()
response = json.loads(proc.stdout.readline())
print(response)
```
EOF
echo -e "${GREEN}✓ Documentation created at: $MCP_SERVERS_DIR/README.md${NC}"

# Update PATH if needed
if ! echo "$PATH" | grep -q "$LOCAL_BIN"; then
    echo "export PATH=\"\$PATH:$LOCAL_BIN\"" >> ~/.bashrc
    echo -e "${YELLOW}Added $LOCAL_BIN to PATH. Run 'source ~/.bashrc' to update current session.${NC}"
fi

echo ""
echo -e "${GREEN}🎉 MCP server and Claude Code setup complete!${NC}"
echo ""
echo "Everything is configured. Available commands:"
echo "  claude                    - Run Claude Code (locally installed)"
echo "  mcp-start <project-path>  - Start MCP server"
echo "  mcp-test <project-path>   - Test MCP server interactively"
echo "  mcp-quick-test            - Verify installation"
echo "  mcp-help                  - View documentation"
echo ""
echo "Claude Code is now installed locally in ~/mcp-servers/"
echo "Documentation: $MCP_SERVERS_DIR/README.md (or run 'mcp-help')"
echo ""
echo "Remember to run 'source ~/.bashrc' if commands aren't found."
