variable "aws_access_key" {
  default = {{ AWS_ACCESS_KEY }}
}
variable "aws_secret_key" {
  default = {{ AWS_SECRET_KEY }}
}

variable "key_name" {
  default = "DevOpsKey"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "region" {
  default = "eu-north-1"
}