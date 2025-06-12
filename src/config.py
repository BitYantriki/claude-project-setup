#!/usr/bin/env python3
"""Configuration and constants for the Claude project creator."""

import os
from pathlib import Path
from typing import Dict, List

# Colors for terminal output
class Colors:
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    RED = '\033[0;31m'
    BLUE = '\033[0;34m'
    CYAN = '\033[0;36m'
    MAGENTA = '\033[0;35m'
    BROWN = '\033[0;33m'
    NC = '\033[0m'  # No Color

# Project types and their associated languages
PROJECT_TYPES = [
    "Frontend Web Application",
    "Backend API Service", 
    "Full-Stack Web Application",
    "Mobile Application",
    "Desktop Application",
    "CLI Tool/Utility",
    "Data Science/Analytics",
    "Machine Learning Project",
    "DevOps/Infrastructure",
    "Library/Package",
    "Microservice",
    "Other/Custom"
]

# Language to framework mappings
LANGUAGE_FRAMEWORKS: Dict[str, List[str]] = {
    "Python": ["Django", "Flask", "FastAPI", "Streamlit", "Jupyter"],
    "JavaScript": ["Express", "React", "Vue", "Angular", "Next.js", "Svelte", "Node.js"],
    "TypeScript": ["Express", "React", "Vue", "Angular", "Next.js", "NestJS"],
    "Java": ["Spring", "Spring-Boot"],
    "Go": ["Gin", "Echo", "Fiber"],
    "Rust": ["Actix", "Rocket", "Warp"],
    "C#": ["ASP.NET", "Blazor"],
    "Swift": ["SwiftUI", "UIKit"],
    "Kotlin": ["Spring-Boot", "Android"],
    "Dart": ["Flutter"]
}

# Project type to language mappings
PROJECT_TYPE_LANGUAGES: Dict[str, List[str]] = {
    "Frontend Web Application": ["JavaScript", "TypeScript"],
    "Backend API Service": ["Python", "JavaScript", "TypeScript", "Java", "Go", "Rust", "C#", "PHP", "Ruby"],
    "Full-Stack Web Application": ["JavaScript", "TypeScript", "Python", "Java"],
    "Mobile Application": ["JavaScript", "TypeScript", "Swift", "Kotlin", "Java", "Dart"],
    "Desktop Application": ["JavaScript", "TypeScript", "Python", "Java", "C#", "C++", "Rust", "Go"],
    "CLI Tool/Utility": ["Python", "Go", "Rust", "JavaScript", "TypeScript", "Bash"],
    "Data Science/Analytics": ["Python", "R", "Julia", "JavaScript"],
    "Machine Learning Project": ["Python", "R", "Julia"],
    "DevOps/Infrastructure": ["Python", "Go", "Bash", "JavaScript", "TypeScript"],
    "Library/Package": ["Python", "JavaScript", "TypeScript", "Java", "Go", "Rust", "C#", "C++"],
    "Microservice": ["Python", "JavaScript", "TypeScript", "Java", "Go", "Rust", "C#"],
    "Other/Custom": ["Python", "JavaScript", "TypeScript", "Java", "Go", "Rust", "C#", "C++", "Ruby", "PHP"]
}

# All available languages
ALL_LANGUAGES = [
    "Python", "JavaScript", "TypeScript", "Java", "Go", "Rust", "C#", "C++",
    "Ruby", "PHP", "Swift", "Kotlin", "Dart", "R", "Julia", "Bash"
]

# Cloud platforms
CLOUD_PLATFORMS = [
    "AWS", "Google Cloud Platform (GCP)", "Microsoft Azure", "Heroku",
    "DigitalOcean", "Vercel", "Netlify", "Railway", "Fly.io", "Other/Custom"
]

# Databases
DATABASES = [
    "PostgreSQL", "MySQL", "MongoDB", "SQLite", "Redis", "Elasticsearch",
    "DynamoDB", "Firestore", "Cassandra", "InfluxDB", "Other/Custom"
]

# Additional tools
ADDITIONAL_TOOLS = [
    "Redis (Caching)", "Docker", "Kubernetes", "GitHub Actions", "GitLab CI",
    "Jenkins", "Terraform", "Ansible", "Nginx", "Apache", "Other/Custom"
]

# File name mappings for templates
LANGUAGE_FILES: Dict[str, str] = {
    "Python": "python",
    "JavaScript": "javascript", 
    "TypeScript": "typescript",
    "Java": "java",
    "Go": "go",
    "Rust": "rust",
    "C#": "csharp",
    "C++": "cpp",
    "Ruby": "ruby",
    "PHP": "php",
    "Swift": "swift",
    "Kotlin": "kotlin",
    "Dart": "dart",
    "R": "r",
    "Julia": "julia",
    "Bash": "bash"
}

FRAMEWORK_FILES: Dict[str, str] = {
    "Django": "django",
    "Flask": "flask",
    "FastAPI": "fastapi",
    "Streamlit": "streamlit",
    "Express": "express",
    "React": "react",
    "Vue": "vue",
    "Angular": "angular",
    "Next.js": "nextjs",
    "NestJS": "nestjs",
    "Svelte": "svelte",
    "Spring": "spring",
    "Spring-Boot": "spring-boot",
    "Gin": "gin",
    "Echo": "echo",
    "Fiber": "fiber",
    "Actix": "actix",
    "Rocket": "rocket",
    "ASP.NET": "aspnet",
    "Blazor": "blazor",
    "SwiftUI": "swiftui",
    "UIKit": "uikit",
    "Flutter": "flutter"
}

CLOUD_FILES: Dict[str, str] = {
    "AWS": "aws",
    "Google Cloud Platform (GCP)": "gcp",
    "Microsoft Azure": "azure",
    "Heroku": "heroku",
    "DigitalOcean": "digitalocean",
    "Vercel": "vercel",
    "Netlify": "netlify"
}

DATABASE_FILES: Dict[str, str] = {
    "PostgreSQL": "postgresql",
    "MySQL": "mysql",
    "MongoDB": "mongodb",
    "SQLite": "sqlite",
    "Redis": "redis",
    "Elasticsearch": "elasticsearch",
    "DynamoDB": "dynamodb",
    "Firestore": "firestore",
    "Cassandra": "cassandra",
    "InfluxDB": "influxdb"
}

# Framework dependencies - which base frameworks to include
FRAMEWORK_DEPENDENCIES: Dict[str, List[str]] = {
    "Next.js": ["React"],
    "NestJS": ["Express"],
    "Spring-Boot": ["Spring"],
    "Android": ["Kotlin"],
}

# Get script directory
def get_script_dir() -> Path:
    """Get the directory where the script is located."""
    return Path(__file__).parent.parent

def get_prompt_rules_dir() -> Path:
    """Get the prompt rules directory."""
    return get_script_dir() / "prompt_rules"