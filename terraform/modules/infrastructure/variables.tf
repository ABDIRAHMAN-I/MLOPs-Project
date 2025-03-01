variable "local_name" {
  description = "The local name to use for tagging"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
