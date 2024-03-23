resource "aws_ecr_repository" "ecr_market_data_download" {
  name         = "market_data_download"
  force_delete = true
}

resource "aws_ecr_repository" "ecr_api" {
  name         = "api"
  force_delete = true
}
