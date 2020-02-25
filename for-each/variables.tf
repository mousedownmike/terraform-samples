variable "unique_prefx" {
  description = "A unique prefix to add to S3 bucket names."
  type = string
}

variable "env_regions" {
  description = "Mapping of environment names to AWS regions."
  type = map(string)
  default = {
    "prod":"us-east-1",
    "dev":"us-west-2"
  }
}
