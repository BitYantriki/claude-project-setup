
## MongoDB-Specific Guidelines

### Schema Design
- Design for your queries
- Embed when possible, reference when necessary
- Avoid deeply nested documents
- Use appropriate data types
- Consider document size limits

### Indexing
- Create indexes for common queries
- Use compound indexes effectively
- Monitor index usage
- Use sparse indexes when appropriate
- Avoid too many indexes

### Performance
- Use projection to limit fields
- Implement proper pagination
- Use aggregation pipeline efficiently
- Monitor query performance
- Use read preferences appropriately

### Best Practices
- Use MongoDB drivers properly
- Implement proper error handling
- Use transactions when needed
- Handle connection pooling
- Use bulk operations for efficiency

### Security
- Enable authentication
- Use role-based access control
- Encrypt data in transit
- Implement field-level encryption
- Regular security audits
