class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :get_trend_article_sources_with_current_user, only: [:index]
  before_action :trend_articles, only: [:index]

  layout "application_dashboard"

  def index
    # acategory : analytics
    article_tokens = current_user.publics.pluck(:article_token)
    # { "YYYY-mm-dd" => access_count }
    count_by_created_at = AccessAnalysis.where(article_token: article_tokens)
                            .access_within_date_range(29.days.ago.beginning_of_day)
                            .map{ |date, count|
                              # DBがsqliteの時は、dateが文字列で渡される。(development)
                              return [date.strftime("%Y-%m-%d"), count] unless date.class == String
                              [date, count]
                            }.to_h
    last_month = {}
    29.downto(0).each do |i|
      day = i.day.ago.beginning_of_day
      if access_count = count_by_created_at[day.strftime("%Y-%m-%d")]
        last_month[day.strftime("%m/%d")] = access_count
      else
        last_month[day.strftime("%m/%d")] = 0
      end
    end

    gon.last_month = last_month
  end

  def article
    if params[:mode] == "public"
      @articles = current_user.publics.search(params[:q]).page(params[:page]).per(10)
    else
      @articles = current_user.drafts.search(params[:q]).page(params[:page]).per(10)
    end

    respond_to do |format|
      format.js
      format.html
    end
  end

  def comment
    article_tokens = current_user.publics.pluck(:article_token)
    @comments = Comment.where(article_token: article_tokens).order("created_at DESC").page(params[:page]).per(10)
  end

  private
    def trend_articles
      @trend_articles = Public.where(user_token: current_user.uuid).limit(5).get_trend_articles(date(params[:period]))
    end

    # category : analytics
    def get_trend_article_sources_with_current_user
      # [ {"id"=>nil, "access_source"=>"http://sample.com", "access_count"=>123 } ]
      if trend_articles.length > 0
        @access_analyses = Public.where(user_token: current_user.uuid).get_trend_article_sources(date(params[:period])).limit(5)
        @sum_access = trend_articles.first.access_analyses.where("created_at > ?", date(params[:period])).length
      end
    end
end
