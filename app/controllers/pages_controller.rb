#encoding: UTF-8

class PagesController < ApplicationController

  def load(state, count)
    items = Idea.published.where(state: state).order("updated_at DESC").limit(count).includes(:votes).all
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
    @proposals, @proposals_counts  = load("proposal", 3)
    @drafts, @draft_counts        = load("draft",    3)

    # A: just one row, both proposals and drafts in it
    @proposals_and_drafts = (@proposals + @drafts).sort {|x,y| x.updated_at <=> y.updated_at}
    @proposal_and_drafts_counts = @proposals_counts.merge @draft_counts

    idea_count = 4
    @ideas = Idea.published.where(state: 'idea').order("created_at DESC").limit(idea_count).includes(:votes).all
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

    idea_count.times do |i|
      KM.track("ab_ideas_#{i}", "ab_ideas_#{i}")    # track both, which section and which item
      KM.track("ab_ideas_#{i}", "ab_ideas")         # track just idea section got the click
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
