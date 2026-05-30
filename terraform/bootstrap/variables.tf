variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "S3 bucket name used for Terraform state."
  type        = string
  default     = "petclinic-platform-terraform-state"
}

variable "locks_table_name" {
  description = "DynamoDB table name used for Terraform state locking."
  type        = string
  default     = "petclinic-platform-terraform-locks"
}
