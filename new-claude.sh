#!/bin/bash

# Script to create a customized CLAUDE.md file for a project
# Usage: new-claude <directory-path>

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROMPT_RULES_DIR="$SCRIPT_DIR/prompt_rules"

# Function to display usage
usage() {
    echo -e "${BLUE}Usage: new-claude <directory-name-or-path>${NC}"
    echo ""
    echo "Creates a customized CLAUDE.md file for a project"
    echo ""
    echo "Arguments:"
    echo "  directory-name-or-path:"
    echo "    - Relative path/name: Creates a new project directory"
    echo "    - Absolute path: Adds CLAUDE.md to existing directory"
    echo ""
    echo "Examples:"
    echo "  new-claude my-app              # Creates ./my-app/ with CLAUDE.md"
    echo "  new-claude projects/my-app     # Creates ./projects/my-app/ with CLAUDE.md"
    echo "  new-claude /home/user/my-app   # Adds CLAUDE.md to existing directory"
}

# Check if help flag is passed
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    usage
    exit 0
fi

# Check if directory path is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Directory name or path is required${NC}"
    usage
    exit 1
fi

# Get the input parameter
INPUT_PATH="$1"

# Determine if it's an absolute or relative path
if [[ "$INPUT_PATH" = /* ]] || [[ "$INPUT_PATH" = ~* ]]; then
    # Absolute path - directory should exist
    TARGET_DIR="${INPUT_PATH/#\~/$HOME}"
    
    # Check if directory exists
    if [ ! -d "$TARGET_DIR" ]; then
        echo -e "${RED}Error: Directory $TARGET_DIR does not exist${NC}"
        echo -e "${YELLOW}Note: For absolute paths, the directory must already exist${NC}"
        exit 1
    fi
    
    PROJECT_NAME=$(basename "$TARGET_DIR")
    CREATE_DIR=false
else
    # Relative path - create new project directory
    PROJECT_NAME=$(basename "$INPUT_PATH")
    PARENT_DIR=$(dirname "$INPUT_PATH")
    
    # If INPUT_PATH is just a name (no slashes), PARENT_DIR will be "."
    if [ "$PARENT_DIR" = "." ]; then
        TARGET_DIR="$(pwd)/$PROJECT_NAME"
    else
        # Create parent directories if needed
        TARGET_DIR="$(pwd)/$INPUT_PATH"
    fi
    
    CREATE_DIR=true
fi

# Create directory if needed (for relative paths)
if [ "$CREATE_DIR" = true ]; then
    if [ -d "$TARGET_DIR" ]; then
        echo -e "${RED}Error: Directory $TARGET_DIR already exists${NC}"
        echo -e "${YELLOW}Use 'new-claude $TARGET_DIR' to add CLAUDE.md to existing directory${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Creating new project directory: $TARGET_DIR${NC}"
    mkdir -p "$TARGET_DIR"
else
    # For absolute paths, check if CLAUDE.md already exists
    if [ -f "$TARGET_DIR/CLAUDE.md" ]; then
        echo -e "${YELLOW}Warning: CLAUDE.md already exists in $TARGET_DIR${NC}"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Aborted."
            exit 0
        fi
    fi
fi

# Function to select from options
select_option() {
    local prompt="$1"
    shift
    local options=("$@")
    
    echo -e "\n${CYAN}$prompt${NC}"
    PS3="Enter your choice (number): "
    select opt in "${options[@]}" "None"; do
        if [ "$opt" = "None" ]; then
            echo ""
            return
        elif [ -n "$opt" ]; then
            echo "$opt"
            return
        else
            echo -e "${RED}Invalid option. Please try again.${NC}"
        fi
    done
}

# Function to select multiple options
select_multiple() {
    local prompt="$1"
    shift
    local options=("$@")
    local selected=()
    
    echo -e "\n${CYAN}$prompt${NC}"
    echo "Select options one by one. Choose 'Done' when finished."
    
    while true; do
        PS3="Enter your choice (number): "
        select opt in "${options[@]}" "Done"; do
            if [ "$opt" = "Done" ]; then
                echo "${selected[@]}"
                return
            elif [ -n "$opt" ]; then
                # Check if already selected
                if [[ " ${selected[@]} " =~ " ${opt} " ]]; then
                    echo -e "${YELLOW}Already selected: $opt${NC}"
                else
                    selected+=("$opt")
                    echo -e "${GREEN}Selected: $opt${NC}"
                fi
                break
            else
                echo -e "${RED}Invalid option. Please try again.${NC}"
            fi
        done
    done
}

echo -e "${BLUE}🚀 Claude Project Configuration Generator${NC}"
echo -e "${BLUE}========================================${NC}"

if [ "$CREATE_DIR" = true ]; then
    echo -e "\nThis tool will create a new project and generate a customized CLAUDE.md file"
    echo -e "Project location: ${GREEN}$TARGET_DIR${NC}"
else
    echo -e "\nThis tool will generate a customized CLAUDE.md file"
    echo -e "for your existing project at: ${GREEN}$TARGET_DIR${NC}"
fi

# Language selection
languages=(
    "Python"
    "JavaScript"
    "TypeScript"
    "Java"
    "Go"
    "Rust"
    "C++"
    "Ruby"
    "PHP"
)

selected_language=$(select_option "Select primary programming language:" "${languages[@]}")

# Map display names to file names
declare -A language_files=(
    ["Python"]="python"
    ["JavaScript"]="javascript"
    ["TypeScript"]="typescript"
)

# Framework selection based on language
declare -A language_frameworks=(
    ["Python"]="Django Flask FastAPI"
    ["JavaScript"]="Express React Vue Angular Next.js"
    ["TypeScript"]="Express React Vue Angular Next.js NestJS"
)

selected_framework=""
if [ -n "$selected_language" ] && [ -n "${language_frameworks[$selected_language]}" ]; then
    frameworks=(${language_frameworks[$selected_language]})
    selected_framework=$(select_option "Select framework (if applicable):" "${frameworks[@]}")
fi

# Map framework display names to file names
declare -A framework_files=(
    ["Django"]="django"
    ["Flask"]="flask"
    ["FastAPI"]="fastapi"
    ["Express"]="express"
    ["React"]="react"
    ["Vue"]="vue"
    ["Angular"]="angular"
    ["Next.js"]="nextjs"
    ["NestJS"]="nestjs"
)

# Cloud platform selection
cloud_platforms=(
    "AWS"
    "Google Cloud Platform"
    "Azure"
    "Heroku"
    "DigitalOcean"
)

selected_cloud=$(select_option "Select cloud platform (if applicable):" "${cloud_platforms[@]}")

# Map cloud display names to file names
declare -A cloud_files=(
    ["AWS"]="aws"
    ["Google Cloud Platform"]="gcp"
    ["Azure"]="azure"
)

# Database selection (multiple)
databases=(
    "PostgreSQL"
    "MySQL"
    "MongoDB"
    "SQLite"
    "Redis"
    "Elasticsearch"
    "DynamoDB"
    "Firestore"
)

echo -e "\n${YELLOW}You can select multiple databases if your project uses more than one.${NC}"
selected_databases=($(select_multiple "Select databases used in the project:" "${databases[@]}"))

# Map database display names to file names
declare -A database_files=(
    ["PostgreSQL"]="postgresql"
    ["MySQL"]="mysql"
    ["MongoDB"]="mongodb"
    ["SQLite"]="sqlite"
    ["Redis"]="redis"
    ["Elasticsearch"]="elasticsearch"
    ["DynamoDB"]="dynamodb"
    ["Firestore"]="firestore"
)

# Cache selection
caches=(
    "Redis"
    "Memcached"
    "In-Memory"
)

selected_cache=""
if [[ ! " ${selected_databases[@]} " =~ " Redis " ]]; then
    selected_cache=$(select_option "Select caching solution (if applicable):" "${caches[@]}")
fi

# Start building the CLAUDE.md file
echo -e "\n${YELLOW}Generating CLAUDE.md file...${NC}"

OUTPUT_FILE="$TARGET_DIR/CLAUDE.md"

# Start with base rules
cat "$PROMPT_RULES_DIR/base.md" > "$OUTPUT_FILE"

# Add language-specific rules
if [ -n "$selected_language" ] && [ -n "${language_files[$selected_language]}" ]; then
    lang_file="$PROMPT_RULES_DIR/languages/${language_files[$selected_language]}.md"
    if [ -f "$lang_file" ]; then
        echo "" >> "$OUTPUT_FILE"
        cat "$lang_file" >> "$OUTPUT_FILE"
    fi
fi

# Add framework-specific rules
if [ -n "$selected_framework" ] && [ -n "${framework_files[$selected_framework]}" ]; then
    framework_file="$PROMPT_RULES_DIR/frameworks/${framework_files[$selected_framework]}.md"
    if [ -f "$framework_file" ]; then
        echo "" >> "$OUTPUT_FILE"
        cat "$framework_file" >> "$OUTPUT_FILE"
    fi
fi

# Add cloud-specific rules
if [ -n "$selected_cloud" ] && [ -n "${cloud_files[$selected_cloud]}" ]; then
    cloud_file="$PROMPT_RULES_DIR/cloud/${cloud_files[$selected_cloud]}.md"
    if [ -f "$cloud_file" ]; then
        echo "" >> "$OUTPUT_FILE"
        cat "$cloud_file" >> "$OUTPUT_FILE"
    fi
fi

# Add database-specific rules
for db in "${selected_databases[@]}"; do
    if [ -n "${database_files[$db]}" ]; then
        db_file="$PROMPT_RULES_DIR/databases/${database_files[$db]}.md"
        if [ -f "$db_file" ]; then
            echo "" >> "$OUTPUT_FILE"
            cat "$db_file" >> "$OUTPUT_FILE"
        fi
    fi
done

# Add cache-specific rules (if Redis not already included as database)
if [ "$selected_cache" = "Redis" ] && [[ ! " ${selected_databases[@]} " =~ " Redis " ]]; then
    cache_file="$PROMPT_RULES_DIR/caching/redis.md"
    if [ -f "$cache_file" ]; then
        echo "" >> "$OUTPUT_FILE"
        cat "$cache_file" >> "$OUTPUT_FILE"
    fi
fi

# Add project-specific section
cat >> "$OUTPUT_FILE" << 'EOF'

## Project-Specific Guidelines

### [Add Your Project-Specific Rules Here]

<!-- 
Add any project-specific guidelines, conventions, or requirements that are unique to this project.
This might include:
- Specific naming conventions used in this project
- Custom architectural patterns
- Integration requirements
- Business logic constraints
- Team-specific practices
- External API guidelines
- Deployment procedures
- Special configuration needs
-->

### Project Structure
```
# Add your actual project structure here
```

### Key Commands
```bash
# Add project-specific commands here
# Build: 
# Test: 
# Lint: 
# Deploy: 
```

### Environment Variables
```
# List required environment variables
```

### Important Notes
<!-- Add any other important information about this project -->

---
*Generated with new-claude on $(date)*
EOF

# Create basic project structure for new projects
if [ "$CREATE_DIR" = true ]; then
    echo -e "\n${YELLOW}Creating basic project structure...${NC}"
    
    # Create basic directories
    mkdir -p "$TARGET_DIR/src"
    mkdir -p "$TARGET_DIR/tests"
    mkdir -p "$TARGET_DIR/docs"
    
    # Create README.md
    cat > "$TARGET_DIR/README.md" << EOF
# $PROJECT_NAME

## Description
[Add project description here]

## Setup
See CLAUDE.md for development guidelines and project conventions.

## Installation
[Add installation instructions here]

## Usage
[Add usage instructions here]

## License
[Add license information here]
EOF

    # Create .gitignore
    cat > "$TARGET_DIR/.gitignore" << 'EOF'
# Dependencies
node_modules/
venv/
env/
.env
.env.local

# Build outputs
dist/
build/
*.pyc
__pycache__/

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Testing
coverage/
.coverage
.pytest_cache/

# Temporary files
*.tmp
*.temp
.cache/
EOF

    # Initialize git repository
    echo -e "${YELLOW}Initializing git repository...${NC}"
    cd "$TARGET_DIR"
    git init --quiet
    cd - > /dev/null
fi

# Summary
echo -e "\n${GREEN}✅ CLAUDE.md file created successfully!${NC}"

if [ "$CREATE_DIR" = true ]; then
    echo -e "\nNew project created at: ${BLUE}$TARGET_DIR${NC}"
    echo -e "\nProject structure:"
    echo "  $PROJECT_NAME/"
    echo "  ├── CLAUDE.md      # Project guidelines for Claude"
    echo "  ├── README.md      # Project documentation"
    echo "  ├── .gitignore     # Git ignore file"
    echo "  ├── src/           # Source code directory"
    echo "  ├── tests/         # Test files directory"
    echo "  └── docs/          # Documentation directory"
else
    echo -e "\nFile location: ${BLUE}$OUTPUT_FILE${NC}"
fi

echo -e "\nConfiguration summary:"
[ -n "$selected_language" ] && echo -e "  - Language: ${CYAN}$selected_language${NC}"
[ -n "$selected_framework" ] && echo -e "  - Framework: ${CYAN}$selected_framework${NC}"
[ -n "$selected_cloud" ] && echo -e "  - Cloud: ${CYAN}$selected_cloud${NC}"
[ ${#selected_databases[@]} -gt 0 ] && echo -e "  - Databases: ${CYAN}${selected_databases[*]}${NC}"
[ -n "$selected_cache" ] && echo -e "  - Cache: ${CYAN}$selected_cache${NC}"

echo -e "\n${YELLOW}Next steps:${NC}"
if [ "$CREATE_DIR" = true ]; then
    echo "1. cd $TARGET_DIR"
    echo "2. Review and customize CLAUDE.md"
    echo "3. Start building your project!"
else
    echo "1. Review the generated CLAUDE.md file"
    echo "2. Add project-specific guidelines in the marked section"
    echo "3. Update the project structure section"
    echo "4. Add key commands specific to your project"
fi
echo -e "\n${GREEN}Claude will now better understand your project's requirements!${NC}"