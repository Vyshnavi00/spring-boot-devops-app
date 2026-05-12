terraform{

backend "s3"{
 bucket = "springboot-tfstate-hyderabad-099"
 key = "springboot-app/terraform.tfstate"
 region = "ap-south-2"
 use_lockfile = true
 encrypt = "true"
}

}
