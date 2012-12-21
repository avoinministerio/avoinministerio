#encoding: UTF-8

class PagesController < ApplicationController

  def load(state, count)
    items = Idea.published.where(state: state, collecting_ended: nil).order("RANDOM()").limit(count).includes(:votes).all
    item_counts = {}
    
    if state == "proposal"
      items.each do |idea|
        for_count       = idea.signatures.count + ( idea.additional_signatures_count == nil ? 0 : idea.additional_signatures_count )
        against_count   = ( idea.target_count != nil && idea.target_count > for_count ? idea.target_count - for_count : 0 )
        total           = for_count + against_count
        for_portion     = (    for_count > 0 ?     for_count / total.to_f  : 0.0)
        for_            = sprintf("%2.0f", for_portion * total)
	start_date_	= sprintf( idea.collecting_start_date != nil ? I18n.localize(idea.collecting_start_date) : '' )
	end_date_   	= sprintf( idea.collecting_end_date != nil ? I18n.localize(idea.collecting_end_date) : '' )
        item_counts[idea.id] = [for_portion, for_, start_date_, end_date_]
      end
    else
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
    # AB-test: is it better to have proposals in their separate section or merge with drafts
    session[:ab_section_count] = rand(2)+1 unless session[:ab_section_count]
    KM.set({"section_count" => "#{session[:ab_section_count]}"})
    ["proposal_and_draft", "draft", "proposal"].each do |section|
      3.times do |i| 
        section_index_link = "ab_section_#{section}_#{i}_link"
        KM.track(section_index_link, section_index_link)            # track both, which section and which item
        KM.track(section_index_link, "ab_section_#{section}_link")  # track only which section got the click
      end
    end

    # B: two rows of examples:
    @proposal_total = Idea.published.where(state: 'proposal').count
    if  @proposal_total >= 4 && @proposal_total <=6
      @proposal_display  =  3
    else
      @proposal_display  =  3
    end
    @proposals, @proposals_counts  = load("proposal", @proposal_display)
    @drafts, @draft_counts        = load("draft",    3)

    # A: just one row, both proposals and drafts in it
    @proposals_and_drafts = (@proposals + @drafts).sort {|x,y| x.updated_at <=> y.updated_at}
    @proposal_and_drafts_counts = @proposals_counts.merge @draft_counts


    # Ideas either newest or random sampling
    if @newest_ideas = (rand() < 0.1)
      idea_count = 4
      @ideas = Idea.published.where(state: 'idea').order("created_at DESC").limit(idea_count).includes(:votes).all
      @idea_counts = {}
      @ideas.each do |idea|
        formatted_idea_counts(idea, @idea_counts)
      end

      idea_count.times do |i|
        KM.track("ab_ideas_#{i}", "ab_ideas_#{i}")    # track both, which section and which item
        KM.track("ab_ideas_#{i}", "ab_ideas")         # track just idea section got the click
      end
    
    else
      idea_count = 6
      # this solution builds on few facts: most ideas are published and in state idea, and
      # there's not too many to pick from (memory requirement) and very few to be picked (<< pool)
      max_id = Idea.maximum(:id)
      probability_good = 0.90
      picking_ids = (1..max_id).to_a.shuffle
      @ideas = []
      while @ideas.size < idea_count
        picks_at_time = ((idea_count - @ideas.size)/(probability_good**2.0)).to_i + 1 # 2.0 just makes it even more rare to require two loads
        picks_at_time = 1 if picks_at_time < 1
        picks = picking_ids.slice!(0, picks_at_time)
        # originally this didn't work: @ideas = Idea.published.where(state: 'idea').random_by_id_shuffle(idea_count)'
        published_ideas = Idea.find_all_by_id(picks).find_all do |i| 
          vote_count = i.vote_count || 1
          vote_count = 1 if vote_count == 0
          keep_as_too_few_votes_to_skip = (Math.log(vote_count)/Math.log(30)/2.0) < rand()
          i.published? and i.state == 'idea' and keep_as_too_few_votes_to_skip
        end
        @ideas.concat published_ideas[0,[idea_count - @ideas.size, published_ideas.size].min]
      end

      @idea_counts = {}
      @ideas.each do |idea|
        formatted_idea_counts(idea, @idea_counts)
      end
    end

    @blog_articles = Article.published.where(article_type: 'blog').order("created_at DESC").limit(3).all

    @headline_1 = [
      "Tuulivoimalat pelastavat maailman?",
      "Turkistarhaus on kiellettävä?",
      "Turkistarhausta kehitettävä?",
      "Perustulo kaikille?",
      "Nykyistä tukijärjestelmää on kehitettävä?",
      "Koiravero vanhentunut?",
      "Koiravero koko maahan?",
      "Sitovat kansanäänestykset?",
      "Tasa-arvoisempi avioliittolaki?",
      "Lisää kansalaisaloitteita",
      "Kaikki on hyvin?",
      "Mitään ei tarvitse muuttaa?",
      "Lapsillemme parempi maailma!"
    ]
    @headline_2 = [
      "Tee siitä laki",
      "Tee omat lakisi",
      "Laista itse",
      "Anna oma ehdotuksesi",
      "Kommentoi",
      "Ota kantaa",
      "Anna tukesi",
      "Tee vastaehdotus",
      "Jaa tietoa",
      "Levitä aloitetta",
    ]


    KM.identify(current_citizen)
    KM.push("record", "front page viewed")
  end
end
