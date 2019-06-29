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

  # ログイン中のユーザーと記事の作者と違うかどうか判断するには
  # 以下のように、ログイン中のユーザーが投稿した記事を持って
  # いるかどうかで判断するのではなく、
  #     def other_post?(post_id)
  #       current_user.posts.find_by(id: post_id).blank?
  #     end
  # ログイン中のユーザーのidと記事の作者のidとで判断する。
  # そうしないと、Ajaxで使う部分テンプレートで引数が渡せない。

  def other_user?(user_uuid)
    current_user.uuid != user_uuid
  end
end
