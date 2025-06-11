
## JavaScript-Specific Guidelines

### Code Style
- Use 2 spaces for indentation
- Use semicolons consistently (either always or never)
- Use single quotes for strings (unless template literals needed)
- Use camelCase for variables and functions
- Use PascalCase for classes and components
- Use UPPER_SNAKE_CASE for constants

### Modern JavaScript
- Use ES6+ features (const/let, arrow functions, destructuring)
- Prefer const over let, avoid var
- Use template literals for string interpolation
- Use async/await over promises when possible
- Use optional chaining (?.) and nullish coalescing (??)

### Best Practices
- Avoid global variables
- Use strict mode ('use strict')
- Handle asynchronous errors properly
- Use map/filter/reduce for array operations
- Avoid modifying objects/arrays directly (immutability)
- Use default parameters instead of checking undefined

### Module System
- Use ES modules (import/export)
- One component/class per file
- Named exports for utilities, default for components
- Organize imports: third-party, then local
- Use index.js for directory exports

### Error Handling
- Always catch promise rejections
- Use try/catch with async/await
- Create custom error classes when needed
- Log errors with context
- Handle network errors gracefully

### Testing
- Use Jest or Vitest for testing
- Name test files `*.test.js` or `*.spec.js`
- Write unit tests for utilities
- Use testing-library for UI components
- Mock external dependencies

### Performance
- Debounce/throttle event handlers
- Use Web Workers for CPU-intensive tasks
- Lazy load modules when appropriate
- Minimize DOM manipulation
- Use requestAnimationFrame for animations
