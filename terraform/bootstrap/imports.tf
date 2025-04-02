# This file takes care of importing bootstrap
# resources onto a new developer's machine if needed
# import happens automatically on a normal ./apply.sh run

import {
  to = cloudfoundry_org_role.sa_org_manager
  id = "16f456a0-d420-4fe5-ac8f-51b943823590"
}
import {
  to = cloudfoundry_service_credential_binding.bucket_creds
  id = "9e232282-7606-4cff-a559-a1be3689fdb7"
}
import {
  to = cloudfoundry_service_credential_binding.runner_sa_key
  id = "e154df46-1998-4ca4-84a7-cdb0a992cbeb"
}
import {
  to = cloudfoundry_service_instance.runner_service_account
  id = "fcb7ab0c-15c1-4691-bb2c-62197f211caa"
}
import {
  to = module.mgmt_space.cloudfoundry_space.space
  id = "030a7fc1-60f4-42db-8933-7fdb1e025be7"
}
import {
  to = module.s3.cloudfoundry_service_instance.bucket
  id = "d656fa77-cb14-4ce4-baa9-1a3e9e67c871"
}

locals {
  developer_import_map = "{\"ryan.ahearn@gsa.gov\":\"605ae005-912d-4e95-8802-cee1b285742e\"}"
  manager_import_map   = "{}"
}
import {
  for_each = jsondecode(local.developer_import_map)
  to       = module.mgmt_space.cloudfoundry_space_role.developers[each.key]
  id       = each.value
}
import {
  for_each = jsondecode(local.manager_import_map)
  to       = module.mgmt_space.cloudfoundry_space_role.managers[each.key]
  id       = each.value
}
