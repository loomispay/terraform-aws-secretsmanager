output "secrets_values" {
  value = { for v in data.aws_secretsmanager_secret_version.default : v.secret_id => v.secret_string }
  sensitive = true
}