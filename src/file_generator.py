#!/usr/bin/env python3
"""File generation for the Claude project creator."""

from pathlib import Path
from typing import List, Dict, Any
from config import Colors


class FileGenerator:
    """Handles creation of project files."""
    
    def __init__(self):
        self.colors = Colors()
    
    def create_claude_md(self, project_path: Path, content: str) -> bool:
        """
        Create the CLAUDE.md file with the provided content.
        
        Args:
            project_path: Path to the project directory
            content: Content for the CLAUDE.md file
            
        Returns:
            True if successful, False otherwise
        """
        try:
            claude_md_path = project_path / "CLAUDE.md"
            with open(claude_md_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return True
        except Exception as e:
            print(f"{self.colors.RED}Error creating CLAUDE.md: {e}{self.colors.NC}")
            return False
    
    def create_readme_md(self, project_path: Path, project_name: str, config: Dict[str, Any]) -> bool:
        """
        Create a README.md file based on the project configuration.
        
        Args:
            project_path: Path to the project directory
            project_name: Name of the project
            config: Project configuration dictionary
            
        Returns:
            True if successful, False otherwise
        """
        try:
            readme_content = self._generate_readme_content(project_name, config)
            readme_path = project_path / "README.md"
            with open(readme_path, 'w', encoding='utf-8') as f:
                f.write(readme_content)
            return True
        except Exception as e:
            print(f"{self.colors.RED}Error creating README.md: {e}{self.colors.NC}")
            return False
    
    def create_gitignore(self, project_path: Path) -> bool:
        """
        Create a comprehensive .gitignore file.
        
        Args:
            project_path: Path to the project directory
            
        Returns:
            True if successful, False otherwise
        """
        try:
            gitignore_content = self._generate_gitignore_content()
            gitignore_path = project_path / ".gitignore"
            with open(gitignore_path, 'w', encoding='utf-8') as f:
                f.write(gitignore_content)
            return True
        except Exception as e:
            print(f"{self.colors.RED}Error creating .gitignore: {e}{self.colors.NC}")
            return False
    
    def _generate_readme_content(self, project_name: str, config: Dict[str, Any]) -> str:
        """
        Generate README.md content based on configuration.
        
        Args:
            project_name: Name of the project
            config: Project configuration dictionary
            
        Returns:
            README.md content as string
        """
        content = f"""# {project_name}

## Description
[Add project description here]
"""
        
        # Add project type if specified
        if config.get('project_type') and config['project_type'] != "Other/Custom":
            content += f"\n**Project Type:** {config['project_type']}\n"
        
        content += "\n## Tech Stack\n"
        
        # Filter out "Other/Custom" entries for README
        filtered_languages = [lang for lang in config.get('languages', []) if lang != "Other/Custom"]
        filtered_frameworks = [fw for fw in config.get('frameworks', []) if fw != "Other/Custom"]
        filtered_databases = [db for db in config.get('databases', []) if db != "Other/Custom"]
        filtered_tools = [tool for tool in config.get('additional_tools', []) if tool != "Other/Custom"]
        
        # Add tech stack information
        if filtered_languages:
            content += f"- **Languages:** {', '.join(filtered_languages)}\n"
        
        if filtered_frameworks:
            content += f"- **Frameworks:** {', '.join(filtered_frameworks)}\n"
        
        if config.get('cloud_platform') and config['cloud_platform'] != "Other/Custom":
            content += f"- **Cloud Platform:** {config['cloud_platform']}\n"
        
        if filtered_databases:
            content += f"- **Databases:** {', '.join(filtered_databases)}\n"
        
        if filtered_tools:
            content += f"- **Additional Tools:** {', '.join(filtered_tools)}\n"
        
        # Add standard sections
        content += """
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
"""
        
        return content
    
    def _generate_gitignore_content(self) -> str:
        """
        Generate comprehensive .gitignore content.
        
        Returns:
            .gitignore content as string
        """
        return """# Dependencies
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
"""
    
    def create_directory_structure(self, project_path: Path) -> bool:
        """
        Create basic directory structure for a new project.
        
        Args:
            project_path: Path to the project directory
            
        Returns:
            True if successful, False otherwise
        """
        try:
            directories = [
                project_path / "src",
                project_path / "tests", 
                project_path / "docs"
            ]
            
            for directory in directories:
                directory.mkdir(parents=True, exist_ok=True)
            
            return True
        except Exception as e:
            print(f"{self.colors.RED}Error creating directory structure: {e}{self.colors.NC}")
            return False
    
    def initialize_git_repository(self, project_path: Path) -> bool:
        """
        Initialize a git repository in the project directory.
        
        Args:
            project_path: Path to the project directory
            
        Returns:
            True if successful, False otherwise
        """
        try:
            import subprocess
            import os
            
            # Change to project directory
            original_cwd = os.getcwd()
            os.chdir(project_path)
            
            try:
                # Initialize git repository
                result = subprocess.run(['git', 'init'], 
                                      capture_output=True, 
                                      text=True, 
                                      check=True)
                return True
            except subprocess.CalledProcessError as e:
                print(f"{self.colors.YELLOW}Warning: Could not initialize git repository: {e}{self.colors.NC}")
                return False
            finally:
                # Change back to original directory
                os.chdir(original_cwd)
                
        except Exception as e:
            print(f"{self.colors.YELLOW}Warning: Git initialization failed: {e}{self.colors.NC}")
            return False
    
    def show_file_creation_summary(self, project_path: Path, project_name: str, is_new_project: bool) -> None:
        """
        Show a summary of created files.
        
        Args:
            project_path: Path to the project directory
            project_name: Name of the project
            is_new_project: Whether this is a new project or existing
        """
        print(f"\n{self.colors.GREEN}✅ CLAUDE.md file created successfully!{self.colors.NC}")
        
        if is_new_project:
            print(f"\nNew project created at: {self.colors.BLUE}{project_path}{self.colors.NC}")
            print(f"\nProject structure:")
            print(f"  {project_name}/")
            print(f"  ├── CLAUDE.md      # Project guidelines for Claude")
            print(f"  ├── README.md      # Project documentation")
            print(f"  ├── .gitignore     # Git ignore file")
            print(f"  ├── src/           # Source code directory")
            print(f"  ├── tests/         # Test files directory")
            print(f"  └── docs/          # Documentation directory")
        else:
            print(f"\nFile location: {self.colors.BLUE}{project_path / 'CLAUDE.md'}{self.colors.NC}")
    
    def show_next_steps(self, project_path: Path, is_new_project: bool) -> None:
        """
        Show next steps for the user.
        
        Args:
            project_path: Path to the project directory
            is_new_project: Whether this is a new project or existing
        """
        print(f"\n{self.colors.BROWN}🚀 Next steps:{self.colors.NC}")
        
        if is_new_project:
            print(f"1. cd {project_path}")
            print("2. Review and customize CLAUDE.md")
            print("3. Update the project structure section in CLAUDE.md")
            print("4. Add project-specific commands and environment variables")
            print("5. Start building your project!")
        else:
            print("1. Review the generated CLAUDE.md file")
            print("2. Add project-specific guidelines in the marked section")
            print("3. Update the project structure section")
            print("4. Add key commands specific to your project")
        
        print(f"\n{self.colors.GREEN}🎉 Claude will now better understand your project's requirements and tech stack!{self.colors.NC}")
    
    def check_claude_md_exists(self, project_path: Path) -> bool:
        """
        Check if CLAUDE.md already exists in the project directory.
        
        Args:
            project_path: Path to the project directory
            
        Returns:
            True if CLAUDE.md exists, False otherwise
        """
        return (project_path / "CLAUDE.md").exists()
    
    def prompt_overwrite_confirmation(self) -> bool:
        """
        Prompt user for confirmation to overwrite existing CLAUDE.md.
        
        Returns:
            True if user confirms overwrite, False otherwise
        """
        print(f"{self.colors.YELLOW}Warning: CLAUDE.md already exists in this directory{self.colors.NC}")
        print()
        print(f"  {self.colors.GREEN}Y) Overwrite existing file{self.colors.NC}")
        print(f"  {self.colors.RED}N) Cancel operation{self.colors.NC}")
        print(f"  {self.colors.RED}0) Exit{self.colors.NC}")
        print()
        
        while True:
            try:
                choice = input("👉 Overwrite existing CLAUDE.md? [y/N/0]: ").strip().lower()
                if choice in ['y', 'yes']:
                    return True
                elif choice in ['n', 'no', '']:
                    return False
                elif choice == '0':
                    print("Operation cancelled by user.")
                    return False
                else:
                    print(f"{self.colors.RED}❌ Please enter 'y' for yes, 'n' for no, or '0' to exit{self.colors.NC}")
            except KeyboardInterrupt:
                print("\n\nOperation cancelled by user.")
                return False