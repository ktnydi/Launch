class TopController < ApplicationController
  before_action :forbidden_authenticate_user
  def index
  end

  private
    def forbidden_authenticate_user
      if user_signed_in?
        redirect_to users_path
      end
    end
end
