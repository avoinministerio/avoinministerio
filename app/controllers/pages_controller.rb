#encoding: UTF-8

class PagesController < ApplicationController

  def load(state)
    if state == "proposal"
      items = Idea.published.where(state: "proposal",
                                   collecting_started: true).sort_by{|idea| [ idea.language == I18n.locale.to_s ? 1 : 0, idea.collecting_ended ? 0 : 1, (idea.signatures.where(state: "signed").count + idea.additional_signatures_count)]}.reverse
    else
      items = Idea.published.where(state: state).sort_by{|idea| [ idea.language == I18n.locale.to_s ? 1 : 0]}.reverse
    end
    item_counts = {}

    items.each do |idea|
      for_count       = idea.vote_counts[1] || 0
      against_count   = idea.vote_counts[0] || 0
      comment_count   = idea.comments.count()
      total           = for_count + against_count
      for_portion     = (    for_count > 0 ?     for_count / total.to_f  : 0.0)
      against_portion = (against_count > 0 ? against_count / total.to_f  : 0.0)
      for_            = sprintf("%2.0f%%", for_portion * 100.0)
      against_        = sprintf("%2.0f%%", against_portion * 100.0)
      item_counts[idea.id] = [for_portion, for_, against_portion, against_]
    end

    return items, item_counts
  end

  def formatted_idea_counts(idea, idea_counts)
    for_count      = idea.vote_counts[1] || 0
    against_count  = idea.vote_counts[0] || 0
    comment_count  = idea.comments.count()
    total = for_count + against_count
    if total == 0
      idea_counts[idea.id] = ["0%", "0%", comment_count, total]
    else
      total = for_count + against_count
      idea_counts[idea.id] = [
        sprintf("%2.0f%%", (    for_count > 0 ?     for_count / total.to_f * 100.0  : 0.0)), 
        sprintf("%2.0f%%", (against_count > 0 ? against_count / total.to_f * 100.0  : 0.0)),
        comment_count, 
        total.format(" ")
      ]
    end
  end

  def home
    # Two rows (proposals and drafts)
    @proposals, @proposals_counts  = load("proposal")
    @drafts, @draft_counts = load("draft")

    # Ideas either newest or random sampling
    #if @newest_ideas = (rand() < 0.1)
      @ideas = Idea.published.where(state: 'idea').sort_by{|idea| [ idea.language == I18n.locale.to_s ? 0 : 1, idea.created_at ] }.first(6)
      @idea_counts = {}
      @ideas.each do |idea|
        formatted_idea_counts(idea, @idea_counts)
      end
    #else
    #  idea_count = 6
    #  # this solution builds on few facts: most ideas are published and in state idea, and
    #  # there's not too many to pick from (memory requirement) and very few to be picked (<< pool)
    #  max_id = Idea.maximum(:id)
    #  probability_good = 0.90
    #  picking_ids = (1..max_id).to_a.shuffle
    #  @ideas = []
    #  while @ideas.size < idea_count
    #    picks_at_time = ((idea_count - @ideas.size)/(probability_good**2.0)).to_i + 1 # 2.0 just makes it even more rare to require two loads
    #    picks_at_time = 1 if picks_at_time < 1
    #    picks = picking_ids.slice!(0, picks_at_time)
    #    # originally this didn't work: @ideas = Idea.published.where(state: 'idea').random_by_id_shuffle(idea_count)'
    #    published_ideas = Idea.find_all_by_id(picks).find_all do |i| 
    #      vote_count = i.vote_count || 1
    #      vote_count = 1 if vote_count == 0
    #      keep_as_too_few_votes_to_skip = (Math.log(vote_count)/Math.log(30)/2.0) < rand()
    #      i.published? and i.state == 'idea' and keep_as_too_few_votes_to_skip
    #    end
    #    @ideas.concat published_ideas[0,[idea_count - @ideas.size, published_ideas.size].min]
    #  end

    #  @idea_counts = {}
    #  @ideas.each do |idea|
    #    formatted_idea_counts(idea, @idea_counts)
    #  end
    #end

    @blog_articles = Article.published.where(article_type: 'blog').order("created_at DESC").limit(3).all

    @headline_1 = [
      t(".headline_1.turbines"),
      t(".headline_1.fur"),
      t(".headline_1.fur_dev"),
      t(".headline_1.income"),
      t(".headline_1.regime"),
      t(".headline_1.dog_tax"),
      t(".headline_1.dog_tax_country"),
      t(".headline_1.referendums"),
      t(".headline_1.marriage_law"),
      t(".headline_1.more_initiatives"),
      t(".headline_1.nothing"),
      t(".headline_1.children")
    ]
    @headline_2 = [
      t(".headline_2.law"),
      t(".headline_2.own_law"),
      t(".headline_2.put"),
      t(".headline_2.suggest"),
      t(".headline_2.comment"),
      t(".headline_2.speak"),
      t(".headline_2.support"),
      t(".headline_2.suggestion"),
      t(".headline_2.share"),
      t(".headline_2.spread")
    ]
  end
end