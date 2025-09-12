# Creating App S3 Bucket
resource "aws_s3_bucket" "app_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "3-tier-application-bucket"
  }
}

# Creating VPC Flow Logs S3 Bucket
resource "aws_s3_bucket" "flow_logs_bucket" {
  bucket = var.flow_logs_bucket

  tags = {
    Name = "3-tier-vpc-flow-logs"
  }
}
