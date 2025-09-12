# Create the secret with the specified name
resource "aws_secretsmanager_secret" "rds_mysql_secret" {
  name        = var.rds_mysql_secret
  description = "Database credentials for MySQL RDS instance"

  tags = {
    Name        = "rds-mysql-secret"
  }
}

# Create the secret version with the key-value pairs
resource "aws_secretsmanager_secret_version" "rds_mysql_secret_version" {
  secret_id = aws_secretsmanager_secret.rds_mysql_secret.id
  
  secret_string = jsonencode({
    DB_HOST     = var.db_endpoint
    DB_USER     = var.db_username
    DB_PWD      = var.db_password
    DB_DATABASE = var.db_name
  })
}
