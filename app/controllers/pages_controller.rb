class PagesController < ApplicationController
  def home
    @recent_drafts = Idea.where(state: 'draft').order("updated_at DESC").limit(3).includes(:votes).all
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
        @idea_counts[idea.id] = ["50%", "50%", comment_count, total]
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

    @front_page_articles = Article.limit(3).find_all_by_article_type('blog')


<<<<<<< HEAD
  	@recent_ideas = Idea.order("updated_at DESC").limit(4).find_all_by_state('idea')
  	@idea_counts = {}
  	@recent_ideas.map do |idea|
	    for_count      = REDIS.get("idea:#{idea.id}:vote:1").to_i || 0
	    against_count  = REDIS.get("idea:#{idea.id}:vote:0").to_i || 0
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
=======
>>>>>>> front-idea-styling
  end

end
