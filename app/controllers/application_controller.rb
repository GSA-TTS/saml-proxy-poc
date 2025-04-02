class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def oidc_client
    @oidc_client ||= begin
      credentials = CloudGovConfig.dig("cloud-gov-identity-provider", "credentials")
      OpenIDConnect::Client.new(
        identifier: credentials[:client_id],
        secret: credentials[:client_secret],
        redirect_uri: oidc_callback_url,
        authorization_endpoint: "https://login.fr.cloud.gov/oauth/authorize",
        token_endpoint: "https://uaa.fr.cloud.gov/oauth/token"
      )
    end
  end
end
