variable "project" {
        default = "wp-prod"
}

variable "vpc_cidr" {
        default = "172.16.0.0/16"
}

variable "public1" {
        type            = map
        default = {
                "cidr"  = "172.16.0.0/19"
		"az"	= "ap-south-1a"
        }

}

variable "public2" {
        type            = map
        default = {
                "cidr"  = "172.16.32.0/19"
		"az"    = "ap-south-1b"
        }

}

variable "public3" {
        type            = map
        default = {
                "cidr"  = "172.16.64.0/19"
		"az"    = "ap-south-1c"
        }

}

variable "private1" {
        type            = map
        default = {
                "cidr"  = "172.16.96.0/19"
		"az"    = "ap-south-1a"
        }

}

variable "private2" {
        type            = map
        default = {
                "cidr"  = "172.16.128.0/19"
		"az"    = "ap-south-1b"
        }

}

variable "private3" {
        type            = map
        default = {
                "cidr"  = "172.16.160.0/19"
		"az"    = "ap-south-1c"
        }

}
