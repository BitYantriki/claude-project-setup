#!/usr/bin/env python3
"""Project management for the Claude project creator."""

from pathlib import Path
from typing import Tuple, Optional
from config import Colors


class ProjectManager:
    """Manages project path validation and setup."""
    
    def __init__(self):
        self.colors = Colors()
    
    def parse_project_path(self, input_path: str) -> Tuple[Path, str, bool]:
        """
        Parse the input path and determine project setup parameters.
        
        Args:
            input_path: User-provided path (relative or absolute)
            
        Returns:
            Tuple of (target_path, project_name, should_create_directory)
        """
        input_path = input_path.strip()
        
        # Handle home directory expansion
        if input_path.startswith('~'):
            input_path = str(Path(input_path).expanduser())
        
        # Determine if it's an absolute or relative path
        if Path(input_path).is_absolute():
            # Absolute path - directory should exist
            target_path = Path(input_path)
            project_name = target_path.name
            should_create = False
        else:
            # Relative path - we'll create the directory
            current_dir = Path.cwd()
            target_path = current_dir / input_path
            project_name = Path(input_path).name
            should_create = True
        
        return target_path, project_name, should_create
    
    def validate_project_path(self, target_path: Path, should_create: bool) -> Tuple[bool, Optional[str]]:
        """
        Validate the project path and check for any issues.
        
        Args:
            target_path: The target project path
            should_create: Whether we should create the directory
            
        Returns:
            Tuple of (is_valid, error_message)
        """
        if should_create:
            # For new projects, check if directory already exists
            if target_path.exists():
                if target_path.is_file():
                    return False, f"A file already exists at {target_path}"
                elif target_path.is_dir() and any(target_path.iterdir()):
                    return False, f"Directory {target_path} already exists and is not empty"
            
            # Check if parent directory exists and is writable
            parent_dir = target_path.parent
            if not parent_dir.exists():
                try:
                    parent_dir.mkdir(parents=True, exist_ok=True)
                except PermissionError:
                    return False, f"Permission denied: Cannot create parent directory {parent_dir}"
                except Exception as e:
                    return False, f"Cannot create parent directory {parent_dir}: {e}"
            
            if not parent_dir.is_dir():
                return False, f"Parent path {parent_dir} is not a directory"
                
            # Check if we can write to the parent directory
            if not self._can_write_to_directory(parent_dir):
                return False, f"Permission denied: Cannot write to {parent_dir}"
        
        else:
            # For existing projects, check if directory exists
            if not target_path.exists():
                return False, f"Directory {target_path} does not exist"
            
            if not target_path.is_dir():
                return False, f"{target_path} is not a directory"
            
            # Check if we can write to the directory
            if not self._can_write_to_directory(target_path):
                return False, f"Permission denied: Cannot write to {target_path}"
        
        return True, None
    
    def _can_write_to_directory(self, directory: Path) -> bool:
        """
        Check if we can write to a directory.
        
        Args:
            directory: Directory to check
            
        Returns:
            True if writable, False otherwise
        """
        try:
            # Try to create a temporary file
            test_file = directory / ".claude_write_test"
            test_file.touch()
            test_file.unlink()
            return True
        except (PermissionError, OSError):
            return False
    
    def create_project_directory(self, target_path: Path) -> bool:
        """
        Create the project directory.
        
        Args:
            target_path: Path where to create the directory
            
        Returns:
            True if successful, False otherwise
        """
        try:
            target_path.mkdir(parents=True, exist_ok=True)
            return True
        except Exception as e:
            print(f"{self.colors.RED}Error creating directory {target_path}: {e}{self.colors.NC}")
            return False
    
    def show_path_info(self, target_path: Path, project_name: str, should_create: bool) -> None:
        """
        Display information about the project path.
        
        Args:
            target_path: The target project path
            project_name: Name of the project
            should_create: Whether we're creating a new directory
        """
        if should_create:
            print(f"{self.colors.BROWN}Creating new project directory: {target_path}{self.colors.NC}")
        else:
            print(f"{self.colors.BROWN}Using existing directory: {target_path}{self.colors.NC}")
        
        print(f"{self.colors.BROWN}Project name: {project_name}{self.colors.NC}")
    
    def get_absolute_path(self, path: Path) -> Path:
        """
        Get the absolute path, resolving any symbolic links.
        
        Args:
            path: Input path
            
        Returns:
            Absolute path
        """
        return path.resolve()
    
    def is_git_repository(self, project_path: Path) -> bool:
        """
        Check if the project directory is already a git repository.
        
        Args:
            project_path: Path to the project directory
            
        Returns:
            True if it's a git repository, False otherwise
        """
        git_dir = project_path / ".git"
        return git_dir.exists() and git_dir.is_dir()
    
    def check_project_structure(self, project_path: Path) -> dict:
        """
        Analyze the existing project structure.
        
        Args:
            project_path: Path to the project directory
            
        Returns:
            Dictionary with information about the project structure
        """
        info = {
            'has_src': (project_path / "src").exists(),
            'has_tests': (project_path / "tests").exists(),
            'has_docs': (project_path / "docs").exists(),
            'has_readme': (project_path / "README.md").exists(),
            'has_gitignore': (project_path / ".gitignore").exists(),
            'has_claude_md': (project_path / "CLAUDE.md").exists(),
            'is_git_repo': self.is_git_repository(project_path),
            'file_count': len(list(project_path.iterdir())) if project_path.exists() else 0
        }
        return info
    
    def suggest_project_improvements(self, project_path: Path) -> list:
        """
        Suggest improvements based on the current project structure.
        
        Args:
            project_path: Path to the project directory
            
        Returns:
            List of improvement suggestions
        """
        suggestions = []
        structure = self.check_project_structure(project_path)
        
        if not structure['has_readme']:
            suggestions.append("Consider adding a README.md file")
        
        if not structure['has_gitignore']:
            suggestions.append("Consider adding a .gitignore file")
        
        if not structure['is_git_repo']:
            suggestions.append("Consider initializing a git repository")
        
        if not structure['has_tests']:
            suggestions.append("Consider creating a tests/ directory")
        
        if not structure['has_docs']:
            suggestions.append("Consider creating a docs/ directory")
        
        return suggestions
    
    def validate_project_name(self, project_name: str) -> Tuple[bool, Optional[str]]:
        """
        Validate the project name for any issues.
        
        Args:
            project_name: The project name to validate
            
        Returns:
            Tuple of (is_valid, error_message)
        """
        if not project_name:
            return False, "Project name cannot be empty"
        
        if project_name.strip() != project_name:
            return False, "Project name cannot start or end with whitespace"
        
        # Check for invalid characters (basic check)
        invalid_chars = ['<', '>', ':', '"', '|', '?', '*']
        for char in invalid_chars:
            if char in project_name:
                return False, f"Project name cannot contain '{char}'"
        
        # Check if name is too long
        if len(project_name) > 255:
            return False, "Project name is too long (max 255 characters)"
        
        # Check for reserved names (Windows)
        reserved_names = ['CON', 'PRN', 'AUX', 'NUL', 'COM1', 'COM2', 'COM3', 'COM4', 
                         'COM5', 'COM6', 'COM7', 'COM8', 'COM9', 'LPT1', 'LPT2', 
                         'LPT3', 'LPT4', 'LPT5', 'LPT6', 'LPT7', 'LPT8', 'LPT9']
        if project_name.upper() in reserved_names:
            return False, f"'{project_name}' is a reserved name"
        
        return True, None