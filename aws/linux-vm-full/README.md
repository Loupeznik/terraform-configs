# Full Linux VM configuration

Prerequisities:

- IAM service account in AWS with needed privileges
- AWS CLI installed (otherwise additional configuration will be required)
- SSH key pair

Creates:

- VPC and subnet
- Internet gateway and route table
- Network interface and security groups
- Security group rules to allow connections via ports 22, 80, 443 assigned to the VPC
- A SSH key resource (custom SSH public key is needed)
- Ubuntu VM with a public IP address

Outputs the machine's public IP address after it is created
