class PostsController < ApplicationController
before_action :authenticate_user!, except: [:index, :show, :mypost]
before_action :forbiden_access_edit, only: [:edit]
before_action :forbiden_access_post, only: [:show]
before_action :access_draft, only: [:show]


  def index
    @posts = Post.status_public.order(created_at: :desc).page(params[:page]).per(10)
    if params[:q]
      @posts = Post.status_public.search(params[:q]).page(params[:page]).per(10)
    end
  end

  def show
    @post = Post.find_by(uuid: params[:uuid])
    @comment = Comment.new
  end

  def new
    @post = Post.new
    render :layout => "editor"
  end

  def create
    @post = current_user.posts.new(post_params)
    @post.uuid = SecureRandom.hex(10)
    if @post.save
      flash_notice(params[:commit])
      redirect_to users_path
    else
      @errors = @post.errors.full_messages
      render new_post_path, :layout => "editor"
    end
  end

  def edit
    @post = Post.find_by(uuid: params[:uuid])
    render :layout => "editor"
  end

  def update
    @post = Post.find_by(uuid: params[:uuid])
    @post.assign_attributes(post_params)
    if @post.save
      flash[:post_notice] = "記事を編集しました。"
      redirect_to users_path
    end
  end

  def destroy
    @post = Post.find_by(uuid: params[:uuid])
    @post.destroy
    redirect_to user_path(current_user)
  end

  def mypost
    @posts = Post.status_public.where(user_id: params[:user_id]).order(created_at: :desc).page(params[:page]).per(10)
    @user = User.find_by(uuid: params[:user_id])
  end

  private
  def post_params
    status(params[:commit])
    params.require(:post).permit(:title, :content, :app_url, :user_id, :status)
  end

  def forbiden_access_edit
    post = Post.find_by(uuid: params[:uuid])
    if current_user.id != post.user_id
      flash[:alert] = "このアクセスは禁止されています。"
      redirect_to users_path
    end
  end

  def forbiden_access_post
    post = Post.find_by(uuid: params[:uuid])
    if post.blank?
      redirect_to users_path
    end
  end

  def status(param)
    if param == "下書き保存"
      params[:post][:status] = "下書き"
    else
      params[:post][:status] = "公開中"
    end
  end

  def flash_notice(param)
    if param == "下書き保存"
      flash[:post_notice] = "記事を下書きしました。"
    else
      flash[:post_notice] = "記事を公開しました。"
    end
  end

  def access_draft
    if user_signed_in?
      post = current_user.posts.find_by(uuid: params[:uuid])
      if post.blank?
        forbiden_access_draft
      end
    else
      forbiden_access_draft
    end
  end

  def forbiden_access_draft
    post = Post.find_by(uuid: params[:uuid])
    if post.status == "下書き"
      flash[:alert] = "このアクセスは禁止されています。"
      redirect_to users_path
    end
  end
end
