class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def date(period = "")
    case period
    when "day"
      1.day.ago
    when "week"
      1.week.ago
    when "month"
      1.month.ago
    when "all"
      ""
    else
      1.day.ago
    end
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end
end
