locals {
  deletion_window_in_days = 30
  create                  = alltrue([module.this.enabled, var.kms_key_alias == null])
}

module "kms_primary" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-kms.git?ref=v1.5.0"

  count = local.create ? 1 : 0

  aliases                  = [module.this.id]
  deletion_window_in_days  = local.deletion_window_in_days
  enable_key_rotation      = true
  multi_region             = true
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  description              = "KMS key to be used to encrypt the values for Secret Manager"

  tags = module.this.tags
}

module "kms_replica" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-kms.git?ref=v1.5.0"

  count = local.create ? 1 : 0

  aliases                 = [module.this.id]
  primary_key_arn         = module.kms_primary[0].key_arn
  deletion_window_in_days = local.deletion_window_in_days
  create_replica          = true
  enable_default_policy   = true
  description             = "Multi-Region replica key"

  tags = module.this.tags

  providers = {
    aws = aws.replica
  }
}
