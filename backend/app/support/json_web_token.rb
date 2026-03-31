class JsonWebToken
  SECRET_KEY = ENV.fetch('SECRET_KEY_BASE')
  ALGO = 'HS512'

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithm: ALGO)
    HashWithIndifferentAccess.new(decoded[0])
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end
end
