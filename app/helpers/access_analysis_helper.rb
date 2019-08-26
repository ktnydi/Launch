module AccessAnalysisHelper

  def access_count_since(period)
    AccessAnalysis.joins_public.since(period)
      .where("publics.user_token = ?", current_user.id)
      .size
  end

  def access_count_all_day
    current_user.publics.pluck(:access_analyses_count).sum
  end

  def many_access_articles
    AccessAnalysis.many_access_articles_since(29.days.ago)
      .where("publics.user_token = ?", current_user.id)
      .limit(5)
  end

  def most_access_article_sources
    token = many_access_articles.first.article_token
    AccessAnalysis.article_source_of(token).limit(5)
  end
end
