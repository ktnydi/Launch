require "fileutils"
class RegistrationsController < Devise::RegistrationsController

  def update
    if params[:user][:image_name]
      image = params[:user][:image_name]
      image_name = "#{current_user.id}.png"
      image_path = Rails.root.join("public/images/users/#{image_name}").to_s
      File.binwrite(image_path, image.read)
      params[:user][:image_name] = image_name
    end
    super
  end

  def destroy
    if current_user.image_name == "#{current_user.id}.png"
      image_path = Rails.root.join("public/images/users/#{current_user.image_name}").to_s
      FileUtils.rm(image_path)
    end
    super
  end

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
