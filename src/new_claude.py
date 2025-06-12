#!/usr/bin/env python3
"""
Claude Project Creator - Main Application

A tool to create intelligent project templates with customized AI guidelines.
"""

import sys
import argparse
from pathlib import Path

# Add the src directory to the Python path
sys.path.insert(0, str(Path(__file__).parent))

from prompts import PromptManager
from template_manager import TemplateManager
from file_generator import FileGenerator
from project_manager import ProjectManager
from config import Colors


class ClaudeProjectCreator:
    """Main application class for the Claude project creator."""
    
    def __init__(self):
        self.prompt_manager = PromptManager()
        self.template_manager = TemplateManager()
        self.file_generator = FileGenerator()
        self.project_manager = ProjectManager()
        self.colors = Colors()
    
    def show_usage(self) -> None:
        """Display usage information."""
        print(f"{self.colors.BLUE}Usage: new-claude <directory-name-or-path>{self.colors.NC}")
        print()
        print("Creates a customized CLAUDE.md file for a project")
        print()
        print("Arguments:")
        print("  directory-name-or-path:")
        print("    - Relative path/name: Creates a new project directory")
        print("    - Absolute path: Adds CLAUDE.md to existing directory")
        print()
        print("Examples:")
        print("  new-claude my-app              # Creates ./my-app/ with CLAUDE.md")
        print("  new-claude projects/my-app     # Creates ./projects/my-app/ with CLAUDE.md")
        print("  new-claude /home/user/my-app   # Adds CLAUDE.md to existing directory")
    
    def run(self, args: list) -> int:
        """
        Main entry point for the application.
        
        Args:
            args: Command line arguments
            
        Returns:
            Exit code (0 for success, 1 for error)
        """
        parser = argparse.ArgumentParser(
            description="Create intelligent project templates with customized AI guidelines",
            add_help=False
        )
        parser.add_argument('directory', nargs='?', help='Directory name or path')
        parser.add_argument('-h', '--help', action='store_true', help='Show help message')
        
        try:
            parsed_args = parser.parse_args(args)
        except SystemExit:
            return 1
        
        # Handle help
        if parsed_args.help:
            self.show_usage()
            return 0
        
        # Check if directory argument is provided
        if not parsed_args.directory:
            self.prompt_manager.print_error("Error: Directory name or path is required")
            self.show_usage()
            return 1
        
        return self.create_project(parsed_args.directory)
    
    def create_project(self, input_path: str) -> int:
        """
        Create a project with the given path.
        
        Args:
            input_path: User-provided path
            
        Returns:
            Exit code (0 for success, 1 for error)
        """
        try:
            # Parse and validate the project path
            target_path, project_name, should_create = self.project_manager.parse_project_path(input_path)
            
            # Validate project name
            name_valid, name_error = self.project_manager.validate_project_name(project_name)
            if not name_valid:
                self.prompt_manager.print_error(f"Invalid project name: {name_error}")
                return 1
            
            # Validate project path
            path_valid, path_error = self.project_manager.validate_project_path(target_path, should_create)
            if not path_valid:
                self.prompt_manager.print_error(f"Path error: {path_error}")
                if should_create:
                    self.prompt_manager.print_warning(f"Note: For absolute paths, the directory must already exist")
                return 1
            
            # Check if CLAUDE.md already exists (for existing directories)
            if not should_create and self.file_generator.check_claude_md_exists(target_path):
                if not self.file_generator.prompt_overwrite_confirmation():
                    print("Operation cancelled.")
                    return 0
            
            # Show welcome message
            self.prompt_manager.show_welcome(str(target_path), should_create)
            
            # Create project directory if needed
            if should_create:
                self.project_manager.show_path_info(target_path, project_name, should_create)
                if not self.project_manager.create_project_directory(target_path):
                    return 1
            
            # Get project configuration through interactive prompts
            config = self.prompt_manager.get_project_configuration()
            
            # Generate CLAUDE.md content
            claude_md_content = self.template_manager.build_claude_md_content(config, project_name)
            
            # Create CLAUDE.md file
            if not self.file_generator.create_claude_md(target_path, claude_md_content):
                return 1
            
            # For new projects, create additional files and structure
            if should_create:
                # Create basic directory structure
                self.file_generator.create_directory_structure(target_path)
                
                # Create README.md
                self.file_generator.create_readme_md(target_path, project_name, config)
                
                # Create .gitignore
                self.file_generator.create_gitignore(target_path)
                
                # Initialize git repository
                self.file_generator.initialize_git_repository(target_path)
            
            # Show summary
            self.file_generator.show_file_creation_summary(target_path, project_name, should_create)
            self.prompt_manager.show_configuration_summary(config)
            self.file_generator.show_next_steps(target_path, should_create)
            
            return 0
            
        except KeyboardInterrupt:
            print("\n\nOperation cancelled by user.")
            return 1
        except Exception as e:
            self.prompt_manager.print_error(f"Unexpected error: {e}")
            return 1


def main():
    """Main entry point when run as a script."""
    app = ClaudeProjectCreator()
    exit_code = app.run(sys.argv[1:])
    sys.exit(exit_code)


if __name__ == "__main__":
    main()