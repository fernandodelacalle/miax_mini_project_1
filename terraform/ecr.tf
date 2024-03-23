resource "aws_ecr_repository" "api_repository" {
  name         = "market_data_download"
  force_delete = true
}