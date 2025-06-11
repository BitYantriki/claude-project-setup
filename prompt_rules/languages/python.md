
## Python-Specific Guidelines

### Code Style
- Follow PEP 8 style guide
- Use 4 spaces for indentation
- Maximum line length: 88 characters (Black formatter default)
- Use snake_case for variables and functions
- Use PascalCase for classes
- Use UPPER_SNAKE_CASE for constants

### Type Hints
- Use type hints for all function signatures
- Use type hints for complex variables
- Import from `typing` module when needed
- Use `Optional[]` for nullable types
- Consider using `TypedDict` for complex dictionaries

### Python Best Practices
- Use f-strings for string formatting (Python 3.6+)
- Prefer list/dict/set comprehensions when readable
- Use context managers (with statements) for resource management
- Avoid mutable default arguments
- Use `__init__.py` files for packages
- Follow the Zen of Python (`import this`)

### Error Handling
- Use specific exception types
- Create custom exceptions when appropriate
- Use try/except/else/finally blocks properly
- Never use bare except clauses
- Log exceptions with traceback when appropriate

### Imports
- Group imports: standard library, third-party, local
- Use absolute imports
- Avoid wildcard imports (`from module import *`)
- Sort imports alphabetically within groups
- Remove unused imports

### Testing
- Use pytest as the testing framework
- Name test files `test_*.py` or `*_test.py`
- Use fixtures for test setup
- Use parametrize for testing multiple cases
- Mock external dependencies

### Virtual Environments
- Always use virtual environments
- Include requirements.txt or use Poetry/Pipenv
- Pin dependency versions
- Separate dev dependencies from production

### Documentation
- Use docstrings for all public modules, classes, and functions
- Follow Google or NumPy docstring style
- Include type information in docstrings if not using type hints
- Document exceptions that can be raised
