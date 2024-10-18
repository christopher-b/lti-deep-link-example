class OIDCController < ApplicationController
    def callback
        session[:lti_launch_context_id] = lti_launch_context.id
        # redirect to content
    end
  
    private
  
    def jwt_content
        @jwt_content ||= begin
            content = JWTContent.new(params[:id_token])
            content.verify(
              lms_platform_id: config[:lms_platform_id],
             tool_client_id: config["tool_client_id"],
                nonce: session[:nonce]
            )
            content.id_token
        end
    end
  
    def lti_launch_context
        @lti_launch_context ||= LTI::LaunchContext.build(jwt_content)
    end
    
    def cleanup_session_params
        session.delete :state
        session.delete :nonce
    end
  
    def config
        # Provide these details
        {
            lms_platform_id: "", # https://canvas.instructure.com
            tool_client_id: "" # This value is specific to your account and the tool being launched
        }
    end
end