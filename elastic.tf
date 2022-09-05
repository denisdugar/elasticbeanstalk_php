resource "aws_elastic_beanstalk_application" "elasticapp" {
  name = "elasticapp"
}

resource "aws_elastic_beanstalk_application_version" "elasticapp_version" {
  name        = "elasticapp_version"
  application = "elasticapp"
  bucket      = aws_s3_bucket.elasticapp-dduga.id
  key         = aws_s3_bucket_object.app.id
}

resource "aws_elastic_beanstalk_environment" "elasticenv" {
  name                = "elasticenv"
  application         = aws_elastic_beanstalk_application.elasticapp.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.0 running PHP 8.1"
  version_label       = aws_elastic_beanstalk_application_version.elasticapp_version.name
  
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.test_vpc.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.test_subnet_public_1.id}, ${aws_subnet.test_subnet_public_2.id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "internet facing"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "bastion"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 1
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 2
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     =  "test_profile"
  }
    depends_on = [
    aws_s3_bucket_object.creds,
    aws_s3_bucket_object.script,
    aws_s3_bucket_object.config
  ]
}