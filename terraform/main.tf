locals {
  cf_org_name     = "gsa-tts-devtools-prototyping"
  app_name        = "saml_proxy"
  space_deployers = setunion([var.cf_user], var.space_deployers)
}


module "app_space" {
  source = "github.com/gsa-tts/terraform-cloudgov//cg_space?ref=v2.3.0"

  cf_org_name          = local.cf_org_name
  cf_space_name        = var.cf_space_name
  allow_ssh            = var.allow_space_ssh
  deployers            = local.space_deployers
  developers           = var.space_developers
  security_group_names = ["public_networks_egress"]
}

data "cloudfoundry_service_plans" "uaa_service" {
  name                  = "oauth-client"
  service_offering_name = "cloud-gov-identity-provider"
}

resource "cloudfoundry_service_instance" "uaa_authentication_service" {
  name         = "uaa-auth-service"
  type         = "managed"
  space        = module.app_space.space_id
  service_plan = data.cloudfoundry_service_plans.uaa_service.service_plans.0.id
  depends_on   = [module.app_space]
}

resource "cloudfoundry_service_credential_binding" "uaa_dev_key" {
  name             = "uaa-dev-key"
  service_instance = cloudfoundry_service_instance.uaa_authentication_service.id
  type             = "key"
  parameters       = jsonencode({ redirect_uri = ["http://localhost:3001/oidc/callback"] })
}

###########################################################################
# Before setting var.custom_domain_name, perform the following steps:
# 1) Domain must be manually created by an OrgManager:
#     cf create-domain var.cf_org_name var.domain_name
# 2) ACME challenge record must be created.
#     See https://cloud.gov/docs/services/external-domain-service/#how-to-create-an-instance-of-this-service
###########################################################################
module "domain" {
  count  = (var.custom_domain_name == null ? 0 : 1)
  source = "github.com/gsa-tts/terraform-cloudgov//domain?ref=v2.3.0"

  cf_org_name   = local.cf_org_name
  cf_space      = module.app_space.space
  cdn_plan_name = "domain"
  domain_name   = var.custom_domain_name
  host_name     = var.host_name
  # depends_on line is required only for initial creation and destruction. It can be commented out for updates if you see unwanted cascading effects
  depends_on = [module.app_space]
}
