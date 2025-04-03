# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.font_src :self
    policy.form_action :self, "localhost:3000/", "gsa.gitlab-dedicated.us/", "capoc-saml.app.cloud.gov/"
    policy.frame_ancestors :none
    policy.img_src :self, :data
    policy.object_src :none
    policy.script_src :self
    policy.connect_src :self
    policy.style_src :self
  end

  #
  #   # Generate session nonces for permitted importmap, inline scripts, and inline styles.
  config.content_security_policy_nonce_generator = ->(request) { SecureRandom.hex }
  config.content_security_policy_nonce_directives = %w[script-src style-src]
  #
  #   # Report violations without enforcing the policy.
  #   # config.content_security_policy_report_only = true
end
