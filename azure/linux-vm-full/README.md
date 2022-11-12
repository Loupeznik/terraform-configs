# Full Linux VM configuration

Creates:

- Resource group
- Network group and interface
- Network security group with port 22 open (assigned to the network interface)
- Public IP address (assigned to the network interface)
- Almalinux VM

```bash
terraform plan
terraform apply
```
