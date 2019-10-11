module ApplicationHelper
  def page_title
    if @page_title
      title = "#{@page_title} | Launch"
    else
      title = "Launch"
    end
    title
  end

  def resource_name
   :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
   @devise_mapping ||= Devise.mappings[:user]
  end

  def gravatar_image(user)
    user.gravatar_url(default: "retro")
  end

  def avatar(user)
    has_image_data = user.image.filename.present? && user.image.file.present?
    has_image_data ? show_image_user_images_path(user) : user.gravatar_url(default: "retro")
  end

  def article_author?(author)
    current_user.uuid == author.uuid
  end
end
