class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :destroy_old_request

  def date(period = "")
    case period
    when "day"
      1.day.ago
    when "week"
      1.week.ago
    when "month"
      1.month.ago
    when "all"
      100.years.ago
    else
      1.day.ago
    end
  end

  private
    def destroy_old_request
      @requests = Request.where("created_at < ?", 30.days.ago)
      @requests.destroy_all if @requests.length > 0
    end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end
end
