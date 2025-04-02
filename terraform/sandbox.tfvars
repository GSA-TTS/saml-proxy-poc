cf_user         = "ryan.ahearn@gsa.gov"
cf_space_name   = "saml-proxy-sandbox"
env             = "staging"
allow_space_ssh = true
# host_name must be unique across cloud.gov, default is "saml_proxy-${var.env}"
host_name = "saml-proxy-sandbox"
space_developers = [
  # enter developer emails that should have ssh access to staging
]
