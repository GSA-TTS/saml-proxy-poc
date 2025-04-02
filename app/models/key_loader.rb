class KeyLoader
  KEYS_URL = "https://uaa.fr.cloud.gov/token_keys"

  def self.key_str
    @key_str ||= Net::HTTP.get(URI(KEYS_URL))
  end

  def self.key_set
    JWT::JWK::Set.new(JSON.parse(key_str))
  end

  def self.reset!
    @key_str = nil
  end
end
