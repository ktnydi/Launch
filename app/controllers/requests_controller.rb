class RequestsController < ApplicationController
  require 'securerandom'
  before_action :authenticate_user!, except: [:index]

  def index
    @requests = Request.all.order('created_at DESC').page(params[:page]).per(20)
  end

  def show
    @request = Request.find_by(token: params[:request_token])
  end

  def new
    @request = Request.new
  end

  def create
    @request = current_user.requests.new({
        token: SecureRandom.hex(10),
        category: params[:category],
        content: params[:content],
      })
    if @request.save
      redirect_to root_path
    end
  end

  def destroy
  end
end
