class RegistrationsController < Devise::RegistrationsController

  protected

  def update_resource(resource, params)
    if params[:password].present? && params[:password_confirmation].present?
      resource.update_attributes(params)
    else
      resource.update_without_password(params)
    end
  end
end
