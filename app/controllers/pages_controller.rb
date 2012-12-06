#encoding: UTF-8

class PagesController < ApplicationController

  @@headlines1 = [
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
  @@headlines2 = [
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

  def self.headlines1
    @@headlines1
  end

  def self.headlines2
    @@headlines2
  end

  def home
    Idea.prepare_kiss_metrics

    # two rows of proposals
    @proposals, @proposals_counts  = Idea.proposals_row(2)
    @drafts, @draft_counts        = Idea.drafts_row

    # Ideas either newest or random sampling
    if @newest_ideas = (rand() < 0.1)
      @ideas = Idea.latest
    else
      @ideas = Idea.get_random_ideas(6)
    end

    @idea_counts = {}
    @ideas.each do |idea|
      @idea_counts[idea.id] = idea.formatted_idea_counts
    end

    @blog_articles = Article.published.where(article_type: 'blog').order("created_at DESC").limit(3).all

    KM.identify(current_citizen)
    KM.push("record", "front page viewed")
  end
end
