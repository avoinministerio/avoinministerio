class PagesController < ApplicationController
  def home
    @recent_drafts = Idea.where(state: 'lakiluonnos').order("updated_at DESC").limit(3).includes(:votes).all
  	@draft_counts = {}
  	@recent_drafts.map do |idea|
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

    @recent_ideas = Idea.where(state: 'idea').order("updated_at DESC").limit(4).includes(:votes).all
  	@idea_counts = {}
  	@recent_ideas.map do |idea|
      for_count      = idea.vote_counts[1] || 0
      against_count  = idea.vote_counts[0] || 0
	    comment_count  = idea.comments.count()
	    total = for_count + against_count
	    if total == 0
	    	@idea_counts[idea.id] = [50.0, 50.0]
	    else
		    total = for_count + against_count
		    @idea_counts[idea.id] = [sprintf("%2.0f%%", (    for_count > 0 ?     for_count / total.to_f * 100.0  : 0.0)), 
			   					     sprintf("%2.0f%%", (against_count > 0 ? against_count / total.to_f * 100.0  : 0.0)),
			   				    	 comment_count
			   						]
		end
  	end

#    @front_page_articles = Article.limit(3).find_all_by_article_type('statement')
#    @front_page_articles = Article.limit(3).find_all_by_article_type('blogi')
    @front_page_articles = Article.limit(3).all


  end

end
