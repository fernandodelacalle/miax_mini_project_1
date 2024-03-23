resource "aws_dynamodb_table" "market_data_table" {
  name           = "market_data_table"
  read_capacity  = 10
  write_capacity = 10

  hash_key       = "TCK"
  range_key      = "DATE"

  attribute {
    name = "TCK"
    type = "S"
  }

  attribute {
    name = "DATE"
    type = "S"
  }

}
