class DeepLinkResponseFormComponent < ApplicationComponent
    attr_accessor :return_url
  
    def initialize(launch_context:, response_context:)
      @launch_context = launch_context
      @response_context = response_context
      @return_url = @launch_context.deep_link_return_url
    end
  
    def response_content
      response_params = {
        aud: @launch_context.iss,
        azp: @launch_context.iss,
        iss: @launch_context.aud,
        nonce: SecureRandom.hex(16),
        iat: Time.now.to_i,
        exp: (Time.now + 600.seconds).to_i,
        "https://purl.imsglobal.org/spec/lti/claim/deployment_id": @launch_context.deployment_id,
        "https://purl.imsglobal.org/spec/lti/claim/message_type": "LtiDeepLinkingResponse",
        "https://purl.imsglobal.org/spec/lti/claim/version": "1.3.0",
        "https://purl.imsglobal.org/spec/lti-dl/claim/content_items": [
          {
            type: "html",
            html: response_html
          }
        ]
      }
  
      jwt = JSON::JWT.new response_params
      jwt.sign SSL.private_key
    end
  
    def response_html
      @response_context.render
    end
  end