output "website_url" {
  description = "URL of the website"
  value       = aws_s3_bucket_website_configuration.bp_conf.website_endpoint
}