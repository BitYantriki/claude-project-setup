
## Django-Specific Guidelines

### Project Structure
- Follow Django's app-based architecture
- Keep apps focused and reusable
- Use proper app naming conventions
- Separate settings by environment
- Use Django's built-in features

### Models
- Use appropriate field types
- Implement proper model relationships
- Add db_index for frequently queried fields
- Use model managers for complex queries
- Override save() method carefully

### Views
- Use class-based views when appropriate
- Keep views thin, logic in models/services
- Use Django's generic views
- Implement proper permission checks
- Handle GET and POST separately

### Templates
- Use template inheritance
- Keep logic minimal in templates
- Use template tags and filters
- Implement proper escaping
- Use static files properly

### Forms
- Use Django forms for validation
- Implement custom validators
- Use ModelForms when appropriate
- Handle form errors properly
- Use CSRF protection

### Security
- Keep SECRET_KEY secret
- Use Django's auth system
- Implement proper permissions
- Use HTTPS in production
- Keep Django updated

### Database
- Write efficient queries
- Use select_related and prefetch_related
- Implement database indexes
- Use migrations properly
- Avoid N+1 queries

### Testing
- Use Django's TestCase
- Test models, views, and forms
- Use fixtures for test data
- Test permissions and auth
- Use Django's test client
