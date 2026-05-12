variable "region" {
 description = "variable for region"
 type = string
 default = "ap-south-2"

}

variable "app_name"{
 description = "app name"
 type = string
 default = "spring-boot-devops-app"

}

variable "container_port"{
 description = "container port"
 type = number
 default = 8080

}

variable "vpc_cidr"{
 description = "CIDR block for VPC"
 type = string
 default = "10.0.0.0/16"
}

variable "aws_account_id"{
 description = "AWS Account ID"
 type = string
 default = "090899138853"
}
