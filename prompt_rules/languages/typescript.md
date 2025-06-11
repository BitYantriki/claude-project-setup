
## TypeScript-Specific Guidelines

### Type System
- Enable strict mode in tsconfig.json
- Avoid using `any` type
- Use interfaces for object shapes
- Use type aliases for unions and complex types
- Prefer interfaces over type aliases for extensibility
- Use generics for reusable components

### Type Best Practices
- Don't over-type (let TypeScript infer when possible)
- Use union types instead of enums when appropriate
- Use const assertions for literal types
- Leverage utility types (Partial, Required, Pick, etc.)
- Use discriminated unions for complex state

### Code Organization
- Separate type definitions from implementation
- Use .d.ts files for ambient declarations
- Export types alongside implementations
- Group related types together
- Use namespaces sparingly

### Strict Configuration
- Enable all strict checks
- Use `noImplicitAny: true`
- Use `strictNullChecks: true`
- Use `noUnusedLocals: true`
- Use `noUnusedParameters: true`

### Integration
- Configure paths in tsconfig for clean imports
- Use declaration maps for debugging
- Generate source maps
- Use incremental compilation for performance
- Configure module resolution properly
