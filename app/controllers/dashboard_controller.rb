class DashboardController < ApplicationController
  before_action :authenticate_user!

  layout "application_dashboard"

  def index
    # acategory : analytics
    article_tokens = current_user.publics.pluck(:article_token)
    # { "YYYY-mm-dd" => access_count }
    count_by_created_at = AccessAnalysis.where(article_token: article_tokens)
                            .access_within_date_range(29.days.ago.beginning_of_day)
                            .map{ |date, count|
                              # DBがsqliteの時は、dateが文字列で渡される。(development)
                              next [date, count] if date.class == String
                              [date.strftime("%Y-%m-%d"), count]
                            }.to_h
    last_month = {}
    29.downto(0).each do |i|
      day = i.day.ago.beginning_of_day
      access_count = count_by_created_at[day.strftime("%Y-%m-%d")]
      last_month[day.strftime("%m/%d")] = access_count || 0
    end

    gon.last_month = last_month
  end

  def article
    @articles = params[:mode] == "public" ? current_user.publics : current_user.drafts
    @articles = @articles.search(params[:q]).page(params[:page]).per(1)

    respond_to do |format|
      format.js
      format.html
    end
  end

  def comment
    article_tokens = current_user.publics.pluck(:article_token)
    @comments = Comment.where(article_token: article_tokens).order("created_at DESC").page(params[:page]).per(10)
  end
end
