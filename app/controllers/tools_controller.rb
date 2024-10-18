class ToolController < ApplicationController
    before_action :set_tool
    before_action :set_response_form, only: [:edit]

    def show
        # ...
    end

    def edit
        # Set up the request as needed
    end

    def update
        respond_to do |format|
        if @tool.update(tool_params)
            format.html { redirect_to edit_tool_url(@tool) }
            format.turbo_stream
        else
            format.html { render :edit, status: :unprocessable_entity }
        end
        end
    end


    private

    def set_tool
        @tool = Tool.load(...)
    end

    def tool_params
        # ...
    end

    def set_response_form
        @response_form = DeepLinkResponseFormComponent.new(
        launch_context: lti_launch_context,
        response_context: lti_response_context
        )
    end

    def lti_launch_context
        # This is populated by the OIDC controller in #callback action
        @lti_launch_context ||= session.key?(:lti_launch_context_id) && LTI::LaunchContext.find_by(
        id: session[:lti_launch_context_id]
        )
    end

    def lti_response_context
        @lti_response_context ||= LTI::ResponseContext.new(
        controller: self.class,
        action: :show,
        assigns: {
            # whatever instance variables the show template needs
            # ex:
            # tool: @tool
        }
        )
    end
end