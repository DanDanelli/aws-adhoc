terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      /*version = "~> 3.17.0"*/
    }
    dotenv = {
      source  = "jrhouston/dotenv"
      version = "~> 1.0"
    }
  }
}

variable index {}
variable ami {}

resource "null_resource" "exec_packer" {
  provisioner "local-exec" {
    command = "bash ./script.sh"
  }
}

resource "aws_instance" "modeloteste" {
  ami = var.ami
  instance_type = "t2.micro"
  key_name               = "kp_lab"
  monitoring             = true
  vpc_security_group_ids = ["sg-0c5499b0953260fa8"]
  subnet_id              = "subnet-0b0fa07c52ffc4553"
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command = "while [[ $(cat ami) != \"${var.index}\" ]]; do sleep 5; done; sleep 3;"
  }
}

// module "ec2_instance" {
//   source  = "terraform-aws-modules/ec2-instance/aws"
//   version = "~> 3.0"

//   name = "single-instance"

//   ami                    = var.ami
//   instance_type          = "t2.micro"
//   key_name               = "kp_lab"
//   monitoring             = true
//   vpc_security_group_ids = ["sg-0c5499b0953260fa8"]
//   subnet_id              = "subnet-0b0fa07c52ffc4553"

//   tags = {
//     Terraform   = "true"
//     Environment = "dev"
//   }
// }

// #via export TF_VAR
//  output "ami_id" {
//    value = var.ami
//  }