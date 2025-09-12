variable "aws_region" {
  description = "AWS region"
  default     = [Your AWS Region]
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.75.0.0/16"
}

variable "db_username" {
  description = "Database master username"
  default     = "admin"
}

variable "db_password" {
  description = "Database master password"
  default     = [Your RDS Database Password]
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  default     = "webappdb"
}

variable "db_endpoint" {
  description = "Database EndPoint"
  default     = [Your RDS DataBase Endpoint Link]
}

variable "s3_bucket_name" {
  description = "S3 bucket for application code"
  default     = [Your Application Code S3 Bucket Name]
}

variable "flow_logs_bucket" {
  description = "S3 bucket for VPC flow logs"
  default     = [Your VPC Flow Logs S3 Bucket Name]
}

variable "rds_mysql_secret" {
  description = "RDS Secrets"
  default = [Your RDS Secrets Name]
}

variable "my_email" {
  description = "Email Address for SNS Notifications"
  default = [Your Email Address]
}
