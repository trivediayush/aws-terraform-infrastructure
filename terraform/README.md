# AWS Infrastructure Terraform Repository

This repository contains complete production-ready Terraform infrastructure for AWS, derived from the provided infrastructure estimation PDF. The repository provides four independent deployment environments combining different staging options with production infrastructure and shared infrastructure configurations.

## Architecture Overview

This Terraform repository implements the infrastructure specified in the provided estimation PDF, offering four distinct deployment combinations:

1. **Staging Option 1 + Production + Shared Single-AZ**
2. **Staging Option 1 + Production + Shared Multi-AZ**
3. **Staging Option 2 + Production + Shared Single-AZ**
4. **Staging Option 2 + Production + Shared Multi-AZ**

### PDF-Derived Requirements

The infrastructure specifications are directly derived from the provided estimation PDF, which includes:

- **Staging Option 1**: Amazon Lightsail (2 vCPU, 8 GB RAM, 160 GB SSD, IPv6)
- **Staging Option 2**: Amazon EC2 (t4g.large, 2 vCPU, 8 GB RAM, ARM64, 30 GB gp3)
- **Production**: Amazon EKS with 2 worker nodes (t3.xlarge, 4 vCPU, 16 GB RAM, 100 GB gp3 each)
- **Shared Infrastructure Single-AZ**: RDS PostgreSQL (db.t3.medium, 100 GB gp3) and Redis (cache.t4g.medium)
- **Shared Infrastructure Multi-AZ**: RDS PostgreSQL Multi-AZ and Redis/Valkey Multi-AZ with automatic failover
- **Supporting Services**: ALB, S3, ECR, VPC networking, NAT Gateway

## Four Deployment Variants

### 1. Staging Option 1 + Production + Shared Single-AZ

**Staging**: Amazon Lightsail instance  
**Production**: EKS cluster with 2 worker nodes  
**Shared Infrastructure**: RDS PostgreSQL Single-AZ + Redis Single-AZ  
**Directory**: `terraform/environments/staging-option-1-prod-single-az/`

**Use Case**: Cost-effective deployment with Lightsail staging and single-AZ shared infrastructure for development/testing environments.

### 2. Staging Option 1 + Production + Shared Multi-AZ

**Staging**: Amazon Lightsail instance  
**Production**: EKS cluster with 2 worker nodes  
**Shared Infrastructure**: RDS PostgreSQL Multi-AZ + Redis/Valkey Multi-AZ  
**Directory**: `terraform/environments/staging-option-1-prod-multi-az/`

**Use Case**: Production-grade deployment with Lightsail staging and high-availability Multi-AZ shared infrastructure.

### 3. Staging Option 2 + Production + Shared Single-AZ

**Staging**: Amazon EC2 (t4g.large) with VPC networking  
**Production**: EKS cluster with 2 worker nodes  
**Shared Infrastructure**: RDS PostgreSQL Single-AZ + Redis Single-AZ  
**Directory**: `terraform/environments/staging-option-2-prod-single-az/`

**Use Case**: Flexible staging with full VPC control using EC2 and cost-effective single-AZ shared infrastructure.

### 4. Staging Option 2 + Production + Shared Multi-AZ

**Staging**: Amazon EC2 (t4g.large) with VPC networking  
**Production**: EKS cluster with 2 worker nodes  
**Shared Infrastructure**: RDS PostgreSQL Multi-AZ + Redis/Valkey Multi-AZ  
**Directory**: `terraform/environments/staging-option-2-prod-multi-az/`

**Use Case**: Production-grade deployment with EC2 staging and high-availability Multi-AZ shared infrastructure.

## Directory Structure

```
terraform/
│
├── modules/
│   ├── networking/              # VPC, subnets, route tables, NAT Gateway
│   ├── staging-lightsail/      # Lightsail instance configuration
│   ├── staging-ec2/            # EC2 instance with VPC networking
│   ├── production-eks/         # EKS cluster and worker nodes
│   ├── alb/                    # Application Load Balancer
│   ├── s3/                     # S3 bucket with security controls
│   ├── ecr/                    # ECR container registry
│   ├── rds-single-az/          # RDS PostgreSQL Single-AZ
│   ├── rds-multi-az/           # RDS PostgreSQL Multi-AZ
│   ├── redis-single-az/        # Redis Single-AZ
│   └── redis-multi-az/         # Redis/Valkey Multi-AZ
│
├── environments/
│   ├── staging-option-1-prod-single-az/
│   ├── staging-option-1-prod-multi-az/
│   ├── staging-option-2-prod-single-az/
│   └── staging-option-2-prod-multi-az/
│
└── README.md                    # This file
```

## Services Used

### Compute Services
- **Amazon Lightsail**: Managed virtual private server (Staging Option 1)
- **Amazon EC2**: Virtual servers in the cloud (Staging Option 2)
- **Amazon EKS**: Managed Kubernetes service (Production)

### Database Services
- **Amazon RDS PostgreSQL**: Managed relational database
- **Amazon ElastiCache Redis**: Managed in-memory cache

### Storage Services
- **Amazon S3**: Object storage
- **Amazon EBS**: Block storage for EC2 and EKS nodes
- **Amazon ECR**: Container image registry

### Networking Services
- **Amazon VPC**: Virtual private cloud
- **Application Load Balancer**: Layer 7 load balancing
- **NAT Gateway**: Internet access for private subnets
- **Route Tables**: Network routing configuration
- **Security Groups**: Network firewall rules

## Security Philosophy

This repository implements production-grade security following AWS best practices:

### Network Security
- **Private Subnets**: EKS nodes, RDS, and Redis deployed in private subnets
- **Security Groups**: Restrictive inbound rules following principle of least privilege
- **VPC Isolation**: Complete network isolation with custom VPC configuration
- **No Public Database**: RDS and Redis are not publicly accessible
- **Configurable SSH Access**: SSH access restricted via CIDR blocks

### IAM Security
- **Least Privilege**: IAM roles have only required permissions
- **No AdministratorAccess**: Service-specific policies only
- **Instance Roles**: EC2 and EKS nodes use appropriate IAM roles
- **No Hard-Coded Credentials**: Passwords passed as variables

### Data Security
- **Encryption at Rest**: All storage encrypted (EBS, RDS, Redis, S3, ECR)
- **Encryption in Transit**: SSL/TLS enabled where supported
- **IMDSv2**: Required for EC2 and EKS nodes to prevent SSRF attacks
- **S3 Block Public Access**: All public access blocked by default

### Access Security
- **Private EKS Endpoint**: EKS API server is private
- **No Public Endpoints**: Database and cache endpoints are private
- **AWS Credential Chain**: Uses standard AWS credential providers
- **Deletion Protection**: Enabled for RDS to prevent accidental deletion

## Single-AZ vs Multi-AZ

### Single-AZ Architecture
- **Cost**: Lower cost (no standby instances)
- **Availability**: No automatic failover
- **Recovery**: Manual intervention required
- **Data Loss**: Potential data loss since last backup
- **Use Case**: Development, testing, non-critical workloads

### Multi-AZ Architecture
- **Cost**: Higher cost (standby instances)
- **Availability**: Automatic failover in 1-2 minutes
- **Recovery**: Automatic failover with zero data loss for RDS
- **Data Loss**: Minimal data loss for Redis (asynchronous replication)
- **Use Case**: Production, critical applications, high availability requirements

### Trade-offs
- **Single-AZ**: Cost optimization vs availability
- **Multi-AZ**: Availability vs cost
- **Recommendation**: Multi-AZ for production, Single-AZ for development

## Cost Considerations

### Monthly Cost Estimates

**Staging Option 1 (Lightsail)**: ~$39.46/month
**Staging Option 2 (EC2)**: ~$35.66/month
**Production EKS**: ~$430.53/month + usage
**Shared Single-AZ**: ~$151.61/month
**Shared Multi-AZ**: ~$307.06/month

**Total Ranges**:
- **Option 1 + Single-AZ**: ~$621.60/month + usage
- **Option 1 + Multi-AZ**: ~$777.05/month + usage
- **Option 2 + Single-AZ**: ~$617.80/month + usage
- **Option 2 + Multi-AZ**: ~$773.25/month + usage

### Usage-Based Charges
- **NAT Gateway**: $0.056 per GB data processed
- **ALB**: $0.008 per LCU-hour based on traffic
- **Data Transfer**: Inter-AZ, internet egress, cross-region charges
- **S3**: PUT/GET requests beyond included amounts

### Multi-AZ Premium
- **RDS Additional**: ~$90.48/month (standby instance)
- **Redis Additional**: ~$64.97/month (replica instance)
- **Total Multi-AZ Premium**: ~$155.45/month

## Deployment Procedure

### Prerequisites
1. AWS account with appropriate permissions
2. AWS credentials configured (AWS_PROFILE or environment variables)
3. Terraform 1.0+ installed
4. (Optional) S3 bucket and DynamoDB table for remote state

### Environment Deployment

Each environment is deployed independently:

```bash
# Navigate to desired environment
cd terraform/environments/staging-option-1-prod-single-az

# Copy and configure variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# (Optional) Configure backend
cp backend.tf.example backend.tf
# Edit backend.tf with your S3 bucket and DynamoDB table

# Initialize Terraform
terraform init

# Format and validate
terraform fmt -recursive
terraform validate

# Review execution plan
terraform plan

# Apply changes
terraform apply

# Review outputs
terraform output
```

### State Isolation

Each environment uses independent Terraform state:
- **No Shared State**: Prevents cross-environment interference
- **Independent Backend**: Each environment has its own state file
- **Parallel Development**: Multiple environments can be managed simultaneously

## Credential Setup

### AWS Credentials

This repository uses standard AWS credential providers. Credentials are **not** stored in Terraform code.

**Supported Methods:**
```bash
# AWS Profile
export AWS_PROFILE=your-profile-name

# Access Keys
export AWS_ACCESS_KEY_ID=your-key
export AWS_SECRET_ACCESS_KEY=your-secret

# Session Token (for temporary credentials)
export AWS_SESSION_TOKEN=your-token
```

**Recommended Approach:**
- Use AWS profiles for local development
- Use IAM roles for production deployments
- Use AWS Secrets Manager for sensitive variables (db_password, redis_auth_token)

**Security Notes:**
- Never commit credentials to version control
- Never include credentials in terraform.tfvars
- Rotate credentials regularly
- Use MFA for credential access

## Region Configuration

### AWS Region

The only mandatory infrastructure input is `aws_region`. This variable is:

- **Not Hard-Coded**: Must be specified by user
- **Dynamic AZ Discovery**: Uses `aws_availability_zones` data source
- **Region Portability**: Can deploy to any AWS region

**Configuration:**
```hcl
# In terraform.tfvars
aws_region = "us-east-1"
```

**Region Selection:**
- Choose region based on latency, compliance, cost
- Verify service availability in chosen region
- Consider data residency requirements

**AZ Discovery:**
- AZs are discovered dynamically at runtime
- No hard-coded AZ names (e.g., us-east-1a)
- Supports regions with varying AZ counts

## Final Architecture Matrix

| Environment | Staging | Production | Shared DB | Shared Cache |
|-------------|---------|------------|-----------|--------------|
| Option 1 + Single AZ | Lightsail | EKS | RDS Single-AZ | Redis Single-AZ |
| Option 1 + Multi AZ | Lightsail | EKS | RDS Multi-AZ | Redis/Valkey Multi-AZ |
| Option 2 + Single AZ | EC2 t4g.large | EKS | RDS Single-AZ | Redis Single-AZ |
| Option 2 + Multi AZ | EC2 t4g.large | EKS | RDS Multi-AZ | Redis/Valkey Multi-AZ |

## Environment-Specific Documentation

Each environment has its own comprehensive README with detailed information:

- **Architecture Overview**: Specific to the environment's configuration
- **Service Inventory**: Complete list of AWS services used
- **Network Topology**: Detailed network configuration
- **Security Architecture**: Security controls and practices
- **Port Documentation**: Complete port matrix and flow diagrams
- **Resource Documentation**: Every Terraform-managed resource explained
- **Troubleshooting**: Common issues and solutions
- **Cost Considerations**: Detailed cost breakdown

See individual environment READMEs for complete technical documentation:
- [Staging Option 1 + Production + Single-AZ](environments/staging-option-1-prod-single-az/README.md)
- [Staging Option 1 + Production + Multi-AZ](environments/staging-option-1-prod-multi-az/README.md)
- [Staging Option 2 + Production + Single-AZ](environments/staging-option-2-prod-single-az/README.md)
- [Staging Option 2 + Production + Multi-AZ](environments/staging-option-2-prod-multi-az/README.md)

## Validation

Before deployment, validate Terraform configurations:

```bash
# Format Terraform code
terraform fmt -recursive

# Validate configuration
terraform validate

# Review execution plan
terraform plan
```

## Destruction

Use extreme caution when destroying resources:

```bash
# Review destruction plan
terraform plan -destroy

# Destroy resources
terraform destroy
```

**Destruction Prerequisites:**
- Ensure RDS deletion protection is disabled (if set)
- Ensure Redis final snapshot can be created
- Verify no active applications depend on resources
- Confirm team approval for destruction

## Troubleshooting

### Common Issues

**Authentication Failure**: Verify AWS credentials are properly configured
**Region Issues**: Verify region variable is set correctly
**Permission Errors**: Ensure IAM user/role has required permissions
**Network Issues**: Verify security group rules and network ACLs
**Resource Limits**: Check AWS service quotas and limits

See individual environment READMEs for detailed troubleshooting guides.

## Support and Maintenance

### Regular Maintenance
- Review and update Terraform provider versions
- Update Kubernetes version in EKS
- Rotate database credentials
- Review and update security group rules
- Monitor cost and optimize resources

### Emergency Procedures
- Document rollback procedures
- Prepare disaster recovery plans
- Maintain contact information for AWS support
- Test backup and restore procedures
- Test failover procedures for Multi-AZ resources

## Contributing

When making changes to this repository:

1. Follow existing code structure and patterns
2. Update relevant documentation
3. Test changes in a non-production environment first
4. Validate Terraform configurations before committing
5. Review security implications of changes

## License

This infrastructure code is provided as-is for use with your AWS infrastructure.

## Disclaimer

This Terraform repository is provided as a starting point for your AWS infrastructure. You should review and customize it to meet your specific requirements, security standards, and compliance needs. Always test thoroughly in non-production environments before deploying to production.
