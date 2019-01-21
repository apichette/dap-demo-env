provider "conjur" {}

data "conjur_secret" "db_uname" {
  name = "DemoVault/CICD/CICD_Secrets/Database-Oracle-OracleDBuser/username"
}

data "conjur_secret" "db_pwd" {
  name = "DemoVault/CICD/CICD_Secrets/Database-Oracle-OracleDBuser/password"
}

output "db_pwd" {
  sensitive = true
  value     = "${data.conjur_secret.db_pwd.value}"
}

output "db_uname" {
  value     = "${data.conjur_secret.db_uname.value}"
}

