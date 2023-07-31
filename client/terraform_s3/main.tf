# Create S3 bucket
resource "aws_s3_bucket" "bp_bucket" {
  bucket = "binay-bucket-host"
}

# Making the bucket owner the owner of every file uploaded in the bucket
resource "aws_s3_bucket_ownership_controls" "bp_controls" {
  bucket = aws_s3_bucket.bp_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Allowing public access to the bucket
resource "aws_s3_bucket_public_access_block" "bp_s3_publicaccess" {
  bucket = aws_s3_bucket.bp_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Allowing everyone to access the files through the internet
resource "aws_s3_bucket_acl" "bp_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bp_controls,
    aws_s3_bucket_public_access_block.bp_s3_publicaccess
  ]
  bucket = aws_s3_bucket.bp_bucket.id

  acl = "public-read"
}

# Enabling static website feature
resource "aws_s3_bucket_website_configuration" "bp_conf" {
  bucket = aws_s3_bucket.bp_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# This is the policy to grant public read access to the files inside the bucket
data "aws_iam_policy_document" "website_policy" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    principals {
      identifiers =  ["*"]
      type        = "AWS"
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.bp_bucket.id}/*",
    ]
  }
}

# Attaching the policy to the bucket
resource "aws_s3_bucket_policy" "bp_s3_policy" {
  bucket = aws_s3_bucket.bp_bucket.id
  policy = data.aws_iam_policy_document.website_policy.json
}

resource "aws_s3_bucket_cors_configuration" "hosting_bucket_cors" {
  bucket = aws_s3_bucket.bp_bucket.id

  cors_rule {
    allowed_origins = ["*"]
    allowed_methods = ["GET", "POST", "PUT", "DELETE"]
    allowed_headers = ["*"]
  }
}

resource "aws_s3_object" "bp_s3_obj" {
  for_each      = module.template_files.files
  bucket        = aws_s3_bucket.bp_bucket.id
  key           = each.key
  content_type  = each.value.content_type
  source        = each.value.source_path
  content       = each.value.content
  etag          = each.value.digests.md5
}
