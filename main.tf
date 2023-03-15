resource "aws_secretsmanager_secret" "default" {
  for_each = var.enabled ? var.secrets : {}

  name                    = each.key
  recovery_window_in_days = 30
  kms_key_id              = try(module.kms_primary[0].key_id, var.kms_key_id)
  replica {
    region     = var.replica_region
    kms_key_id = try(module.kms_replica[0].key_id, var.kms_key_id)
  }

  tags = module.this.tags
}

resource "aws_secretsmanager_secret_version" "default" {
  for_each = var.enabled ? var.secrets : {}

  secret_id     = aws_secretsmanager_secret.default[each.key].id
  secret_string = each.value
}

#####################################################
######## READ SECRETS FROM SECRET MANAGER ###########
#####################################################

data "aws_secretsmanager_secret_version" "default" {
  for_each  = var.secrets
  secret_id = each.key

  depends_on = [aws_secretsmanager_secret_version.default]
}