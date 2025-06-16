terraform {
    required_providers {
        aws = {
        source = "hashicorp/aws"
        version = ">= 5.95.0" 
        }
    }

    backend "s3" {
        bucket = "01-e2e-devsecops-tf"
        region = "eu-west-2"
        key = "devsecops-infra/terraform.tfstate"
        dynamodb_table = "01_e2e_devsecops_tf_Lock_State_Files"
        encrypt = true
    }

}

provider "aws" {
    region  = var.region
}