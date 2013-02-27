#encoding: UTF-8

require 'will_paginate/array'

class IdeasController < ApplicationController
  before_filter :authenticate_citizen!, except: [ :index, :show, :search ]
  
  respond_to :html

  POLITICIANS = { :KOK => [ { :id => 101, :name => "Andersson Hennariikka" },
                            { :id => 102, :name => "Asko-Seljavaara Sirpa" },
                            { :id => 103, :name => "Bogomoloff Harry" },
                            { :id => 104, :name => "Enroth Matti" },
                            { :id => 105, :name => "Hakola Juha" },
                            { :id => 106, :name => "Karhuvaara Arja" },
                            { :id => 107, :name => "Koskinen Kauko" },
                            { :id => 108, :name => "Koulumies Terhi" },
                            { :id => 109, :name => "Majuri Pekka" },
                            { :id => 110, :name => "Muurinen Seija" },
                            { :id => 111, :name => "Männistö Lasse" },
                            { :id => 112, :name => "Nieminen Jarmo" },
                            { :id => 113, :name => "Niiranen Matti" },
                            { :id => 114, :name => "Pakarinen Pia" },
                            { :id => 115, :name => "Pelkonen Jaana" },
                            { :id => 116, :name => "Raittinen Timo" },
                            { :id => 117, :name => "Rauhamäki Tatu" },
                            { :id => 118, :name => "Rautava Risto" },
                            { :id => 119, :name => "Rissanen Laura" },
                            { :id => 120, :name => "Rydman Wille" },
                            { :id => 121, :name => "Urho Ulla-Marja" },
                            { :id => 122, :name => "Vapaavuori Jan" } ],
                  :SDP => [ { :id => 123, :name => "Anttila Maija" },
                            { :id => 124, :name => "Arajärvi Pentti" },
                            { :id => 125, :name => "Heinäluoma Eero" },
                            { :id => 126, :name => "Jalovaara Ville" },
                            { :id => 127, :name => "Järvinen Jukka" },
                            { :id => 128, :name => "Lipponen Päivi" },
                            { :id => 129, :name => "Mäki Terhi" },
                            { :id => 130, :name => "Paavolainen Sara" },
                            { :id => 131, :name => "Pajamäki Osku" },
                            { :id => 132, :name => "Razmyar Nasima" },
                            { :id => 133, :name => "Taipale Ilkka" },
                            { :id => 134, :name => "Tenkula Tarja" },
                            { :id => 135, :name => "Torsti Pilvi" },
                            { :id => 136, :name => "Wallgren Thomas" },
                            { :id => 137, :name => "Valokainen Tuomo" } ],
                  :VAS => [ { :id => 138, :name => "Arhinmäki Paavo" },
                            { :id => 139, :name => "Honkasalo Veronika" },
                            { :id => 140, :name => "Koivulaakso Dan" },
                            { :id => 141, :name => "Loukoila Eija" },
                            { :id => 142, :name => "Modig Silvia" },
                            { :id => 143, :name => "Muttilainen Sami" },
                            { :id => 144, :name => "Puhakka Sirpa" },
                            { :id => 145, :name => "Saarnio Pekka" },
                            { :id => 146, :name => "Vuorjoki Anna" } ],
                  :PS =>  [ { :id => 147, :name => "Halla-aho Jussi" },
                            { :id => 148, :name => "Hursti René" },
                            { :id => 149, :name => "Huru Nina" },
                            { :id => 150, :name => "Kanerva Seppo" },
                            { :id => 151, :name => "Kantola Helena" },
                            { :id => 152, :name => "Lindell Harri" },
                            { :id => 153, :name => "Packalén Tom" },
                            { :id => 154, :name => "Raatikainen Mika" } ],
                  :RKP => [ { :id => 155, :name => "Brettschneider Gunvor" },
                            { :id => 156, :name => "Månsson Björn" },
                            { :id => 157, :name => "Rantala Marcus" },
                            { :id => 158, :name => "Storgård Päivi" },
                            { :id => 159, :name => "Thors Astrid" } ],
                  :KESK => [{ :id => 160, :name => "Kolbe Laura" },
                            { :id => 161, :name => "Laaninen Timo" },
                            { :id => 162, :name => "Peltokorpi Terhi" } ],
                  :KD =>  [ { :id => 163, :name => "Ebeling Mika" },
                            { :id => 164, :name => "Mäkimattila Sari" } ],
                  :VIHR => [{ :id => 166, :name => "Abdulla Zahra" },
                            { :id => 167, :name => "Alanko-Kahiluoto Outi" },
                            { :id => 168, :name => "Chydenius Jussi" },
                            { :id => 169, :name => "Hamid Jasmin" },
                            { :id => 170, :name => "Hautala Heidi" },
                            { :id => 171, :name => "Holopainen Mari" },
                            { :id => 172, :name => "Ikävalko Suzan" },
                            { :id => 173, :name => "Kari Emma" },
                            { :id => 174, :name => "Kivekäs Otso" },
                            { :id => 175, :name => "Kousa Tuuli" },
                            { :id => 176, :name => "Krohn Minerva" },
                            { :id => 177, :name => "Oskala Hannu" },
                            { :id => 178, :name => "Perälä Erkki" },
                            { :id => 179, :name => "Puoskari Mari" },
                            { :id => 180, :name => "Relander Jukka" },
                            { :id => 181, :name => "Sinnemäki Anni" },
                            { :id => 182, :name => "Soininvaara Osmo" },
                            { :id => 183, :name => "Stranius Leo" },
                            { :id => 184, :name => "Sumuvuori Johanna" } ],
                  :SKP => [ { :id => 165, :name => "Hakanen Yrjö" } ] }

  # should be implemented instead with counter_caches and also vote_pro (and vote_even_abs_diff cache)
  def index
    setup_filtering_and_sorting_options

    @sorting_order, ordering = update_sorting_order(params[:reorder])
    @current_filter, code, @filter_name, filterer = update_filter(params[:filter])

    on_page = 20
    extras = 20
    page = (params[:page] && params[:page].to_i) || 1

    if params[:tag]
      @tag = Tag.find(params[:tag])
      filtered_and_ordered = filterer.call(Idea.published.tagged_with(@tag.name)).order(ordering)
      @ideas_around = filtered_and_ordered.offset([(on_page*page - extras), 0].max).limit(on_page+extras*2)
      @ideas_around_ids = []
      @ideas_around.each do |idea|
        @ideas_around_ids << idea.id
      end
    else
      filtered_and_ordered = filterer.call(Idea.published).order(ordering)
      # limit assumes no error on overflow, ie. on N rows limit(N+1) returns just N
      # @ideas_around receives all ideas on current page and also extras amount before and after
      @ideas_around = filtered_and_ordered.offset([(on_page*page - extras), 0].max).limit(on_page+extras*2)
      @ideas_around_ids = @ideas_around.select(:id).map{|ia| ia.id}      
    end

   
    session[:sorting_orders] ||= {}
    # always update the ids for certain sorting order (for every pagination and sorting)
    # ie. this also remembers just the last, which also means next page, back and open idea gives wrong
    # TODO: fix by incorporating page number besides sorting order
    # TODO: we actually need to add whole user_id of some sorts here to prevent copy&pasted urls
    #       give wrong prev-next links if you happen to have the same sorting order in session
    @sorting_order_code = @sorting_order.hash
    session[:sorting_orders][@sorting_order_code] = @ideas_around_ids
    # p session[:sorting_orders]

    # TODO: this hit to database might not be needed as @ideas_around basically contains these already
    @ideas = filtered_and_ordered.paginate(page: page, per_page: on_page)

    KM.identify(current_citizen)
    # TODO: track which sorting options are most commonly used
    KM.push("record", "idea list viewed", page: params[:page] || 1)

#    @ideas.each do |idea|
#      idea.comments_count = 0
#      idea.articles.count = 0
#    end

    respond_with @ideas
  end

  def setup_filtering_and_sorting_options
    @filters = [
      [:all,                "Kaikki",                proc {|f| f} ],
      [:ideas,              "Ideat",                 proc {|f| f.where(state: :idea)} ],
      [:drafts,             "Luonnokset",            proc {|f| f.where(state: :draft)} ],
      [:law_proposals,      "Lakialoitteet",         proc {|f| f.where(state: :proposal)} ],
      [:action_proposals,   "Toimenpidealoitteet",   proc {|f| f.where(state: :proposal)} ],
      [:laws,               "Lait",                  proc {|f| f.where(state: :law)} ],
    ]

    @orders = {
      age:      {newest:  "created_at DESC",              oldest:     "created_at ASC"}, 
      comments: {most:    "comment_count DESC",           least:      "comment_count ASC"}, 
      voted:    {most:    "vote_count DESC",              least:      "vote_count ASC"}, 
      votes_for:{most:    "vote_for_count DESC",          least:      "vote_for_count ASC"},
      support:  {most:    "vote_proportion DESC",         least:      "vote_proportion ASC"},
      tilt:     {even:    "vote_proportion_away_mid ASC", polarized:  "vote_proportion_away_mid DESC"},
    }
    @field_names = {
      age:      {newest:  "Uusimmat ideat",               oldest:     "Vanhimmat ideat"}, 
      comments: {most:    "Eniten kommentteja",           least:      "Vähiten kommentteja"}, 
      voted:    {most:    "Eniten ääniä",                 least:      "Vähiten ääniä"}, 
      votes_for:{most:    "Eniten ääniä puolesta",        least:      "Vähiten ääniä puolesta"},
      support:  {most:    "Eniten tukea",                 least:      "Vähiten tukea"},
      tilt:     {even:    "Ääniä jakavimmat",             polarized:  "Selkeimmin puolesta tai vastaan"},
    }
  end

  def update_sorting_order(reorder)
    sorting_order = session[:sorting_order] 
    sorting_order ||= [
      [:age,      [:newest, :oldest]], 
      [:comments, [:most,   :least]], 
      [:voted,    [:most,   :least]], 
      [:votes_for,[:most,   :least]],
      [:support,  [:most,   :least]],
      [:tilt,     [:even,   :polarized]],
    ]
    if reorder and @orders.keys.include? reorder.to_sym
      i = sorting_order.index{|so| so.first == reorder.to_sym }
      if i > 0
        # reshuffle reordered key to first in array
        sorting_order.unshift(sorting_order.delete_at i)
      elsif i == 0
        # if it was first, reshuffle the sorting order
        sorting_options = sorting_order[0][1]
        sorting_options.push sorting_options.shift
      else
        raise "Sorting order error: unknown field #{reorder}"
      end
      # these two lines are a side-effect. TODO: Refactor out, but these are out-of-place in controller#index too.
      session[:sorting_order] = sorting_order
      params.delete :reorder # reordering done now, don't redo it on next page load
    end
    ordering = sorting_order.map{|ord| field, order = ord; @orders[field][order.first]}.join(", ")
    return sorting_order, ordering
  end

  def update_filter(params_filter)
    current_filter = params_filter || session[:filter] || :all
    session[:filter] = current_filter
    params.delete :filter

    code, filter_name, filterer = @filters.find {|f| f.first == current_filter.to_sym}
    raise "unknown filter #{current_filter}" unless code

    return current_filter, code, filter_name, filterer
  end
  
  def show
    @idea = Idea.includes(:votes).find(params[:id])
    @vote = @idea.votes.by(current_citizen).first if citizen_signed_in?
    
    @politicians = POLITICIANS

    @idea_vote_for_count      = @idea.vote_counts[1] || 0
    @idea_vote_against_count  = @idea.vote_counts[0] || 0
    @idea_vote_count          = @idea_vote_for_count + @idea_vote_against_count
    
    @colors = ["#4DA818", "#a9003f"]
    @colors.reverse! if @idea_vote_for_count < @idea_vote_against_count

    @sorting_order_code = params[:so]
    if @sorting_order_code && session[:sorting_orders] && session[:sorting_orders].include?(@sorting_order_code.to_i)
      ideas_around = session[:sorting_orders][@sorting_order_code.to_i]
      ix = ideas_around.index{|i| i == params[:id].to_i}
      # TODO: translate numerical Idea.id into friendlyed id-and-name format
      @prev, @next = nil, nil
      if ix
        @prev = ((ix-1) >= 0)                ? ideas_around[ix-1] : nil
        @next = ((ix+1) < ideas_around.size) ? ideas_around[ix+1] : nil
      end
    end
    
    KM.identify(current_citizen)
    KM.push("record", "idea viewed", idea_id: @idea.id,  idea_title: @idea.title)  # TODO use permalink title

    respond_with @idea
  end
  
  def new
    @idea = Idea.new
    respond_with @idea
  end
  
  def create
    @idea = Idea.new(params[:idea])
    @idea.author = current_citizen
    @idea.state  = "idea"
    @idea.updated_content_at = DateTime.now
    if @idea.save
      flash[:notice] = I18n.t("idea.created")
      KM.identify(current_citizen)
      KM.push("record", "idea created", idea_id: @idea.id,  idea_title: @idea.title)  # TODO use permalink title
    end
    respond_with @idea
  end
  
  def edit
    @idea = Idea.find(params[:id])
    respond_with @idea
  end
  
  def update
    @idea = Idea.find(params[:id])
    @idea.updated_content_at = DateTime.now
    if @idea.update_attributes(params[:idea])
      flash[:notice] = I18n.t("idea.updated") 
      KM.identify(current_citizen)
      KM.push("record", "idea edited", idea_id: @idea.id,  idea_title: @idea.title)  # TODO use permalink title
    end
    respond_with @idea
  end

  def search
    @per_page = 20
    @page = (params[:page] && params[:page].to_i) || 1
    
    params[:category_filters] ||= {}
    
    all_ideas = Idea.search_tank(params['searchterm'],
                                 :category_filters => params[:category_filters]).
                                 select {|result| result.published?}
    @idea_count = all_ideas.length
    @idea_categories = Idea.search_tank(params['searchterm'],
                                        :category_filters => params[:category_filters]).
                                        categories
    all_comments = Comment.search_tank(params['searchterm'],
                                       :category_filters => params[:category_filters]).
                                       select {|result| result.published?}
    @comment_count = all_comments.length
    all_articles = Article.search_tank(params['searchterm'],
                                       :category_filters => params[:category_filters]).
                                       select {|result| result.published?}
    @article_count = all_articles.length
    all_citizens = Citizen.search_tank(params['searchterm'],
                                       :category_filters => params[:category_filters]).
                                       select {|result| result.published_something?}
    @citizen_count = all_citizens.length
    all_results = all_ideas + all_comments + all_articles + all_citizens
    
    @results = all_results.paginate(page: @page, per_page: @per_page)
    @result_count = all_results.length
    
    @ideas = all_ideas & @results
    @comments = all_comments & @results
    @articles = all_articles & @results
    @citizens = all_citizens & @results
    
    KM.identify(current_citizen)
    track_clicks("idea", @ideas.length, @page)
    track_clicks("comment", @comments.length, @page)
    track_clicks("article", @articles.length, @page)
    track_clicks("citizen", @citizens.length, @page)
  end
  
  def track_clicks(type, count, page)
    1.upto(count) do |i|
      KM.track(type + "_" + i.to_s,
        "search result #{type}_#{i} on page #{page} clicked")
    end
  end

  def vote_flow
    # does not work well over SQLite or Postgres, but would be the easiest way around
    # @vote_counts = Vote.find(:all, :select => "idea_id, updated_at, count(option) AS option", :group => "idea_id, datepart(year, updated_at)")

    # thus we need to go through all the ideas, pick votes and group them in memory
    @vote_counts = {}
    @idea_counts = {}
    Idea.all.each do |idea|
      Vote.where("idea_id = #{idea.id}").find(:all, :select => "updated_at, option").each do |vote|
        @vote_counts[vote.updated_at.beginning_of_week.to_i] ||= {}
        @vote_counts[vote.updated_at.beginning_of_week.to_i][idea.id] ||= {}
        @vote_counts[vote.updated_at.beginning_of_week.to_i][idea.id][vote.option] ||= 0
        @vote_counts[vote.updated_at.beginning_of_week.to_i][idea.id][vote.option] += 1
        @idea_counts[idea.id] ||= {"a"=>0, "d"=>0, "c"=>0, "u" => 0, "n"=> idea.title[0,20]}
        @idea_counts[idea.id]["a"] += 1 if vote.option == 1
        @idea_counts[idea.id]["d"] += 1 if vote.option == 0
        @idea_counts[idea.id]["c"] += 1
      end
    end
    most_popular_ideas = @idea_counts.keys.sort{|a,b| @idea_counts[b]["c"] <=> @idea_counts[a]["c"]}
    # convert vote_counts into impact-style json
    @buckets = @vote_counts.keys.sort.map do |d|
      vcs = most_popular_ideas[0,10].find_all{|i| @vote_counts[d].has_key? i}.map do |idea_id|
        votes = @vote_counts[d][idea_id]
        vote_count = (votes[0] || 0) + (votes[1] || 0)
        [idea_id, vote_count]
      end
      {"d" => d, "i" => vcs.sort{|a,b| b[1] <=> a[1]}}
    end.to_json

    @authors = @idea_counts.to_json

    KM.identify(current_citizen)
    KM.push("record", "vote flow viewed")

    render 
  end
  
  #Preparations for LDA
  def lda
    @title_text = params[:title_text]
    @summary_text = params[:summary_text]
    @body_text = params[:body_text]
    tag_ids = Tag.get_ids_by_name(params[:tags])
    @lda_respond = @title_text + @summary_text + @body_text
    @ideas_suggested_by_tags = Idea.find_similar(tag_ids)
    if params[:idea_id] != ""
      @idea = Idea.find(params[:idea_id])
    end
    respond_to do |format|
      format.js   { render :respond, locals: { lda_respond: @lda_respond, ideas_suggested_by_tags: @ideas_suggested_by_tags } }
    end
  end

  def adopt_the_initiative
    if current_citizen.is_politician
      @politicians_support = PoliticiansSupport.create(:idea_id => params[:id], :citizen_id => current_citizen.id, :vote => "for")
      redirect_to :back
    end
  end

  def politician_vote_for
    @support = PoliticiansSupport.where(:idea_id => params[:id], :citizen_id => params[:politician_id]).first
    if @support != nil
      @support.update_attributes(:vote => "for")
    else
      PoliticiansSupport.create(:idea_id => params[:id], :citizen_id => params[:politician_id], :vote => "for")
    end
    voting
  end

  def politician_vote_against
    @support = PoliticiansSupport.where(:idea_id => params[:id], :citizen_id => params[:politician_id]).first
    if @support != nil
      @support.update_attributes(:vote => "against")
    else
      PoliticiansSupport.create(:idea_id => params[:id], :citizen_id => params[:politician_id], :vote => "against")
    end
    voting
  end

  def upload_document
    @idea = Idea.find(params[:id])
    @document = Document.create(:idea_id => params[:id], :file => params[:idea]["file"], :file_name => params[:idea]["file_name"])
    respond_with @idea
  end

  def suggest_tags
    tag_ids = Tag.ids_from_tokens(params[:idea]['suggested_tags'], params[:idea]['is_location'])
    @idea = Idea.find(params[:id])
    @idea.count_suggested_tags(params[:idea]['citizen_id'])

    @idea.add_suggested_tags(tag_ids, params[:idea]['citizen_id'])
    respond_to do |format|
      format.js   { render action: :citizen_voted, :locals => { :idea => @idea } }
    end
  end

  private
    def voting
      @title = params[:title]
      @party = params[:party]
      @idea = Idea.find(params[:id])
      respond_to do |format|
        format.js { render :update_table, locals: { title: @title, party: @party, idea: @idea } } 
      end
    end
end
