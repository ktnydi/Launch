module AccessAnalysisHelper

  def access_count_all_day
    current_user.publics.pluck(:access_analyses_count).sum
  end

  def user_analyses_since(period)
    article_tokens = current_user.publics.pluck(:article_token)
    AccessAnalysis.where(article_token: article_tokens).where("created_at > ?", period)
  end

  def access_since(period)
    user_analyses_since(period).size
  end

  def popular_articles
    article_pvs = user_analyses_since(30.days.ago).group(:article_token).order("count_article_token desc").limit(5).count(:article_token)
    articles = article_pvs.map { |article_token, pv|
      Public.find_by(article_token: article_token).attributes.merge("pv" => pv)
    }
  end

  # return type is hash : { "id" => 123, "access_source" => "http://example.com", "pv" => 123, "rate" => 123.4 }
  def most_popular_article_sources
    return [] unless popular_articles.length > 0

    article = popular_articles.first
    access_analyses = AccessAnalysis.where(article_token: article["article_token"])
    sources = access_analyses.select("access_source, count(access_source) as pv").group(:access_source).order("pv desc").limit(5)
    sources.map do |source|
      rate = (source.pv * 100.0 / access_analyses.size).round(1)
      source.attributes.merge("rate" => rate)
    end
  end
end
