# Web Tier IAM Role
resource "aws_iam_role" "web_role" {
  name = "3-tier-web-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "3-tier-web-role"
  }
}

# Attach AWS managed policies to web role
resource "aws_iam_role_policy_attachment" "web_s3_readonly" {
  role       = aws_iam_role.web_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "web_ssm_managed_instance_core" {
  role       = aws_iam_role.web_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Web Tier IAM Instance Profile
resource "aws_iam_instance_profile" "web_profile" {
  name = "3-tier-web-profile"
  role = aws_iam_role.web_role.name

  tags = {
    Name = "3-tier-web-profile"
  }
}

# App Tier IAM Role
resource "aws_iam_role" "app_role" {
  name = "3-tier-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "3-tier-app-role"
  }
}

# Attach AWS managed policies to app role
resource "aws_iam_role_policy_attachment" "app_s3_readonly" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "app_ssm_managed_instance_core" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "app_secrets_manager_readwrite" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

# App Tier IAM Instance Profile
resource "aws_iam_instance_profile" "app_profile" {
  name = "3-tier-app-profile"
  role = aws_iam_role.app_role.name

  tags = {
    Name = "3-tier-app-profile"
  }
}
