class PagesController < ApplicationController
  def home
    @drafts = Idea.where(state: 'draft').order("updated_at DESC").limit(3).includes(:votes).all
    @draft_counts = {}
    @drafts.map do |idea|
      for_count      = idea.vote_counts[1] || 0
      against_count  = idea.vote_counts[0] || 0
      comment_count  = idea.comments.count()
      total = for_count + against_count
      for_portion     = (    for_count > 0 ?     for_count / total.to_f  : 0.0)
      against_portion = (against_count > 0 ? against_count / total.to_f  : 0.0)
      for_     = sprintf("%2.0f%%", for_portion * 100.0)
      against_ = sprintf("%2.0f%%", against_portion * 100.0)
      @draft_counts[idea.id] = [for_portion, for_, against_portion, against_]
    end

    @ideas = Idea.where(state: 'idea').order("updated_at DESC").limit(4).includes(:votes).all
    @idea_counts = {}
    @ideas.map do |idea|
      for_count      = idea.vote_counts[1] || 0
      against_count  = idea.vote_counts[0] || 0
      comment_count  = idea.comments.count()
      total = for_count + against_count
      if total == 0
        @idea_counts[idea.id] = ["0%", "0%", comment_count, total]
      else
        total = for_count + against_count
        @idea_counts[idea.id] = [
          sprintf("%2.0f%%", (    for_count > 0 ?     for_count / total.to_f * 100.0  : 0.0)), 
          sprintf("%2.0f%%", (against_count > 0 ? against_count / total.to_f * 100.0  : 0.0)),
          comment_count, 
          total.format(" ")
        ]
      end
    end

    @blog_articles = Article.published.where(article_type: 'blog').limit(3).all

    KM.identify(current_citizen)
    KM.push("record", "front page viewed")
  end
end
