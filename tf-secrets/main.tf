provider "aws" {
  region = var.aws_region
}

resource "aws_secretsmanager_secret" "tf_secrets" {
  name = "tf_secrets"
}

locals {
  mapbox             = base64encode("${var.mapbox}")
  rootca             = filebase64("${var.rootca}")
  apns_certificate   = filebase64("${var.apns_certificate}")
  apns_key           = filebase64("${var.apns_key}")
  fcm_token          = base64encode("${var.fcm_token}")
  private_key        = filebase64("${var.private_key}")
}

resource "aws_secretsmanager_secret_version" "tf_secrets" {
  secret_id     = aws_secretsmanager_secret.tf_secrets.id
  secret_string = jsonencode({
    mapbox             = local.mapbox
    rootca             = local.rootca
    apns_certificate   = local.apns_certificate
    apns_key           = local.apns_key
    fcm_token          = local.fcm_token
    private_key        = local.private_key
    })
}
