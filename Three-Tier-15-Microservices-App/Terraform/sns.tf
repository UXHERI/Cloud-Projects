# Create SNS topics
resource "aws_sns_topic" "web_tier_sns" {
  name = "web-tier-sns"
  
  tags = {
    Name = "web-tier-sns"
  }
}

resource "aws_sns_topic" "app_tier_sns" {
  name = "app-tier-sns"
  
  tags = {
    Name = "app-tier-sns"
  }
}

resource "aws_sns_topic" "cloudwatch_sns" {
  name = "Cloudwatch-sns"
  
  tags = {
    Name = "Cloudwatch-sns"
  }
}

# Subscribe email to all SNS topics
resource "aws_sns_topic_subscription" "web_tier_email_subscription" {
  topic_arn = aws_sns_topic.web_tier_sns.arn
  protocol  = "email"
  endpoint  = var.my_email
}

resource "aws_sns_topic_subscription" "app_tier_email_subscription" {
  topic_arn = aws_sns_topic.app_tier_sns.arn
  protocol  = "email"
  endpoint  = var.my_email
}

resource "aws_sns_topic_subscription" "cloudwatch_email_subscription" {
  topic_arn = aws_sns_topic.cloudwatch_sns.arn
  protocol  = "email"
  endpoint  = var.my_email
}
