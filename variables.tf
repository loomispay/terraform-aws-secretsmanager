variable "secrets" {
  type = map(string)
  description = "A map of secrets name and value to be created"
}

variable "replica_region" {
  type        = string
  default     = "eu-central-1"
  description = "Region for replicating the secret"
}

variable "kms_key_id" {
  type        = string
  default     = ""
  description = "ARN or Id of the AWS KMS key to be used to encrypt the secret values in the versions stored in this secret. Provided KMS must be replicated to replica region"
}