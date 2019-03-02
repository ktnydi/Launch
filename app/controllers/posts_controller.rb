require 'securerandom'

class PostsController < ApplicationController
before_action :authenticate_user!, except: [:index, :show, :mypost]
before_action :forbiden_access, only: [:edit]
before_action :access_draft, only: [:show]
impressionist :actions => [:show]

  def index
    @posts = Post.status_public.order(created_at: :desc).page(params[:page]).per(10)
    if params[:q]
      @posts = Post.status_public.search(params[:q]).page(params[:page]).per(10)
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    @comment = Comment.new
    @likes_count = @post.likes.count
  end

  def new
    @post = Post.new
    render :layout => "editor"
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to :root
    else
      @errors = @post.errors.full_messages
      render new_post_path, :layout => "editor"
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
    render :layout => "editor"
  end

  def update
    @post = Post.find_by(id: params[:id])
    @post.assign_attributes(post_params)
    if @post.save
      flash[:post_notice] = "記事を編集しました。"
      redirect_to :root
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    redirect_to user_path(current_user)
  end

  def mypost
    @posts = Post.status_public.where(user_id: params[:user_id]).order(created_at: :desc).page(params[:page]).per(10)
    @user = User.find_by(id: params[:user_id])
  end

  private
  def post_params
    params[:post][:user_id] = current_user.id
    status(params[:commit])
    params.require(:post).permit(:title, :content, :app_url, :user_id, :status)
  end

  def forbiden_access
    post = Post.find_by(id: params[:id])
    if current_user.id != post.user_id
      flash[:alert] = "このアクセスは禁止されています。"
      redirect_to root_path
    end
  end

  def status(param)
    if param == "下書き保存"
      params[:post][:status] = "下書き"
      flash[:post_notice] = "記事を下書きしました。"
    else
      params[:post][:status] = "公開中"
      flash[:post_notice] = "記事を公開しました。"
    end
  end

  def access_draft
    if user_signed_in?
      post = current_user.posts.find_by(id: params[:id])
      if post.blank?
        forbiden_access_draft
      end
    else
      forbiden_access_draft
    end
  end

  def forbiden_access_draft
    post = Post.find_by(id: params[:id])
    if post.status == "下書き"
      flash[:alert] = "このアクセスは禁止されています。"
      redirect_to root_path
    end
  end
end
