class OidcController < ApplicationController
  def login
    session[:state] = SecureRandom.hex
    redirect_to client.authorization_uri(state: session[:state]), allow_other_host: true
  end

  def callback
    fail "Mismatched state! #{session[:state]} <> #{params[:state]}" unless session[:state] == params[:state]
    client.authorization_code = params[:code]
    @jwt, _ = JWT.decode(client.access_token!.id_token, nil, true, jwks: KeyLoader.key_set, algorithms: ['RS256'])
  end

  private

  def client
    credentials = CloudGovConfig.dig("cloud-gov-identity-provider", "credentials")
    @client ||= OpenIDConnect::Client.new(
      identifier: credentials[:client_id],
      secret: credentials[:client_secret],
      redirect_uri: oidc_callback_url,
      authorization_endpoint: "https://login.fr.cloud.gov/oauth/authorize",
      token_endpoint: "https://uaa.fr.cloud.gov/oauth/token"
    )
  end
end
