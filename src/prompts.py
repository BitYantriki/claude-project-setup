#!/usr/bin/env python3
"""Interactive prompts for the Claude project creator."""

from typing import List, Optional, Tuple
from config import Colors, PROJECT_TYPES, PROJECT_TYPE_LANGUAGES, ALL_LANGUAGES, CLOUD_PLATFORMS, DATABASES, ADDITIONAL_TOOLS, LANGUAGE_FRAMEWORKS


class PromptManager:
    """Manages all user interactions and prompts."""
    
    def __init__(self):
        self.colors = Colors()
    
    def print_colored(self, text: str, color: str = Colors.NC) -> None:
        """Print text with color."""
        print(f"{color}{text}{self.colors.NC}")
    
    def print_header(self, text: str) -> None:
        """Print a header with blue color."""
        self.print_colored(text, self.colors.BLUE)
    
    def print_success(self, text: str) -> None:
        """Print success message in green."""
        self.print_colored(text, self.colors.GREEN)
    
    def print_warning(self, text: str) -> None:
        """Print warning message in yellow."""
        self.print_colored(text, self.colors.YELLOW)
    
    def print_error(self, text: str) -> None:
        """Print error message in red."""
        self.print_colored(text, self.colors.RED)
    
    def print_info(self, text: str) -> None:
        """Print info message in cyan."""
        self.print_colored(text, self.colors.CYAN)
    
    def show_welcome(self, project_path: str, is_new_project: bool) -> None:
        """Show welcome message."""
        self.print_header("🚀 Claude Project Configuration Generator")
        self.print_header("=========================================")
        
        if is_new_project:
            print(f"\nThis tool will create a new project and generate a customized CLAUDE.md file")
            self.print_success(f"Project location: {project_path}")
        else:
            print(f"\nThis tool will generate a customized CLAUDE.md file")
            self.print_success(f"for your existing project at: {project_path}")
        
        self.print_colored("\nLet's configure your project step by step...", self.colors.MAGENTA)
        self.print_colored("This will take you through 6 quick steps to customize your project setup.", self.colors.BROWN)
        self.print_colored("You can always select 'Other/Custom' or skip questions with '0'.", self.colors.BROWN)
    
    def select_single_option(self, title: str, options: List[str], allow_skip: bool = True) -> Optional[str]:
        """
        Present a single-choice selection to the user.
        
        Args:
            title: The question/prompt title
            options: List of options to choose from
            allow_skip: Whether to allow skipping with '0'
            
        Returns:
            Selected option or None if skipped
        """
        self.print_header(f"\n{title}")
        print()
        
        # Show options with numbers
        for i, option in enumerate(options, 1):
            print(f"  {i}) {option}")
        
        if allow_skip:
            print()
            self.print_colored("  0) Skip this question", self.colors.RED)
        
        print()
        
        while True:
            try:
                choice = input(f"👉 Enter your choice (1-{len(options)}{', 0 to skip' if allow_skip else ''}): ").strip()
                
                if allow_skip and choice == "0":
                    return None
                
                choice_num = int(choice)
                if 1 <= choice_num <= len(options):
                    selected = options[choice_num - 1]
                    self.print_success(f"✅ Selected: {selected}")
                    return selected
                else:
                    self.print_error(f"❌ Invalid choice. Please enter a number between 1 and {len(options)}")
                    
            except ValueError:
                self.print_error("❌ Invalid input. Please enter a number.")
            except KeyboardInterrupt:
                print("\n\nOperation cancelled by user.")
                return None
    
    def select_multiple_options(self, title: str, options: List[str]) -> List[str]:
        """
        Present a multi-choice selection to the user.
        
        Args:
            title: The question/prompt title
            options: List of options to choose from
            
        Returns:
            List of selected options
        """
        self.print_header(f"\n{title}")
        self.print_colored("📝 Instructions: Select options one at a time", self.colors.BROWN)
        self.print_colored("   • Type a number and press Enter", self.colors.BROWN)
        self.print_colored("   • Repeat for each additional choice", self.colors.BROWN)
        self.print_colored("   • Type 0 when done", self.colors.BROWN)
        print()
        
        selected = []
        
        while True:
            # Show available options
            for i, option in enumerate(options, 1):
                status = "✅" if option in selected else "  "
                print(f"  {status} {i}) {option}")
            
            print()
            self.print_colored("  0) Done selecting", self.colors.GREEN)
            
            # Show currently selected
            if selected:
                print()
                self.print_success("✅ Currently selected:")
                for item in selected:
                    self.print_colored(f"   {item}", self.colors.GREEN)
            
            print()
            
            try:
                choice = input(f"👉 Enter your choice (1-{len(options)}, 0 when done): ").strip()
                
                if choice == "0":
                    break
                
                choice_num = int(choice)
                if 1 <= choice_num <= len(options):
                    option = options[choice_num - 1]
                    if option in selected:
                        self.print_warning(f"⚠️  Already selected: {option}")
                    else:
                        selected.append(option)
                        self.print_success(f"✅ Added: {option}")
                else:
                    self.print_error(f"❌ Invalid choice. Please enter a number between 1 and {len(options)}")
                    
            except ValueError:
                self.print_error("❌ Invalid input. Please enter a number.")
            except KeyboardInterrupt:
                print("\n\nOperation cancelled by user.")
                break
            
            print("\n" + "="*50 + "\n")
        
        return selected
    
    def get_project_configuration(self) -> dict:
        """
        Walk through all configuration steps and return the complete configuration.
        
        Returns:
            Dictionary containing all user selections
        """
        config = {}
        
        # Step 1: Project Type
        self.print_header("\n============================================")
        self.print_header("📋 Step 1: Project Type")
        self.print_header("============================================")
        
        config['project_type'] = self.select_single_option(
            "🎯 What type of project are you building?",
            PROJECT_TYPES
        )
        
        # Step 2: Languages
        self.print_header("\n============================================")
        self.print_header("💻 Step 2: Programming Languages")
        self.print_header("============================================")
        
        # Get suggested languages based on project type
        suggested_languages = []
        if config['project_type'] and config['project_type'] in PROJECT_TYPE_LANGUAGES:
            suggested_languages = PROJECT_TYPE_LANGUAGES[config['project_type']]
            self.print_colored("💡 Based on your project type, here are the most relevant languages:", self.colors.BROWN)
        
        # Use suggested languages if available, otherwise all languages
        languages_to_show = suggested_languages if suggested_languages else ALL_LANGUAGES
        languages_to_show = [lang for lang in languages_to_show if lang != "Other/Custom"]
        languages_to_show.append("Other/Custom")
        
        self.print_colored("💡 Multiple languages can be selected for complex projects", self.colors.BROWN)
        self.print_colored("   Example: JavaScript for frontend + Python for backend", self.colors.BROWN)
        
        config['languages'] = self.select_multiple_options(
            "🔧 Which programming languages will you use?",
            languages_to_show
        )
        
        # Step 3: Frameworks
        self.print_header("\n============================================")
        self.print_header("🏗️ Step 3: Frameworks & Libraries")
        self.print_header("============================================")
        
        # Collect frameworks for selected languages
        available_frameworks = set()
        for lang in config['languages']:
            if lang in LANGUAGE_FRAMEWORKS:
                available_frameworks.update(LANGUAGE_FRAMEWORKS[lang])
        
        if available_frameworks:
            framework_list = sorted(list(available_frameworks))
            framework_list.append("Other/Custom")
            
            config['frameworks'] = self.select_multiple_options(
                "🏗️ Which frameworks/libraries will you use?",
                framework_list
            )
        else:
            config['frameworks'] = []
        
        # Step 4: Cloud Platform
        self.print_header("\n============================================")
        self.print_header("☁️ Step 4: Cloud Platform")
        self.print_header("============================================")
        
        self.print_colored("💡 Select a cloud platform for deployment (optional)", self.colors.BROWN)
        config['cloud_platform'] = self.select_single_option(
            "☁️ Which cloud platform will you use for deployment?",
            CLOUD_PLATFORMS
        )
        
        # Step 5: Databases
        self.print_header("\n============================================")
        self.print_header("🗄️ Step 5: Databases")
        self.print_header("============================================")
        
        self.print_colored("💡 Multiple databases can be selected for different purposes", self.colors.BROWN)
        self.print_colored("   Example: PostgreSQL for main data + Redis for caching", self.colors.BROWN)
        
        config['databases'] = self.select_multiple_options(
            "🗄️ Which databases will your project use?",
            DATABASES
        )
        
        # Step 6: Additional Tools
        self.print_header("\n============================================")
        self.print_header("🛠️ Step 6: Additional Tools & Services")
        self.print_header("============================================")
        
        self.print_colored("💡 Multiple tools and services can be selected", self.colors.BROWN)
        self.print_colored("   Example: Docker for containers + GitHub Actions for CI/CD", self.colors.BROWN)
        
        config['additional_tools'] = self.select_multiple_options(
            "🛠️ Additional tools and services you'll use:",
            ADDITIONAL_TOOLS
        )
        
        # Final summary
        self.print_header("\n============================================")
        self.print_header("🏁 Configuration Complete")
        self.print_header("============================================")
        
        return config
    
    def show_configuration_summary(self, config: dict) -> None:
        """Show a summary of the user's configuration."""
        self.print_info("\n📋 Configuration Summary:")
        
        if config.get('project_type'):
            self.print_colored(f"  🎯 Project Type: {config['project_type']}", self.colors.MAGENTA)
        
        if config.get('languages'):
            filtered_languages = [lang for lang in config['languages'] if lang != "Other/Custom"]
            if filtered_languages:
                self.print_colored(f"  🔧 Languages: {', '.join(filtered_languages)}", self.colors.CYAN)
        
        if config.get('frameworks'):
            filtered_frameworks = [fw for fw in config['frameworks'] if fw != "Other/Custom"]
            if filtered_frameworks:
                self.print_colored(f"  🏗️ Frameworks: {', '.join(filtered_frameworks)}", self.colors.CYAN)
        
        if config.get('cloud_platform') and config['cloud_platform'] != "Other/Custom":
            self.print_colored(f"  ☁️ Cloud: {config['cloud_platform']}", self.colors.CYAN)
        
        if config.get('databases'):
            filtered_databases = [db for db in config['databases'] if db != "Other/Custom"]
            if filtered_databases:
                self.print_colored(f"  🗄️ Databases: {', '.join(filtered_databases)}", self.colors.CYAN)
        
        if config.get('additional_tools'):
            filtered_tools = [tool for tool in config['additional_tools'] if tool != "Other/Custom"]
            if filtered_tools:
                self.print_colored(f"  🛠️ Tools: {', '.join(filtered_tools)}", self.colors.CYAN)