
## React-Specific Guidelines

### Component Guidelines
- Use functional components with hooks
- One component per file
- Keep components small and focused
- Extract reusable logic into custom hooks
- Use composition over inheritance

### State Management
- Lift state up when needed
- Use local state when possible
- Consider Context API for cross-cutting concerns
- Use proper state management library for complex apps
- Avoid unnecessary re-renders

### Hooks Best Practices
- Follow Rules of Hooks
- Use useCallback for expensive callbacks
- Use useMemo for expensive computations
- Create custom hooks for reusable logic
- Cleanup in useEffect when needed

### Performance
- Use React.memo for expensive components
- Implement proper key props for lists
- Lazy load components with React.lazy
- Use Suspense for loading states
- Avoid inline function definitions in render

### Styling
- Use CSS Modules or styled-components
- Keep styles close to components
- Use consistent naming conventions
- Implement responsive design
- Consider CSS-in-JS performance implications

### Testing
- Use React Testing Library
- Test user behavior, not implementation
- Use screen queries
- Avoid testing internal state
- Mock external dependencies
