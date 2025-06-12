#!/usr/bin/env python3
"""Template management for the Claude project creator."""

from pathlib import Path
from typing import List, Optional
from config import (
    get_prompt_rules_dir, LANGUAGE_FILES, FRAMEWORK_FILES, 
    CLOUD_FILES, DATABASE_FILES, FRAMEWORK_DEPENDENCIES
)
from typing import Set


class TemplateManager:
    """Manages loading and processing of template files."""
    
    def __init__(self):
        self.prompt_rules_dir = get_prompt_rules_dir()
        self.base_template_path = self.prompt_rules_dir / "base.md"
    
    def load_base_template(self) -> str:
        """
        Load the base template content.
        
        Returns:
            Base template content as string
        """
        try:
            with open(self.base_template_path, 'r', encoding='utf-8') as f:
                return f.read()
        except FileNotFoundError:
            print(f"Warning: Base template not found at {self.base_template_path}")
            return "# Claude Project Guidelines\n\n*Base template not found - please add your guidelines here*"
        except Exception as e:
            print(f"Error loading base template: {e}")
            return "# Claude Project Guidelines\n\n*Error loading template - please add your guidelines here*"
    
    def load_language_template(self, language: str) -> Optional[str]:
        """
        Load template for a specific programming language.
        
        Args:
            language: The programming language name
            
        Returns:
            Template content or None if not found
        """
        if language not in LANGUAGE_FILES:
            return None
        
        template_path = self.prompt_rules_dir / "languages" / f"{LANGUAGE_FILES[language]}.md"
        return self._load_template_file(template_path)
    
    def load_framework_template(self, framework: str) -> Optional[str]:
        """
        Load template for a specific framework with hierarchical dependencies.
        
        Args:
            framework: The framework name
            
        Returns:
            Template content with dependencies or None if not found
        """
        if framework not in FRAMEWORK_FILES:
            return None
        
        # Start with empty content
        content_parts = []
        
        # Check if this framework has dependencies
        if framework in FRAMEWORK_DEPENDENCIES:
            # Load base framework templates first
            for base_framework in FRAMEWORK_DEPENDENCIES[framework]:
                base_template = self._load_framework_template_single(base_framework)
                if base_template:
                    content_parts.append(f"## [Base: {base_framework}]\n\n{base_template}")
        
        # Load the main framework template
        main_template = self._load_framework_template_single(framework)
        if main_template:
            # If we have dependencies, mark this as extending them
            if content_parts:
                content_parts.append(f"\n## [Extension: {framework}]\n\n{main_template}")
            else:
                content_parts.append(main_template)
        
        return '\n'.join(content_parts) if content_parts else None
    
    def _load_framework_template_single(self, framework: str) -> Optional[str]:
        """Load a single framework template without dependencies."""
        if framework not in FRAMEWORK_FILES:
            return None
        
        template_path = self.prompt_rules_dir / "frameworks" / f"{FRAMEWORK_FILES[framework]}.md"
        return self._load_template_file(template_path)
    
    def load_cloud_template(self, cloud_platform: str) -> Optional[str]:
        """
        Load template for a specific cloud platform.
        
        Args:
            cloud_platform: The cloud platform name
            
        Returns:
            Template content or None if not found
        """
        if cloud_platform not in CLOUD_FILES:
            return None
        
        template_path = self.prompt_rules_dir / "cloud" / f"{CLOUD_FILES[cloud_platform]}.md"
        return self._load_template_file(template_path)
    
    def load_database_template(self, database: str) -> Optional[str]:
        """
        Load template for a specific database.
        
        Args:
            database: The database name
            
        Returns:
            Template content or None if not found
        """
        if database not in DATABASE_FILES:
            return None
        
        template_path = self.prompt_rules_dir / "databases" / f"{DATABASE_FILES[database]}.md"
        return self._load_template_file(template_path)
    
    def _load_template_file(self, template_path: Path) -> Optional[str]:
        """
        Load a template file and return its content.
        
        Args:
            template_path: Path to the template file
            
        Returns:
            Template content or None if not found
        """
        try:
            if template_path.exists():
                with open(template_path, 'r', encoding='utf-8') as f:
                    return f.read()
        except Exception as e:
            print(f"Warning: Could not load template {template_path}: {e}")
        return None
    
    def build_claude_md_content(self, config: dict, project_name: str) -> str:
        """
        Build the complete CLAUDE.md content based on configuration.
        
        Args:
            config: User configuration dictionary
            project_name: Name of the project
            
        Returns:
            Complete CLAUDE.md content
        """
        content_parts = []
        
        # Start with base template
        content_parts.append(self.load_base_template())
        
        # Add project type context
        if config.get('project_type') and config['project_type'] != "Other/Custom":
            content_parts.append(f"""
## Project Type: {config['project_type']}

This project is a {config['project_type']}. Keep this context in mind when providing suggestions and code examples.
""")
        
        # Add language-specific rules
        for language in config.get('languages', []):
            if language != "Other/Custom":
                template_content = self.load_language_template(language)
                if template_content:
                    content_parts.append(f"\n{template_content}")
        
        # Add framework-specific rules (avoid duplicates from dependencies)
        processed_frameworks = set()
        for framework in config.get('frameworks', []):
            if framework != "Other/Custom" and framework not in processed_frameworks:
                # Mark this framework and its dependencies as processed
                processed_frameworks.add(framework)
                if framework in FRAMEWORK_DEPENDENCIES:
                    processed_frameworks.update(FRAMEWORK_DEPENDENCIES[framework])
                
                template_content = self.load_framework_template(framework)
                if template_content:
                    content_parts.append(f"\n{template_content}")
        
        # Add cloud-specific rules
        if config.get('cloud_platform') and config['cloud_platform'] != "Other/Custom":
            template_content = self.load_cloud_template(config['cloud_platform'])
            if template_content:
                content_parts.append(f"\n{template_content}")
        
        # Add database-specific rules
        for database in config.get('databases', []):
            if database != "Other/Custom":
                template_content = self.load_database_template(database)
                if template_content:
                    content_parts.append(f"\n{template_content}")
        
        # Add additional tools context
        tools_to_show = [tool for tool in config.get('additional_tools', []) if tool != "Other/Custom"]
        if tools_to_show:
            tools_section = """
## Additional Tools & Services

This project uses the following additional tools and services:
"""
            for tool in tools_to_show:
                tools_section += f"- {tool}\n"
            tools_section += "\nConsider these tools when providing suggestions and recommendations."
            content_parts.append(tools_section)
        
        # Add project-specific section
        project_specific_section = f"""
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
*Generated with new-claude on {self._get_current_date()}*
"""
        content_parts.append(project_specific_section)
        
        return '\n'.join(content_parts)
    
    def _get_current_date(self) -> str:
        """Get the current date in a readable format."""
        from datetime import datetime
        return datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    def get_available_templates(self) -> dict:
        """
        Get information about available templates.
        
        Returns:
            Dictionary with template availability information
        """
        info = {
            'languages': [],
            'frameworks': [],
            'cloud_platforms': [],
            'databases': []
        }
        
        # Check language templates
        languages_dir = self.prompt_rules_dir / "languages"
        if languages_dir.exists():
            for lang_file, lang_name in LANGUAGE_FILES.items():
                if (languages_dir / f"{lang_name}.md").exists():
                    info['languages'].append(lang_file)
        
        # Check framework templates
        frameworks_dir = self.prompt_rules_dir / "frameworks"
        if frameworks_dir.exists():
            for fw_file, fw_name in FRAMEWORK_FILES.items():
                if (frameworks_dir / f"{fw_name}.md").exists():
                    info['frameworks'].append(fw_file)
        
        # Check cloud templates
        cloud_dir = self.prompt_rules_dir / "cloud"
        if cloud_dir.exists():
            for cloud_file, cloud_name in CLOUD_FILES.items():
                if (cloud_dir / f"{cloud_name}.md").exists():
                    info['cloud_platforms'].append(cloud_file)
        
        # Check database templates
        databases_dir = self.prompt_rules_dir / "databases"
        if databases_dir.exists():
            for db_file, db_name in DATABASE_FILES.items():
                if (databases_dir / f"{db_name}.md").exists():
                    info['databases'].append(db_file)
        
        return info