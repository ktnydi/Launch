require 'securerandom'

class PostsController < ApplicationController
before_action :authenticate_user!, except: [:index, :show]
before_action :forbiden_access, only: [:edit]
impressionist :actions => [:show]

  def index
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(10)
    if params[:q]
      @posts = Post.search(params[:q]).page(params[:page]).per(10)
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
      flash[:p_notice] = "記事を公開しました。"
      redirect_to :root
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
      flash[:p_notice] = "記事を編集しました。"
      redirect_to :root
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    redirect_to user_path(current_user)
  end

  private
  def post_params
    params[:post][:user_id] = current_user.id
    params.require(:post).permit(:title, :content, :app_url, :user_id)
  end

  def forbiden_access
    post = Post.find_by(id: params[:id])
    if current_user.id != post.user_id
      flash[:alert] = "このアクセスは禁止されています。"
      redirect_to root_path
    end
  end
end
