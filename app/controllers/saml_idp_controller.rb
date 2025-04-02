class SamlIdpController < ApplicationController
  include SamlIdp::Controller

  protect_from_forgery

  before_action :validate_saml_request, only: [:new, :create, :logout]

  def new
    session[:state] = SecureRandom.hex
    session[:SAMLRequest] = params[:SAMLRequest]
    session[:RelayState] = params[:RelayState]
    redirect_to oidc_client.authorization_uri(state: session[:state]), allow_other_host: true
  end

  def show
    render xml: SamlIdp.metadata.signed
  end

  def create
    fail "Mismatched state! #{session[:state]} <> #{params[:state]}" unless session[:state] == params[:state]
    person = User.from_token(params[:token])
    if person.nil?
      fail "Could not decode a User"
    else
      @saml_response = idp_make_saml_response(person)
      render layout: false
    end
  end

  def logout
    @saml_response = idp_make_saml_response(nil)
    render template: "create", layout: false
  end

  def idp_make_saml_response(person)
    # NOTE encryption is optional
    encode_response person, encryption: {
      cert: saml_request.service_provider.cert,
      block_encryption: 'aes256-cbc',
      key_transport: 'rsa-oaep-mgf1p'
    }
  end
  protected :idp_make_saml_response
end
