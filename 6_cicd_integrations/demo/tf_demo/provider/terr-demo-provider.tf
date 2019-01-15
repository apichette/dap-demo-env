provider "conjur" {}

data "conjur_secret" "db_uname" {
  name = "secrets/prod-db_username"
}

data "conjur_secret" "db_pwd" {
  name = "secrets/prod-db_password"
}

output "db_pwd" {
  sensitive = true
  value     = "${data.conjur_secret.db_pwd.value}"
}

output "db_uname" {
  value     = "${data.conjur_secret.db_uname.value}"
}

