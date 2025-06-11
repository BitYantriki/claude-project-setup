
## Express.js-Specific Guidelines

### Application Structure
- Use modular route organization
- Separate concerns (routes, controllers, services)
- Use middleware for cross-cutting concerns
- Implement proper error handling middleware
- Use environment-based configuration

### Middleware
- Order middleware correctly
- Use built-in middleware appropriately
- Create custom middleware for reusable logic
- Handle errors in middleware
- Use async middleware properly

### Routing
- Use express.Router() for modular routes
- Follow RESTful conventions
- Use proper HTTP methods
- Implement parameter validation
- Use route parameters and query strings appropriately

### Security
- Use helmet.js for security headers
- Implement rate limiting
- Validate and sanitize inputs
- Use CORS properly
- Implement authentication/authorization middleware

### Error Handling
- Create centralized error handling
- Use custom error classes
- Return appropriate HTTP status codes
- Log errors properly
- Don't expose internal errors to clients

### Performance
- Use compression middleware
- Implement caching strategies
- Use streaming for large responses
- Optimize database queries
- Consider using a reverse proxy
