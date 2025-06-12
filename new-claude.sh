#!/bin/bash

# Script to create a customized CLAUDE.md file for a project
# Usage: new-claude <directory-path>

set -e

# Colors
GREEN='\033[0;32m'    # Success/Completed items
YELLOW='\033[1;33m'   # Warnings
RED='\033[0;31m'      # Errors  
BLUE='\033[0;34m'     # Headers/Titles
CYAN='\033[0;36m'     # Questions/Prompts
MAGENTA='\033[0;35m'  # Important info
BROWN='\033[0;33m'    # Instructions/Context
NC='\033[0m'          # No Color

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
    
    echo -e "${BROWN}Creating new project directory: $TARGET_DIR${NC}"
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
    echo -e "${BROWN}📝 Instructions: Type ONE number and press Enter${NC}"
    echo -e "${BROWN}   • Type 0 to skip this question${NC}"
    echo ""
    
    PS3="👉 Enter your choice (number): "
    select opt in "${options[@]}"; do
        if [ -z "$opt" ] && [ "$REPLY" = "0" ]; then
            echo ""
            return
        elif [ -n "$opt" ]; then
            echo "$opt"
            return
        else
            echo -e "${RED}❌ Invalid option. Enter a number from the list or 0 to skip.${NC}"
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
    echo -e "${BROWN}📝 Instructions: Select ONE option at a time${NC}"
    echo -e "${BROWN}   • Type a number and press Enter${NC}"
    echo -e "${BROWN}   • Repeat for each additional choice${NC}"
    echo -e "${BROWN}   • Type 0 when done${NC}"
    echo ""
    
    while true; do
        # Show currently selected items
        if [ ${#selected[@]} -gt 0 ]; then
            echo -e "${GREEN}✅ Currently selected:${NC}"
            printf "${GREEN}   %s${NC}\n" "${selected[@]}"
            echo ""
        fi
        
        PS3="👉 Enter your choice (number): "
        select opt in "${options[@]}"; do
            if [ -z "$opt" ] && [ "$REPLY" = "0" ]; then
                echo "${selected[@]}"
                return
            elif [ -n "$opt" ]; then
                # Check if already selected
                if [[ " ${selected[*]} " =~ \ $opt\  ]]; then
                    echo -e "${YELLOW}⚠️  Already selected: $opt${NC}"
                else
                    selected+=("$opt")
                    echo -e "${GREEN}✅ Added: $opt${NC}"
                fi
                break
            else
                echo -e "${RED}❌ Invalid option. Enter a number from the list or 0 to finish.${NC}"
            fi
        done
    done
}

echo -e "${BLUE}🚀 Claude Project Configuration Generator${NC}"
echo -e "${BLUE}=========================================${NC}"

if [ "$CREATE_DIR" = true ]; then
    echo -e "\nThis tool will create a new project and generate a customized CLAUDE.md file"
    echo -e "Project location: ${GREEN}$TARGET_DIR${NC}"
else
    echo -e "\nThis tool will generate a customized CLAUDE.md file"
    echo -e "for your existing project at: ${GREEN}$TARGET_DIR${NC}"
fi

echo -e "\n${MAGENTA}Let's configure your project step by step...${NC}"
echo -e "${BROWN}This will take you through 6 quick steps to customize your project setup.${NC}"
echo -e "${BROWN}You can always select 'Other/Custom' or skip questions with '0'.${NC}"

echo -e "\n${BLUE}============================================${NC}"
echo -e "${BLUE}📋 Step 1: Project Type${NC}"
echo -e "${BLUE}============================================${NC}"

# Step 1: Project Type Selection
project_types=(
    "Frontend Web Application"
    "Backend API Service"
    "Full-Stack Web Application"
    "Mobile Application"
    "Desktop Application"
    "CLI Tool/Utility"
    "Data Science/Analytics"
    "Machine Learning Project"
    "DevOps/Infrastructure"
    "Library/Package"
    "Microservice"
    "Other/Custom"
)

selected_project_type=$(select_option "🎯 What type of project are you building?" "${project_types[@]}")

echo -e "\n${BLUE}============================================${NC}"

# Step 2: Language Selection based on project type
declare -A type_languages=(
    ["Frontend Web Application"]="JavaScript TypeScript"
    ["Backend API Service"]="Python JavaScript TypeScript Java Go Rust C# PHP Ruby"
    ["Full-Stack Web Application"]="JavaScript TypeScript Python Java"
    ["Mobile Application"]="JavaScript TypeScript Swift Kotlin Java Dart"
    ["Desktop Application"]="JavaScript TypeScript Python Java C# C++ Rust Go"
    ["CLI Tool/Utility"]="Python Go Rust JavaScript TypeScript Bash"
    ["Data Science/Analytics"]="Python R Julia JavaScript"
    ["Machine Learning Project"]="Python R Julia"
    ["DevOps/Infrastructure"]="Python Go Bash JavaScript TypeScript"
    ["Library/Package"]="Python JavaScript TypeScript Java Go Rust C# C++"
    ["Microservice"]="Python JavaScript TypeScript Java Go Rust C#"
    ["Other/Custom"]="Python JavaScript TypeScript Java Go Rust C# C++ Ruby PHP"
)

# Get suggested languages for the project type
suggested_languages=""
if [ -n "$selected_project_type" ] && [ -n "${type_languages[$selected_project_type]}" ]; then
    suggested_languages="${type_languages[$selected_project_type]}"
fi

# Default language list (comprehensive)
all_languages=(
    "Python"
    "JavaScript" 
    "TypeScript"
    "Java"
    "Go"
    "Rust"
    "C#"
    "C++"
    "Ruby"
    "PHP"
    "Swift"
    "Kotlin"
    "Dart"
    "R"
    "Julia"
    "Bash"
)

# If we have suggested languages, use those first, otherwise use all
if [ -n "$suggested_languages" ]; then
    IFS=' ' read -ra languages <<< "$suggested_languages"
    echo -e "\n${BROWN}💡 Based on your project type, here are the most relevant languages:${NC}"
else
    languages=("${all_languages[@]}")
fi

# Add "Other/Custom" option to languages
languages+=("Other/Custom")

# Allow multiple language selection for complex projects
echo -e "\n${BROWN}💡 Multiple languages can be selected for complex projects${NC}"
echo -e "${BROWN}   Example: JavaScript for frontend + Python for backend${NC}"
IFS=' ' read -ra selected_languages <<< "$(select_multiple "🔧 Which programming languages will you use?" "${languages[@]}")"

echo -e "\n${BLUE}============================================${NC}"

# Step 3: Framework Selection based on languages and project type
declare -A language_frameworks=(
    ["Python"]="Django Flask FastAPI Streamlit Jupyter"
    ["JavaScript"]="Express React Vue Angular Next.js Svelte Node.js"
    ["TypeScript"]="Express React Vue Angular Next.js NestJS"
    ["Java"]="Spring Spring-Boot"
    ["Go"]="Gin Echo Fiber"
    ["Rust"]="Actix Rocket Warp"
    ["C#"]="ASP.NET Blazor"
    ["Swift"]="SwiftUI UIKit"
    ["Kotlin"]="Spring-Boot Android"
    ["Dart"]="Flutter"
)

# Collect frameworks for all selected languages
all_frameworks=()
for lang in "${selected_languages[@]}"; do
    if [ "$lang" != "Other/Custom" ] && [ -n "${language_frameworks[$lang]}" ]; then
        IFS=' ' read -ra frameworks <<< "${language_frameworks[$lang]}"
        all_frameworks+=("${frameworks[@]}")
    fi
done

# Remove duplicates and select frameworks
if [ ${#all_frameworks[@]} -gt 0 ]; then
    # Remove duplicate frameworks and add "Other/Custom"
    mapfile -t unique_frameworks < <(printf "%s\n" "${all_frameworks[@]}" | sort -u)
    unique_frameworks+=("Other/Custom")
    IFS=' ' read -ra selected_frameworks <<< "$(select_multiple "🏗️ Which frameworks/libraries will you use?" "${unique_frameworks[@]}")"
fi

echo -e "\n${BLUE}============================================${NC}"

# Step 4: Cloud Platform Selection
cloud_platforms=(
    "AWS"
    "Google Cloud Platform (GCP)"
    "Microsoft Azure"
    "Heroku"
    "DigitalOcean"
    "Vercel"
    "Netlify"
    "Railway"
    "Fly.io"
    "Other/Custom"
)

echo -e "\n${BROWN}💡 Select a cloud platform for deployment (optional)${NC}"
selected_cloud=$(select_option "☁️ Which cloud platform will you use for deployment?" "${cloud_platforms[@]}")

echo -e "\n${BLUE}============================================${NC}"

# Step 5: Database Selection (multiple allowed)
databases=(
    "PostgreSQL"
    "MySQL"
    "MongoDB"
    "SQLite"
    "Redis"
    "Elasticsearch"
    "DynamoDB"
    "Firestore"
    "Cassandra"
    "InfluxDB"
    "Other/Custom"
)

echo -e "\n${BROWN}💡 Multiple databases can be selected for different purposes${NC}"
echo -e "${BROWN}   Example: PostgreSQL for main data + Redis for caching${NC}"
IFS=' ' read -ra selected_databases <<< "$(select_multiple "🗄️ Which databases will your project use?" "${databases[@]}")"

echo -e "\n${BLUE}============================================${NC}"

# Step 6: Additional Tools & Services
additional_tools=(
    "Redis (Caching)"
    "Docker"
    "Kubernetes"
    "GitHub Actions"
    "GitLab CI"
    "Jenkins"
    "Terraform"
    "Ansible"
    "Nginx"
    "Apache"
    "Other/Custom"
)

echo -e "\n${BROWN}💡 Multiple tools and services can be selected${NC}"
echo -e "${BROWN}   Example: Docker for containers + GitHub Actions for CI/CD${NC}"
IFS=' ' read -ra selected_tools <<< "$(select_multiple "🛠️ Additional tools and services you'll use:" "${additional_tools[@]}")"

echo -e "\n${BLUE}============================================${NC}"
echo -e "${BLUE}🏁 Configuration Complete - Generating Files${NC}"
echo -e "${BLUE}============================================${NC}"

# Mapping for file names
declare -A language_files=(
    ["Python"]="python"
    ["JavaScript"]="javascript"
    ["TypeScript"]="typescript"
    ["Java"]="java"
    ["Go"]="go"
    ["Rust"]="rust"
    ["C#"]="csharp"
    ["C++"]="cpp"
    ["Ruby"]="ruby"
    ["PHP"]="php"
    ["Swift"]="swift"
    ["Kotlin"]="kotlin"
    ["Dart"]="dart"
    ["R"]="r"
    ["Julia"]="julia"
    ["Bash"]="bash"
)

declare -A framework_files=(
    ["Django"]="django"
    ["Flask"]="flask"
    ["FastAPI"]="fastapi"
    ["Streamlit"]="streamlit"
    ["Express"]="express"
    ["React"]="react"
    ["Vue"]="vue"
    ["Angular"]="angular"
    ["Next.js"]="nextjs"
    ["NestJS"]="nestjs"
    ["Svelte"]="svelte"
    ["Spring"]="spring"
    ["Spring-Boot"]="spring-boot"
    ["Gin"]="gin"
    ["Echo"]="echo"
    ["Fiber"]="fiber"
    ["Actix"]="actix"
    ["Rocket"]="rocket"
    ["ASP.NET"]="aspnet"
    ["Blazor"]="blazor"
    ["SwiftUI"]="swiftui"
    ["UIKit"]="uikit"
    ["Flutter"]="flutter"
)

declare -A cloud_files=(
    ["AWS"]="aws"
    ["Google Cloud Platform (GCP)"]="gcp"
    ["Microsoft Azure"]="azure"
    ["Heroku"]="heroku"
    ["DigitalOcean"]="digitalocean"
    ["Vercel"]="vercel"
    ["Netlify"]="netlify"
)

declare -A database_files=(
    ["PostgreSQL"]="postgresql"
    ["MySQL"]="mysql"
    ["MongoDB"]="mongodb"
    ["SQLite"]="sqlite"
    ["Redis"]="redis"
    ["Elasticsearch"]="elasticsearch"
    ["DynamoDB"]="dynamodb"
    ["Firestore"]="firestore"
    ["Cassandra"]="cassandra"
    ["InfluxDB"]="influxdb"
)

# Start building the CLAUDE.md file
echo -e "\n${BROWN}📝 Generating CLAUDE.md file...${NC}"

OUTPUT_FILE="$TARGET_DIR/CLAUDE.md"

# Start with base rules
cat "$PROMPT_RULES_DIR/base.md" > "$OUTPUT_FILE"

# Add project type context
if [ -n "$selected_project_type" ] && [ "$selected_project_type" != "Other/Custom" ]; then
    cat >> "$OUTPUT_FILE" << EOF

## Project Type: $selected_project_type

This project is a $selected_project_type. Keep this context in mind when providing suggestions and code examples.
EOF
fi

# Add language-specific rules (multiple languages supported)
for lang in "${selected_languages[@]}"; do
    if [ "$lang" != "Other/Custom" ] && [ -n "${language_files[$lang]}" ]; then
        lang_file="$PROMPT_RULES_DIR/languages/${language_files[$lang]}.md"
        if [ -f "$lang_file" ]; then
            echo "" >> "$OUTPUT_FILE"
            cat "$lang_file" >> "$OUTPUT_FILE"
        fi
    fi
done

# Add framework-specific rules (multiple frameworks supported)
for framework in "${selected_frameworks[@]}"; do
    if [ "$framework" != "Other/Custom" ] && [ -n "${framework_files[$framework]}" ]; then
        framework_file="$PROMPT_RULES_DIR/frameworks/${framework_files[$framework]}.md"
        if [ -f "$framework_file" ]; then
            echo "" >> "$OUTPUT_FILE"
            cat "$framework_file" >> "$OUTPUT_FILE"
        fi
    fi
done

# Add cloud-specific rules
if [ -n "$selected_cloud" ] && [ "$selected_cloud" != "Other/Custom" ] && [ -n "${cloud_files[$selected_cloud]}" ]; then
    cloud_file="$PROMPT_RULES_DIR/cloud/${cloud_files[$selected_cloud]}.md"
    if [ -f "$cloud_file" ]; then
        echo "" >> "$OUTPUT_FILE"
        cat "$cloud_file" >> "$OUTPUT_FILE"
    fi
fi

# Add database-specific rules (multiple databases supported)
for db in "${selected_databases[@]}"; do
    if [ "$db" != "Other/Custom" ] && [ -n "${database_files[$db]}" ]; then
        db_file="$PROMPT_RULES_DIR/databases/${database_files[$db]}.md"
        if [ -f "$db_file" ]; then
            echo "" >> "$OUTPUT_FILE"
            cat "$db_file" >> "$OUTPUT_FILE"
        fi
    fi
done

# Add additional tools context
tools_to_show=()
for tool in "${selected_tools[@]}"; do
    if [ "$tool" != "Other/Custom" ]; then
        tools_to_show+=("$tool")
    fi
done

if [ ${#tools_to_show[@]} -gt 0 ]; then
    cat >> "$OUTPUT_FILE" << EOF

## Additional Tools & Services

This project uses the following additional tools and services:
EOF
    for tool in "${tools_to_show[@]}"; do
        echo "- $tool" >> "$OUTPUT_FILE"
    done
    echo "" >> "$OUTPUT_FILE"
    echo "Consider these tools when providing suggestions and recommendations." >> "$OUTPUT_FILE"
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
# Install dependencies: 
# Build: 
# Test: 
# Lint: 
# Dev server: 
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
    echo -e "\n${BROWN}📁 Creating basic project structure...${NC}"
    
    # Create basic directories
    mkdir -p "$TARGET_DIR/src"
    mkdir -p "$TARGET_DIR/tests"
    mkdir -p "$TARGET_DIR/docs"
    
    # Create README.md
    cat > "$TARGET_DIR/README.md" << EOF
# $PROJECT_NAME

## Description
[Add project description here]

**Project Type:** $selected_project_type

## Tech Stack
EOF

    # Filter out "Other/Custom" entries for README
    readme_languages=()
    for lang in "${selected_languages[@]}"; do
        if [ "$lang" != "Other/Custom" ]; then
            readme_languages+=("$lang")
        fi
    done

    readme_frameworks=()
    for framework in "${selected_frameworks[@]}"; do
        if [ "$framework" != "Other/Custom" ]; then
            readme_frameworks+=("$framework")
        fi
    done

    readme_databases=()
    for db in "${selected_databases[@]}"; do
        if [ "$db" != "Other/Custom" ]; then
            readme_databases+=("$db")
        fi
    done

    # Add tech stack to README (only if not "Other/Custom")
    if [ ${#readme_languages[@]} -gt 0 ]; then
        echo "- **Languages:** ${readme_languages[*]}" >> "$TARGET_DIR/README.md"
    fi
    if [ ${#readme_frameworks[@]} -gt 0 ]; then
        echo "- **Frameworks:** ${readme_frameworks[*]}" >> "$TARGET_DIR/README.md"
    fi
    if [ -n "$selected_cloud" ] && [ "$selected_cloud" != "Other/Custom" ]; then
        echo "- **Cloud Platform:** $selected_cloud" >> "$TARGET_DIR/README.md"
    fi
    if [ ${#readme_databases[@]} -gt 0 ]; then
        echo "- **Databases:** ${readme_databases[*]}" >> "$TARGET_DIR/README.md"
    fi
    if [ ${#tools_to_show[@]} -gt 0 ]; then
        echo "- **Additional Tools:** ${tools_to_show[*]}" >> "$TARGET_DIR/README.md"
    fi

    cat >> "$TARGET_DIR/README.md" << EOF

## Setup
See CLAUDE.md for development guidelines and project conventions.

## Installation
[Add installation instructions here]

## Usage
[Add usage instructions here]

## Development
[Add development instructions here]

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
.env.production
.env.development

# Build outputs
dist/
build/
out/
*.pyc
__pycache__/
*.class
target/

# IDE
.idea/
.vscode/
*.swp
*.swo
*.sublime-*

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
.nyc_output/

# Temporary files
*.tmp
*.temp
.cache/

# Package managers
package-lock.json
yarn.lock
Pipfile.lock
EOF

    # Initialize git repository
    echo -e "${BROWN}🔧 Initializing git repository...${NC}"
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

echo -e "\n${CYAN}📋 Configuration Summary:${NC}"
[ -n "$selected_project_type" ] && [ "$selected_project_type" != "Other/Custom" ] && echo -e "  🎯 Project Type: ${MAGENTA}$selected_project_type${NC}"
[ ${#readme_languages[@]} -gt 0 ] && echo -e "  🔧 Languages: ${CYAN}${readme_languages[*]}${NC}"
[ ${#readme_frameworks[@]} -gt 0 ] && echo -e "  🏗️ Frameworks: ${CYAN}${readme_frameworks[*]}${NC}"
[ -n "$selected_cloud" ] && [ "$selected_cloud" != "Other/Custom" ] && echo -e "  ☁️ Cloud: ${CYAN}$selected_cloud${NC}"
[ ${#readme_databases[@]} -gt 0 ] && echo -e "  🗄️ Databases: ${CYAN}${readme_databases[*]}${NC}"
[ ${#tools_to_show[@]} -gt 0 ] && echo -e "  🛠️ Tools: ${CYAN}${tools_to_show[*]}${NC}"

echo -e "\n${BROWN}🚀 Next steps:${NC}"
if [ "$CREATE_DIR" = true ]; then
    echo "1. cd $TARGET_DIR"
    echo "2. Review and customize CLAUDE.md"
    echo "3. Update the project structure section in CLAUDE.md"
    echo "4. Add project-specific commands and environment variables"
    echo "5. Start building your project!"
else
    echo "1. Review the generated CLAUDE.md file"
    echo "2. Add project-specific guidelines in the marked section"
    echo "3. Update the project structure section"
    echo "4. Add key commands specific to your project"
fi
echo -e "\n${GREEN}🎉 Claude will now better understand your project's requirements and tech stack!${NC}"