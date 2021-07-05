###########################################
# Terraform code for production ready
# WordPress installation
###########################################


###########################################
# VPC
###########################################

resource "aws_vpc" "vpc" {
        cidr_block              = var.vpc_cidr
        instance_tenancy        = "default"
        enable_dns_hostnames    = true

        tags = {
                Name = "${var.project}-vpc"
        }
}

###########################################
# Internet Gateway
###########################################

resource "aws_internet_gateway" "igw" {
        vpc_id                  = aws_vpc.vpc.id
        tags = {
                Name = "${var.project}-igw"
        }

}

###########################################
# Public1 Subnet
###########################################

resource "aws_subnet" "public1" {
        vpc_id                  = aws_vpc.vpc.id
        cidr_block              = var.public1.cidr
        availability_zone       = var.public1.az
        map_public_ip_on_launch = true

        tags = {
                Name = "${var.project}-public1"
        }
}

###########################################
# Public2 Subnet
###########################################

resource "aws_subnet" "public2" {
        vpc_id                  = aws_vpc.vpc.id
        cidr_block              = var.public2.cidr
        availability_zone       = var.public2.az
        map_public_ip_on_launch = true

        tags = {
                Name = "${var.project}-public2"
        }
}

###########################################
# Public3 Subnet
###########################################

resource "aws_subnet" "public3" {
        vpc_id                  = aws_vpc.vpc.id
        cidr_block              = var.public3.cidr
        availability_zone       = var.public3.az
        map_public_ip_on_launch = true

        tags = {
                Name = "${var.project}-public3"
        }
}

###########################################
# Private1 Subnet
###########################################

resource "aws_subnet" "private1" {
        vpc_id                  = aws_vpc.vpc.id
        cidr_block              = var.private1.cidr
        availability_zone       = var.private1.az
        map_public_ip_on_launch = false

        tags = {
                Name = "${var.project}-private1"
        }
}

###########################################
# Private2 Subnet
###########################################

resource "aws_subnet" "private2" {
        vpc_id                  = aws_vpc.vpc.id
        cidr_block              = var.private2.cidr
        availability_zone       = var.private2.az
        map_public_ip_on_launch = false

        tags = {
                Name = "${var.project}-private2"
        }
}

###########################################
# Private3 Subnet
###########################################

resource "aws_subnet" "private3" {
        vpc_id                  = aws_vpc.vpc.id
        cidr_block              = var.private3.cidr
        availability_zone       = var.private3.az
        map_public_ip_on_launch = false

        tags = {
                Name = "${var.project}-private3"
        }
}

###########################################
# Elastic IP for NAT GW
###########################################

resource "aws_eip" "nat" {
        vpc                     = true
        tags = {
                Name = "${var.project}-natip"
        }
}

###########################################
# NAT Gateway
###########################################

resource "aws_nat_gateway" "nat" {
        allocation_id           = aws_eip.nat.id
        subnet_id               = aws_subnet.public1.id

        tags = {
                Name = "${var.project}-natgw"
        }
}

###########################################
# Route Table - Public
###########################################

resource "aws_route_table" "public" {
        vpc_id                  = aws_vpc.vpc.id

        route {
                cidr_block      = "0.0.0.0/0"
                gateway_id      = aws_internet_gateway.igw.id
        }

        tags = {
                Name = "${var.project}-rtpub"
        }
}

###########################################
# Route Table - Private
###########################################

resource "aws_route_table" "private" {
        vpc_id                  = aws_vpc.vpc.id
        route {
                cidr_block      = "0.0.0.0/0"
                nat_gateway_id  = aws_nat_gateway.nat.id
        }

        tags = {
                Name = "${var.project}-rtpri"
        }
}

###########################################
# Associate Public subnets to RT
###########################################

resource "aws_route_table_association" "public1" {
        subnet_id               = aws_subnet.public1.id
        route_table_id          = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
        subnet_id               = aws_subnet.public2.id
        route_table_id          = aws_route_table.public.id
}

resource "aws_route_table_association" "public3" {
        subnet_id               = aws_subnet.public3.id
        route_table_id          = aws_route_table.public.id
}

###########################################
# Associate Private subnets to RT
###########################################

resource "aws_route_table_association" "private1" {
        subnet_id               = aws_subnet.private1.id
        route_table_id          = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
        subnet_id               = aws_subnet.private2.id
        route_table_id          = aws_route_table.private.id
}

resource "aws_route_table_association" "private3" {
        subnet_id               = aws_subnet.private3.id
        route_table_id          = aws_route_table.private.id
}


###########################################
###########################################
# Security Group for bastion, webserver, DB
###########################################

resource "aws_security_group" "bastion" {
        name                    = "${var.project}-bastion"
        description             = "Allows 22 from anywhere"
        vpc_id                  = aws_vpc.vpc.id

        ingress {
                from_port        = 22
                to_port          = 22
                protocol         = "tcp"
                cidr_blocks      = [ "0.0.0.0/0" ]
                ipv6_cidr_blocks = [ "::/0" ]
        }

        egress {
                from_port        = 0
                to_port          = 0
                protocol         = "-1"
                cidr_blocks      = [ "0.0.0.0/0" ]
                ipv6_cidr_blocks = [ "::/0" ]
        }

        tags = {
                Name = "${var.project}-bastion"
        }
}

resource "aws_security_group" "webserver" {
        name                    = "${var.project}-webserver"
        description             = "Allows 443,80 from all & 22 from bastion"
        vpc_id                  = aws_vpc.vpc.id

        ingress {
    
                from_port        = 80
                to_port          = 80
                protocol         = "tcp"
                cidr_blocks      = [ "0.0.0.0/0" ]
                ipv6_cidr_blocks = [ "::/0" ]
        }
  
        ingress {
    
                from_port        = 443
                to_port          = 443
                protocol         = "tcp"
                cidr_blocks      = [ "0.0.0.0/0" ]
                ipv6_cidr_blocks = [ "::/0" ]
        }
   
        ingress {
    
                from_port        = 22
                to_port          = 22
                protocol         = "tcp"
                security_groups  = [ aws_security_group.bastion.id ]
        }
  
        egress {
                from_port        = 0
                to_port          = 0
                protocol         = "-1"
                cidr_blocks      = [ "0.0.0.0/0" ]
                ipv6_cidr_blocks = [ "::/0" ]
        }

        tags = {
                Name = "${var.project}-webserver"
        }
}

resource "aws_security_group" "database" {
    
        name        = "${var.project}-database"
        description = "Allows 3306 from webserver & 22 from bastion"
        vpc_id      = aws_vpc.vpc.id

        ingress {
    
                from_port        = 3306
                to_port          = 3306
                protocol         = "tcp"
                security_groups  = [ aws_security_group.webserver.id ]

        }
  
   
        ingress {
    
                from_port        = 22
                to_port          = 22
                protocol         = "tcp"
                security_groups  = [ aws_security_group.bastion.id ]
        }
  
        egress {
                from_port        = 0
                to_port          = 0
                protocol         = "-1"
                cidr_blocks      = [ "0.0.0.0/0" ]
                ipv6_cidr_blocks = [ "::/0" ]
        }

        tags = {
                Name = "${var.project}-database"
        }
}


###########################################
# Route53
###########################################

resource "aws_route53_zone" "domain" {

        name            = "wpprod.com"

        vpc {
                vpc_id  = aws_vpc.vpc.id
        }

        tags = {
                Name = "wpprod.com"
        }
}

resource "aws_route53_record" "hostwp" {

        zone_id         = aws_route53_zone.domain.id
        name            = "wpdb.wpprod.com"
        type            = "A"
        ttl             = "30"
        records         = [ aws_instance.database.private_ip ]

}


###########################################
# Key Pair
###########################################

resource "aws_key_pair" "key" {

  key_name   = "${var.project}-kp"
  public_key = file("my-key.pub")
  tags = {
    Name = "${var.project}-kp"
  }
    
}

###########################################
# Bastion server
###########################################

resource  "aws_instance"  "bastion" {
    
        ami                           =     "ami-011c99152163a87ae"
        instance_type                 =     "t2.micro"
        associate_public_ip_address   =     true
        key_name                      =     aws_key_pair.key.key_name
        vpc_security_group_ids        =     [  aws_security_group.bastion.id ]
        subnet_id                     =     aws_subnet.public1.id  
  
        tags = {
                Name = "${var.project}-bastion"
        }
}

###########################################

resource  "aws_instance"  "database" {
    
        ami                           =     "ami-011c99152163a87ae"
        instance_type                 =     "t2.micro"
        associate_public_ip_address   =     true
        key_name                      =     aws_key_pair.key.key_name
        vpc_security_group_ids        =     [  aws_security_group.database.id ]
        subnet_id                     =     aws_subnet.private1.id  
        user_data                     =     file("database.sh")
        tags = {
                Name = "${var.project}-database"
        }
}

###########################################
# Webserver
###########################################

resource  "aws_instance"  "webserver" {

        ami                           =     "ami-011c99152163a87ae"
        instance_type                 =     "t2.micro"
        associate_public_ip_address   =     true
        key_name                      =     aws_key_pair.key.key_name
        vpc_security_group_ids        =     [  aws_security_group.webserver.id ]
        subnet_id                     =     aws_subnet.public2.id
        user_data                     =     file("webserver.sh")
        tags = {
                Name = "${var.project}-webserver"
        }
}
