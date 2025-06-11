
## PostgreSQL-Specific Guidelines

### Database Design
- Use proper normalization (3NF minimum)
- Choose appropriate data types
- Use constraints to ensure data integrity
- Implement proper indexing strategy
- Use foreign keys with proper cascading

### Performance
- Use EXPLAIN ANALYZE for query optimization
- Create indexes on frequently queried columns
- Use partial indexes when appropriate
- Implement table partitioning for large tables
- Use connection pooling

### Best Practices
- Use transactions appropriately
- Implement proper error handling
- Use prepared statements
- Avoid N+1 queries
- Use CTEs for complex queries

### Security
- Use role-based access control
- Encrypt sensitive data
- Use SSL for connections
- Implement row-level security when needed
- Regular security updates

### Maintenance
- Regular VACUUM and ANALYZE
- Monitor table bloat
- Implement proper backup strategy
- Use streaming replication
- Monitor slow queries
