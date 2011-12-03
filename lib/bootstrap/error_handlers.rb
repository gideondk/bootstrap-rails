module Bootstrap
  module ErrorHandlers
    extend ActiveSupport::Concern

    included do
      rescue_from Bootstrap::RedirectException, :with => :rescue_redirect
    end

    protected

      # allows redirecting via controller helper methods via Exception handler
      def rescue_redirect(exception)
        redirect_to exception.url
      end

  end
end