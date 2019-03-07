class RegistrationsController < Devise::RegistrationsController

  protected

  def update_resource(resource, params)
    if commit_message == "パスワードを変更"
      resource.update_with_password(params)
    else
      resource.update_without_password(params)
    end
  end

  def commit_message
    params[:commit]
  end
end
