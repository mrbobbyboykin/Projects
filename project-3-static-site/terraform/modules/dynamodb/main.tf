variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

resource "aws_dynamodb_table" "visits" {
  name         = "${var.project_name}-${var.environment}-visits"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

output "table_name" {
  value = aws_dynamodb_table.visits.name
}

output "table_arn" {
  value = aws_dynamodb_table.visits.arn
}
