#!/bin/bash

# Install Prerequisites for Claude Code on Ubuntu
# This script installs all necessary dependencies

set -e

echo "🚀 Installing prerequisites for Claude Code setup..."

# Update package list
echo "📦 Updating package list..."
sudo apt-get update

# Install Node.js (v20 LTS)
if ! command -v node &> /dev/null; then
    echo "📦 Installing Node.js v20..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "✅ Node.js already installed: $(node --version)"
fi

# Install Python 3 and pip
if ! command -v python3 &> /dev/null; then
    echo "📦 Installing Python 3..."
    sudo apt-get install -y python3 python3-pip python3-venv
else
    echo "✅ Python 3 already installed: $(python3 --version)"
fi

# Install git
if ! command -v git &> /dev/null; then
    echo "📦 Installing git..."
    sudo apt-get install -y git
else
    echo "✅ Git already installed: $(git --version)"
fi

# Install build essentials (needed for some npm packages)
echo "📦 Installing build essentials..."
sudo apt-get install -y build-essential

# Note: MCP SDK will be installed locally in setup-claude-code.sh to avoid permission issues

# Create MCP directory structure
echo "📁 Creating MCP directory structure..."
mkdir -p ~/mcp-servers
mkdir -p ~/mcp-clients
mkdir -p ~/.config/claude

echo "✅ Prerequisites installed successfully!"
echo ""
echo "Next steps:"
echo "1. Run the MCP server setup script"
echo "2. Configure your API key"
echo "3. Start using Claude Code from the terminal"