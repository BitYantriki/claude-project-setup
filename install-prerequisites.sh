#!/bin/bash

# Install Prerequisites for Claude Project Creator
# Checks and installs necessary dependencies only if needed

set -e

echo "🔍 Checking prerequisites for Claude Project Creator..."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Function to detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "macos";;
        CYGWIN*|MINGW*|MSYS*) echo "windows";;
        *)          echo "unknown";;
    esac
}

# Function to check if we need to update package list (for apt)
need_apt_update=false
check_apt_update() {
    if [ "$OS" = "linux" ] && command -v apt-get &> /dev/null; then
        # Check if cache is older than 1 day or doesn't exist
        if [ ! -f /var/lib/apt/periodic/update-success-stamp ] || \
           [ $(find /var/lib/apt/periodic/update-success-stamp -mtime +1 2>/dev/null | wc -l) -gt 0 ]; then
            need_apt_update=true
        fi
    fi
}

# Function to update package list if needed
update_package_list() {
    if [ "$need_apt_update" = true ]; then
        echo -e "${YELLOW}📦 Updating package list (needed for installation)...${NC}"
        sudo apt-get update
        need_apt_update=false
    fi
}

# Function to install Node.js based on OS
install_nodejs() {
    echo -e "${BLUE}📦 Installing Node.js...${NC}"
    
    case "$OS" in
        "linux")
            if command -v apt-get &> /dev/null; then
                update_package_list
                echo "Installing Node.js v20 LTS..."
                curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
                sudo apt-get install -y nodejs
            else
                echo -e "${RED}Error: apt-get not found. Please install Node.js manually.${NC}"
                echo "Visit: https://nodejs.org/en/download/"
                exit 1
            fi
            ;;
        "macos")
            if command -v brew &> /dev/null; then
                brew install node
            else
                echo -e "${RED}Error: Homebrew not found. Please install Node.js manually.${NC}"
                echo "Visit: https://nodejs.org/en/download/"
                exit 1
            fi
            ;;
        *)
            echo -e "${RED}Error: Unsupported OS. Please install Node.js manually.${NC}"
            echo "Visit: https://nodejs.org/en/download/"
            exit 1
            ;;
    esac
}

# Function to install Python based on OS
install_python() {
    echo -e "${BLUE}📦 Installing Python 3...${NC}"
    
    case "$OS" in
        "linux")
            if command -v apt-get &> /dev/null; then
                update_package_list
                sudo apt-get install -y python3 python3-pip python3-venv
            else
                echo -e "${RED}Error: apt-get not found. Please install Python manually.${NC}"
                echo "Visit: https://www.python.org/downloads/"
                exit 1
            fi
            ;;
        "macos")
            if command -v brew &> /dev/null; then
                brew install python
            else
                echo -e "${RED}Error: Homebrew not found. Please install Python manually.${NC}"
                echo "Visit: https://www.python.org/downloads/"
                exit 1
            fi
            ;;
        *)
            echo -e "${RED}Error: Unsupported OS. Please install Python manually.${NC}"
            echo "Visit: https://www.python.org/downloads/"
            exit 1
            ;;
    esac
}

# Function to install git if needed
install_git() {
    echo -e "${BLUE}📦 Installing git...${NC}"
    
    case "$OS" in
        "linux")
            if command -v apt-get &> /dev/null; then
                update_package_list
                sudo apt-get install -y git
            else
                echo -e "${RED}Error: apt-get not found. Please install git manually.${NC}"
                exit 1
            fi
            ;;
        "macos")
            if command -v brew &> /dev/null; then
                brew install git
            else
                echo -e "${RED}Error: Homebrew not found. Git should be available via Xcode tools.${NC}"
                echo "Try: xcode-select --install"
                exit 1
            fi
            ;;
        *)
            echo -e "${RED}Error: Unsupported OS. Please install git manually.${NC}"
            exit 1
            ;;
    esac
}

# Detect OS
OS=$(detect_os)
echo -e "${GREEN}✓ Detected OS: $OS${NC}"

# Check if we might need apt update
check_apt_update

# Check Node.js
echo -e "\n${YELLOW}Checking Node.js...${NC}"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✅ Node.js already installed: $NODE_VERSION${NC}"
    
    # Check if version is recent enough (v16+)
    NODE_MAJOR_VERSION=$(echo $NODE_VERSION | sed 's/v\([0-9]*\).*/\1/')
    if [ "$NODE_MAJOR_VERSION" -lt 16 ]; then
        echo -e "${YELLOW}⚠️  Node.js version is old (< v16). Consider upgrading.${NC}"
        echo ""
        echo "  ${GREEN}Y) Install newer Node.js version${NC}"
        echo "  ${RED}N) Keep current version${NC}"
        echo "  ${RED}0) Skip this step${NC}"
        echo ""
        read -p "Would you like to install a newer version? [y/N/0]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_nodejs
        elif [[ $REPLY =~ ^[0]$ ]]; then
            echo -e "${YELLOW}Skipping Node.js upgrade...${NC}"
        fi
    fi
else
    echo -e "${YELLOW}Node.js not found.${NC}"
    echo ""
    echo "  ${GREEN}Y) Install Node.js (Required)${NC}"
    echo "  ${RED}N) Skip installation${NC}"
    echo "  ${RED}0) Exit setup${NC}"
    echo ""
    read -p "Would you like to install Node.js? [y/N/0]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_nodejs
    elif [[ $REPLY =~ ^[0]$ ]]; then
        echo -e "${RED}Exiting setup...${NC}"
        exit 1
    else
        echo -e "${RED}Error: Node.js is required for this tool.${NC}"
        exit 1
    fi
fi

# Check Python 3
echo -e "\n${YELLOW}Checking Python 3...${NC}"
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo -e "${GREEN}✅ Python 3 already installed: $PYTHON_VERSION${NC}"
else
    echo -e "${YELLOW}Python 3 not found.${NC}"
    echo ""
    echo "  ${GREEN}Y) Install Python 3 (Required)${NC}"
    echo "  ${RED}N) Skip installation${NC}"
    echo "  ${RED}0) Exit setup${NC}"
    echo ""
    read -p "Would you like to install Python 3? [y/N/0]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_python
    elif [[ $REPLY =~ ^[0]$ ]]; then
        echo -e "${RED}Exiting setup...${NC}"
        exit 1
    else
        echo -e "${RED}Error: Python 3 is required for this tool.${NC}"
        exit 1
    fi
fi

# Check git
echo -e "\n${YELLOW}Checking git...${NC}"
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    echo -e "${GREEN}✅ Git already installed: $GIT_VERSION${NC}"
else
    echo -e "${YELLOW}Git not found.${NC}"
    echo ""
    echo "  ${GREEN}Y) Install Git (Recommended)${NC}"
    echo "  ${YELLOW}N) Skip installation${NC}"
    echo "  ${RED}0) Exit setup${NC}"
    echo ""
    read -p "Would you like to install git? [y/N/0]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_git
    elif [[ $REPLY =~ ^[0]$ ]]; then
        echo -e "${RED}Exiting setup...${NC}"
        exit 1
    else
        echo -e "${YELLOW}⚠️  Git is recommended but not required.${NC}"
    fi
fi

# Check for build tools (Linux only, optional)
if [ "$OS" = "linux" ] && command -v apt-get &> /dev/null; then
    echo -e "\n${YELLOW}Checking build tools...${NC}"
    if command -v gcc &> /dev/null; then
        echo -e "${GREEN}✅ Build tools already available${NC}"
    else
        echo -e "${YELLOW}Build tools not found (needed for some npm packages).${NC}"
        echo ""
        echo "  ${GREEN}Y) Install build tools (Recommended)${NC}"
        echo "  ${YELLOW}N) Skip installation${NC}"
        echo "  ${RED}0) Exit setup${NC}"
        echo ""
        read -p "Would you like to install build-essential? [y/N/0]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}📦 Installing build tools...${NC}"
            update_package_list
            sudo apt-get install -y build-essential
            echo -e "${GREEN}✅ Build tools installed${NC}"
        elif [[ $REPLY =~ ^[0]$ ]]; then
            echo -e "${RED}Exiting setup...${NC}"
            exit 1
        fi
    fi
fi

echo -e "\n${GREEN}✅ Prerequisites check completed!${NC}"
echo ""
echo "📋 Summary:"
echo -e "  ${GREEN}✓${NC} Node.js: $(command -v node &> /dev/null && node --version || echo 'Not installed')"
echo -e "  ${GREEN}✓${NC} Python 3: $(command -v python3 &> /dev/null && python3 --version || echo 'Not installed')"
echo -e "  ${GREEN}✓${NC} Git: $(command -v git &> /dev/null && git --version | cut -d' ' -f3 || echo 'Not installed')"
echo ""
echo "Ready to continue with Claude Project Creator setup! 🚀"