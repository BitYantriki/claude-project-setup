
## Redis-Specific Guidelines

### Data Structure Selection
- Use appropriate data types (strings, hashes, lists, sets)
- Consider memory usage of different types
- Use sorted sets for leaderboards/rankings
- Use bitmaps for boolean data
- Leverage HyperLogLog for cardinality

### Key Design
- Use consistent naming conventions
- Include namespaces in keys
- Set appropriate TTLs
- Avoid very long key names
- Use colons for hierarchy (user:1234:profile)
- For any use-cases with possibly "> 100k keys", use a hash with a key prefix instead of individual keys (but ask me first)

### Performance
- Use pipelining for bulk operations
- Implement connection pooling
- Monitor memory usage
- Use Lua scripts for atomic operations
- Consider using Redis Cluster for scaling

### Caching Strategies
- Implement cache-aside pattern
- Use write-through when appropriate
- Handle cache invalidation properly
- Implement cache warming
- Monitor cache hit rates

### Best Practices
- Handle connection failures gracefully
- Implement circuit breakers
- Use Redis persistence appropriately
- Monitor slow commands
- Regular backups for persistent data
