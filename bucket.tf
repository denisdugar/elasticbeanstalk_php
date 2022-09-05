resource "aws_s3_bucket" "ebbucket-dduga" {
  bucket = "ebbucket-dduga"
  force_destroy = true
  provisioner "local-exec" {
    command = <<EOT
    echo "${local.db_creds.username}" > creds
    echo "${local.db_creds.password}" >> creds
    echo "${aws_db_instance.elastic_db.address}" >> creds
  EOT
  }
}

resource "aws_s3_bucket" "elasticapp-dduga" {
  bucket = "elasticapp-dduga"
  force_destroy = true
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.ebbucket-dduga.id
  policy = jsonencode(
  {"Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"AWS": ["${aws_iam_role.ec2_role.arn}"]},
      "Action": "s3:*",
      "Resource": "${aws_s3_bucket.ebbucket-dduga.arn}/*"
    }
  ]})
}

resource "aws_s3_bucket_object" "creds" {
  bucket = aws_s3_bucket.ebbucket-dduga.id
  key    = "creds"
  source = "creds"
}

resource "aws_s3_bucket_object" "script" {
  bucket = aws_s3_bucket.ebbucket-dduga.id
  key    = "script.sh"
  source = "script.sh"
}

resource "aws_s3_bucket_object" "config" {
  bucket = aws_s3_bucket.ebbucket-dduga.id
  key    = "config.json"
  source = "config.json"
}

resource "aws_s3_bucket_object" "app" {
  bucket = aws_s3_bucket.elasticapp-dduga.id
  key    = "php_app.zip"
  source = "./simple-php-website/php_app.zip"
}