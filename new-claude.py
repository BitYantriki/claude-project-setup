#!/usr/bin/env python3
"""
Claude Project Creator - Entry Point

This is the main entry point that replaces the shell script version.
"""

import sys
import os
from pathlib import Path

# Add the src directory to Python path
script_dir = Path(__file__).parent
src_dir = script_dir / "src"
sys.path.insert(0, str(src_dir))

# Import and run the main application
from new_claude import main

if __name__ == "__main__":
    main()