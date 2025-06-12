#!/usr/bin/env python3
"""
Claude Project Creator Package

A tool to create intelligent project templates with customized AI guidelines.
"""

__version__ = "2.0.0"
__author__ = "Claude Project Creator"
__description__ = "Create intelligent project templates with customized AI guidelines"

from .new_claude import ClaudeProjectCreator
from .prompts import PromptManager
from .template_manager import TemplateManager
from .file_generator import FileGenerator
from .project_manager import ProjectManager

__all__ = [
    'ClaudeProjectCreator',
    'PromptManager', 
    'TemplateManager',
    'FileGenerator',
    'ProjectManager'
]