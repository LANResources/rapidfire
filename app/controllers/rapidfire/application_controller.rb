module Rapidfire
  class ApplicationController < ::ApplicationController
    private
    def user_not_authorized
      flash[:error] = 'You are not authorized to view that page.'
      redirect_to main_app.root_url
    end
  end
end
