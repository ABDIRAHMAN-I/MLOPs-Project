variable "cert_manager_irsa_role_arn" {
  description = "IAM role ARN for cert-manager"
  type        = string
}

variable "external_dns_irsa_role_arn" {
  description = "IAM role ARN for external-dns"
  type        = string
}
