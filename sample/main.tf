module "aws_cloudwatch_dashboard" {
  source = "./module/cloudwatch"

  client        = var.client
  project       = var.project
  environment   = var.environment
  application   = var.application

  dashboard_configs = [
  {
    functionality = "ec2rds"
    services = { ec2 = true, rds = true, s3=true 
                 sqs=true, dynamodb=true, ses=true, ecs=true}
  },
  {
    functionality = "api"
    services = { 
                 apigateway = true, alb = true, 
                 nlb=true, lambda=true, 
                 cloudfront=true, ecs=true}
  }
  ]
}
