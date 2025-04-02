class User
  attr_reader :user_name, :email, :user_id

  def self.from_token(token)
    jwt, _ = JWT.decode(token, nil, true, jwks: KeyLoader.key_set, algorithms: ['RS256'])
    new(jwt)
  rescue => ex
    Rails.logger.error(ex)
    nil
  end

  def initialize(fields)
    @user_name = fields["user_name"]
    @email = fields["email"]
    @user_id = fields["user_id"]
  end
end
