module Admin
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception
    include SessionsHelper

    layout 'admin'

    before_action :logged_in_user
    before_action :admin_user

    private

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  end
end