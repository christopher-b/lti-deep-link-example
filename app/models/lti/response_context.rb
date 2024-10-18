module LTI
    ResponseContext = Data.define(:controller_class, :action, :assigns) do
      def render
        controller_class.render(action, assigns: assigns, layout: false)
      end
    end
  end