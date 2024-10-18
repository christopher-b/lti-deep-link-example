class SSL
    def self.private_key
      @key ||= OpenSSL::PKey::RSA.new key_value
    end
  
    def self.key_value
      ENV.fetch("SSL_JWK_PRIVATE_KEY")
    end
  end