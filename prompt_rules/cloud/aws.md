
## AWS-Specific Guidelines

### General AWS Principles
- Follow AWS Well-Architected Framework
- Use least privilege IAM policies
- Tag all resources consistently
- Use CloudFormation or Terraform for IaC
- Monitor costs and set billing alerts

### Security
- Never commit AWS credentials
- Use IAM roles instead of access keys
- Enable MFA for all users
- Encrypt data at rest and in transit
- Use AWS Secrets Manager for secrets

### Compute (EC2/Lambda)
- Use appropriate instance types
- Implement auto-scaling
- Use Lambda for event-driven workloads
- Set up proper VPC configuration
- Use latest AMIs and update regularly

### Storage (S3)
- Use appropriate storage classes
- Implement lifecycle policies
- Enable versioning for important buckets
- Use proper bucket policies
- Enable server-side encryption

### Database (RDS/DynamoDB)
- Use Multi-AZ for production
- Implement automated backups
- Use read replicas for scaling
- Choose appropriate instance sizes
- Monitor performance metrics

### Networking
- Use VPCs for network isolation
- Implement proper security groups
- Use private subnets for databases
- Set up VPN or Direct Connect
- Use CloudFront for static content

### Monitoring
- Use CloudWatch for metrics
- Set up appropriate alarms
- Use X-Ray for distributed tracing
- Implement centralized logging
- Create custom dashboards
