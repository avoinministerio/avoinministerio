class Kansalaisaloite
  require 'open-uri'

  PER_PAGE = 5

  attr_accessor :offset, :per_page, :page, :current_page

  class_attribute :max_pages, :ids_range, :bad_requests, :max_attempts, :total_fetched
  self.max_pages = 50
  self.ids_range = 1..100
  self.bad_requests = 0
  self.max_attempts = 10
  self.total_fetched = 0

  def fetch_index(&block)
    while true
      begin
        page_data = self.fetch_json(self.url_paginate)
        break unless (self.current_page < self.max_pages) && page_data.any?

        puts 'START PARSING '+ self.url_paginate
        self.offset += PER_PAGE
        self.current_page += 1
        self.page = page_data
        self.save_all_initiatives(page_data)

      rescue Exception => e
        puts e
      end
    end
  end

  def fetch_range
    last_id = 0

    self.ids_range.each do |id|
      begin
        initiative_json = self.fetch_json("https://www.kansalaisaloite.fi/api/v1/initiatives/#{id}")
        self.idea_create_or_update(initiative_json)
        self.bad_requests = 0
      rescue OpenURI::HTTPError => e
        self.bad_requests += 1 if (e.message.include?('404') && (last_id.next == id))
        last_id = id
        raise Maximum404Requests.new("Script ended due to maximum attempts:", self.max_attempts, id) if \
                      self.bad_requests >= self.max_attempts
      rescue Exception => e
        puts e
      end
    end
  end

  def fetch_json(url)
    open(url) do |file|
      JSON.parse(file.read)
    end
  end


  def url_paginate
    "https://www.kansalaisaloite.fi/api/v1/initiatives?offset=#{self.offset}&limit=#{PER_PAGE}"
  end

  def parse_detail(initiative_json)
    json_data = self.fetch_json(initiative_json['id'])
    OpenStruct.new(title: json_data['name']['fi'][0..253],
                   body: json_data['proposal']['fi'],
                   id: json_data['id'],
                   state_date: (Date.parse(json_data['stateDate']) unless json_data['stateDate'].blank?),
                   support_count: json_data['supportCount'],
                   modified: (Date.parse(json_data['modified']) unless json_data['modified'].blank?)
    )
  end

  def offset
    @offset ||= 0
  end

  def current_page
    @current_page ||= 0
  end

  def save_all_initiatives(page_array)
    page_array.each do |initiative_json|
      self.idea_create_or_update(initiative_json)
    end
  end

  def idea_create_or_update(initiative_json)
    initiative = parse_detail(initiative_json)

    if idea = Idea.where(:additional_collecting_service_urls => initiative.id).first
      puts "UPDATE #{initiative.id}"
      idea.additional_signatures_count = initiative.support_count
      idea.additional_signatures_count_date = Time.zone.now.to_date
      idea.additional_service_data[:counts] ||= []
      idea.additional_service_data[:counts] << {collected_date: Time.zone.now.to_date, counts: initiative.support_count}
    else
      puts "CREATE #{initiative.id}"
      idea = Idea.new(:title => initiative.title, :state => 'external')
      idea.body = initiative.body
      idea.additional_collecting_service_urls = initiative.id
      idea.additional_signatures_count = initiative.support_count
      idea.additional_signatures_count_date = Time.zone.now.to_date
      idea.additional_service_data[:counts] ||= []
      idea.additional_service_data[:counts] << {collected_date: Time.zone.now.to_date, counts: initiative.support_count}

      if initiative_ended?(initiative_json)
        idea.collecting_end_date = initiative.state_date
        idea.collecting_ended = true
      end

      idea.author = Citizen.find_by_email('external@kansalaisaloite.fi') ||
          raise('Cannot assign author to new Idea, no Citizen with email "external@kansalaisaloite.fi" found.')
    end
    idea.save!
    self.total_fetched += 1
  end

  def initiative_ended?(initiative_json)
    !!(initiative_json['state'] =~ /done|canceled/i)
  end

  class Maximum404Requests < StandardError
    def initialize(msg, attempts_count, last_id = '')
      super(msg)
      @attempts_count = attempts_count
      @last_id = last_id
    end

    def message
      super + "#{@attempts_count}, last id:#{@last_id}"
    end
  end
end