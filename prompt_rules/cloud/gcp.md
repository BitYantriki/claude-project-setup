
## Google Cloud Platform Guidelines

### General GCP Principles
- Follow Google Cloud Architecture Framework
- Use service accounts with minimal permissions
- Label all resources consistently
- Use Deployment Manager or Terraform
- Monitor costs with budget alerts

### Security
- Use Cloud IAM effectively
- Enable audit logging
- Use Cloud KMS for encryption
- Implement VPC Service Controls
- Use Secret Manager for secrets

### Compute
- Use appropriate machine types
- Implement managed instance groups
- Use Cloud Functions for serverless
- Configure proper firewall rules
- Use preemptible VMs when possible

### Storage
- Choose appropriate storage classes
- Use lifecycle management
- Enable versioning when needed
- Implement proper access controls
- Use customer-managed encryption keys

### Databases
- Use Cloud SQL for relational data
- Implement automatic backups
- Use read replicas for scaling
- Choose Firestore for NoSQL needs
- Monitor query performance

### Networking
- Use VPC for network isolation
- Implement Cloud Load Balancing
- Use Private Google Access
- Set up Cloud VPN or Interconnect
- Use Cloud CDN for content delivery
