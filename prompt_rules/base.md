# Claude Project Guidelines

## General Development Principles

### Mandatory rules
- Don't be a yes-man. If you don't understand a request, ask for clarification. If you don't think a request is a good idea, explain why and suggest alternatives.
- Verify your responses, with available information, especially if I have already mentioned any files documents, or any feedback has been given.
- When I ask you to follow any chain of thought, I want absolute compliance.
- When writing production code, follow general coding practices of defensive coding, fail/return early. and exception/and error handling
- For testing code, go with "assert", and make the test fail, if assumptions aren't met. (looking over errors and moving ahead, needs to be approved by me, as an explicit exception)

### Code Quality
- Write clean, readable, and maintainable code
- Follow DRY (Don't Repeat Yourself) principle
- Use meaningful and descriptive names for variables, functions, and classes
- Keep functions small and focused on a single responsibility
- Prefer composition over inheritance
- Write self-documenting code, add comments only when necessary

### Error Handling
- Always handle errors appropriately
- Never silently ignore errors
- Provide meaningful error messages
- Log errors with sufficient context
- Fail fast and fail clearly
- Use proper exception types

### Security Best Practices
- Never hardcode credentials, secrets, or API keys
- Use environment variables for sensitive configuration
- Validate and sanitize all user inputs
- Follow the principle of least privilege
- Keep dependencies up to date
- Never commit sensitive data to version control

### Performance Guidelines
- Optimize for readability first, performance second
- Profile before optimizing
- Use appropriate data structures and algorithms
- Implement caching where beneficial
- Avoid premature optimization
- Consider lazy loading for expensive operations

### Testing Standards
- Write tests for all new features
- Follow test-driven development when possible
- Write descriptive test names that explain what is being tested
- Test edge cases and error conditions
- Maintain good test coverage (aim for 80% minimum)
- Keep tests independent and isolated

### Version Control
- Write clear, descriptive commit messages
- Use conventional commit format (feat:, fix:, docs:, etc.)
- Keep commits atomic and focused
- Never commit broken code to main branch
- Review changes before committing
- Keep pull requests small and focused

### Documentation
- Document all public APIs
- Keep README.md up to date
- Include examples in documentation
- Document non-obvious design decisions
- Maintain a changelog for user-facing changes
- Use inline documentation sparingly but effectively

### Code Review Standards
- Be constructive and respectful in reviews
- Focus on the code, not the person
- Suggest improvements, don't just criticize
- Approve when code meets standards, not perfection
- Learn from feedback and improve

### Refactoring Guidelines
- Refactor regularly to maintain code quality
- Make refactoring commits separate from feature commits
- Ensure tests pass before and after refactoring
- Update documentation when refactoring changes APIs
- Consider backwards compatibility