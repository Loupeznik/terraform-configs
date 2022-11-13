# Full Linux VM configuration

Prerequisities:

- Google Cloud SDK installed (otherwise additional configuration will be required)
- A project initialized in the Google Cloud Console (can be done there or via the `gcloud` command line)
- SSH key pair

Creates:

- Network and subnet in the project
- Firewall rules to allow connections via ports 22 and 80 assigned to the subnet
- CentOS VM with a public IP address and NGINX web server installed

Outputs the machine's public IP address after it is created

```powershell
gcloud init # authorize to GCP
echo "project = ""<your_project_name>""" > terraform.tfvars

terraform plan
terraform apply
```
