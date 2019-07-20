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

  def article_author?(author)
    current_user.uuid == author.uuid
  end
end
