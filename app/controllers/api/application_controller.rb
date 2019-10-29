module Api
  class ApplicationController < ::ApplicationController
    skip_before_action :verify_authenticity_token
    # protect_from_forgery prepend: true, with: :exception
    skip_before_action :logged_in_user

  end
end