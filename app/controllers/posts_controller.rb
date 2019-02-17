require 'securerandom'

class PostsController < ApplicationController
before_action :authenticate_user!, except: [:index, :show]

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    @post = Post.find_by(id: params[:id])
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
    redirect_to :root
  end

  private
  def post_params
    params.require(:post).permit(:title, :content, :app_url)
  end
end
