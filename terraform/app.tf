data "archive_file" "src" {
  type        = "zip"
  source_dir  = "${path.module}/.."
  output_path = "${path.module}/dist/src.zip"
  excludes = [
    ".git*",
    ".circleci/*",
    ".bundle/*",
    "node_modules/*",
    "tmp/**/*",
    "terraform/*",
    "log/*",
    "doc/*"
  ]
}

locals {
  host_name = coalesce(var.host_name, "${local.app_name}-${var.env}")
  domain    = coalesce(var.custom_domain_name, "app.cloud.gov")
}

resource "cloudfoundry_app" "app" {
  name       = "${local.app_name}-${var.env}"
  space_name = var.cf_space_name
  org_name   = local.cf_org_name

  path             = data.archive_file.src.output_path
  source_code_hash = data.archive_file.src.output_base64sha256
  buildpacks       = ["ruby_buildpack"]
  strategy         = "rolling"
  routes           = [{ route = "${local.host_name}.${local.domain}" }]

  environment = {
    RAILS_ENV                = var.env
    RAILS_MASTER_KEY         = var.rails_master_key
    RAILS_LOG_TO_STDOUT      = "true"
    RAILS_SERVE_STATIC_FILES = "true"
  }

  processes = [
    {
      type                       = "web"
      instances                  = var.web_instances
      memory                     = var.web_memory
      health_check_http_endpoint = "/up"
      health_check_type          = "http"
      command                    = "./bin/rake db:migrate && exec env HTTP_PORT=$PORT ./bin/thrust ./bin/rails server"
    }
  ]

  service_bindings = [{
    service_instance = cloudfoundry_service_instance.uaa_authentication_service.name,
    params = jsonencode({
      redirect_uri = [
        "https://${local.host_name}.${local.domain}/oidc/callback"
      ]
    })
  }]

  depends_on = [
    module.app_space,
    cloudfoundry_service_instance.uaa_authentication_service
  ]
}
