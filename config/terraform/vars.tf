variable "region" {
  default = "us-east-2"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ACCESS_KEY" {}
variable "SECRET_KEY" {}
variable "PATH_PUB_KEY" {}
variable "STORAGE_DB" {}
variable "PATH_PRIV_KEY" {}
variable "DB_PASS" {}
variable "DB_USER" {}
variable "BACKUP_WINDOW" {}
variable "DB_INSTANCE_TYPE" {}
variable "ASG_MIN" {}
variable "ASG_MAX" {}
variable "ASG_DESIRED" {}
