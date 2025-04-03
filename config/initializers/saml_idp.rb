SamlIdp.configure do |config|
  service_providers = {
    "CAPOC" => {
      response_hosts: ["localhost"]
    }
  }
  config.entity_id = "UAA-SAML-Proxy"
  config.service_provider.finder = ->(issuer_or_entity_id) do
    service_providers[issuer_or_entity_id]
  end
end
