class PostsController < ApplicationController
before_action :authenticate_user!, except: [:index, :show, :mypost]
before_action :forbiden_access_edit, only: [:edit]
before_action :forbiden_access_post, only: [:show]
before_action :access_draft, only: [:show]


  def index
    @posts = Post.status_public.order(created_at: :desc).page(params[:page]).per(20)
    if params[:q]
      @posts = Post.status_public.search(params[:q]).page(params[:page]).per(20)
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

    respond_to do |format|
      if @post.save
        format.js { render :autosave } if params[:commit] == "autosave"
        format.js { render js: "window.location = '#{post_path(@post)}'" }
        format.html
      else
        @errors = @post.errors.full_messages
        format.js { render :error }
      end
    end
  end

  def edit
    @post = Post.find_by(uuid: params[:uuid])
    render :layout => "editor"
  end

  def update
    @post = Post.find_by(uuid: params[:uuid])
    @post.assign_attributes(post_params)
    respond_to do |format|
      if @post.save
        format.js { head :ok } if params[:commit] == "autosave"
        format.js { render js: "window.location = '#{post_path(@post)}'" }
      else
        @errors = @post.errors.full_messages
        format.js { render :error, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post = Post.find_by(uuid: params[:uuid])
    @post.destroy
    redirect_to user_path(current_user)
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
    if param == "記事を公開"
      params[:post][:status] = "公開中"
    else
      params[:post][:status] = "下書き"
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
