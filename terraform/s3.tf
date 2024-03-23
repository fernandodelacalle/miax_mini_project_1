resource "aws_s3_bucket" "bucket_test" {
  bucket        = "mini-proyect-miax"
  force_destroy = true
}