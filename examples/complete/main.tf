module "secrets" {
  source = "git::https://github.com/loomispay/terraform-aws-secretsmanager.git"

  enabled = true
  namespace              = "important-domain-name"
  environment            = "stag"
  name                   = "backend-service"
  replica_region         = "us-east-1"
  secrets = {
    secret_name_1 = "change_me"
    secret_name_2 = "change_me"
  }
}

#####################################################
######## READ SECRETS FROM SECRET MANAGER ###########
#####################################################

resource "null_resource" "secretsmanager" {
  provisioner "local-exec" {
    command = "echo ${module.secrets.secrets_values.secret_name_1}"
  }
}