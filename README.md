# WordPress production ready Terraform deployer
[![Builds](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

----
## Description
This terraform code is to deploy a production ready WordPress installation (including initial WordPress setup) on its own dedicated VPC network with standalone MariaDB database server, Webserver, and a separate Bastion server for external SSH access. This includes creation of the following resources inside AWS account:

- Dedicated VPC network 
- 6 subnets (3 public and 3 private located inside 3 Availability Zones of a region we specify)
- Internet Gateway for public subnets
- Elastic IP for NAT Gateway instance
- NAT Gateway for private subnets
- 2 Dedicated Route Tables for public and private subnets
- Extra secure Security Groups for bastion, webserver, and database instances
- Private Route53 zone to setup database host in WordPress configuration
- Dedicated SSH key
- 3 EC2 instances (1 Bastion, 1 Webserver, 1 Database)

**TODO:** 

- Add ALB with AutoScaling for HA solution
- Attach a domain name to the WordPress setup 

----
## Steps to Use

- Install **[Terraform](https://www.terraform.io/downloads.html "Terraform")** on your device
- Create a [**programmatic IAM user**](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html#id_users_create_console "programmatic IAM user") in AWS console 
- Install **[Git](https://github.com/git-guides/install-git "Git")** package in your device
- Run the following commands:

```bash
git clone https://github.com/fasalsh/wordpress-prod-terraform.git
cd wordpress-prod-terraform/

# Enter the ACCESS/SECRET key, Region in Provider file
# region     = "region-code" 
# access_key = "AWS IAM user access key"
# secret_key = "AWS IAM user secret key"
vim provider.tf

# Enter the projectname, VPC CIDR range, public/private ranges and AZ inside Variables file
vim variables.tf

# Generate a SSH key
ssh-keygen -f my-key

# Initialize Terraform
terraform init

# Validate Terraform code
terraform validate

# Run plan to make sure no errors found
terraform plan

# Apply the code
terraform apply
```
----
## Output:
The code will output the following details once the execution completed:

- WebServer instance public IP
- Bastion instance public IP
- WebServer instance private IP
- Database instance private IP
- WordPress website URL
- WordPress dashboard URL

The default admin username and password:
Username: admin
Password: password

**Make sure to change the credentials as soon the setup ready to access**

## Issues/Requests:
- If you encounter any issues with this, open an issue in Github
- If you wish to work on it further, feel free to fork and make it better or add a pull request once added new features.

Thanks
*Fasal Muhammed*


