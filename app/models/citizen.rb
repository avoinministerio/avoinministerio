class Citizen < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :profile, :profile_attributes

  has_one :authentication, dependent: :destroy
  has_one :profile, dependent: :destroy
  
  has_many :ideas, foreign_key: "author_id"
  has_many :comments, foreign_key: "author_id"
  has_many :idea_comments, through: :ideas
  
  accepts_nested_attributes_for :profile
  
  default_scope includes(:profile)
  
  [
    :first_name,
    :last_name,
    :name,
    :image
  ].each { |attribute| delegate attribute, to: :profile }

  def image
    profile.image || Gravatar.new(email).image_url(ssl: true)
  end
  
  def active_for_authentication?
    super && !locked_at
  end
  
  def locked?
    !!locked_at
  end
  
  def lock!
    update_attribute(:locked_at, Time.now.in_time_zone)
  end
  
  def unlock!
    update_attribute(:locked_at, nil)
  end

  def self.find_for_facebook_auth(auth_hash)
    auth = Authentication.where(provider: auth_hash[:provider], uid: auth_hash[:uid]).first
    auth && auth.citizen || nil
  end

  def self.build_from_auth_hash(auth_hash)
    info = auth_hash[:extra][:raw_info]
    c = Citizen.where(email: info[:email]).first
    c ||= Citizen.new email: info[:email],
      password: Devise.friendly_token[0,20],
      profile: Profile.new(first_name: info[:first_name], 
      last_name: info[:last_name],
      image: auth_hash[:info][:image])
    c.authentication = Authentication.new provider: auth_hash[:provider],
      uid: auth_hash[:uid],
      citizen: c,
      info: auth_hash[:info],
      credentials: auth_hash[:credentials],
      extra: auth_hash[:extra]
    c.save!
    c
  end
  
  def self.export_all_citizens_to_csv(page = 1, date_s = "2012-01-01")
    date = Date.parse(date_s)
    citizens = Citizen.where("created_at > ?", date).paginate(page: page, per_page: 450)
    csv_string = CSV.generate do |csv|
      csv << ["id", "email", "firstname", "lastname", "idea_count", "comment_count", "comments_on_ideas", "votes_on_ideas", "earliest_idea_date", "idea_date_last_1", "idea_date_last_2", "idea_date_last_3", "idea_date_last_4", "idea_date_last_5"]
      citizens.each do |citizen|
        idea_dates = citizen.ideas.order("created_at ASC").map {|idea| idea.created_at}
        ideas = idea_dates.reverse[0,5]
        earliest_idea_date = idea_dates[0] || ""
        idea_count = citizen.ideas.count
        comments_on_ideas = citizen.ideas.inject(0){|sum, idea| sum + idea.comments.count}
        votes_on_ideas = citizen.ideas.inject(0){|sum, idea| vc = idea.vote_counts; sum + (vc[0]||0) + (vc[1]||0)}
        comment_count = citizen.comments.count
        csv << [citizen.id, citizen.email, citizen.first_name, citizen.last_name, idea_count, comment_count, comments_on_ideas, votes_on_ideas, earliest_idea_date, *ideas]
      end
    end
    csv_string
  end
  
  def self.export_citizens_with_ideas_to_csv(page = 1, date_s = "2012-01-01")
    date = Date.parse(date_s)
    ideas = Idea.joins(:author).where("citizens.created_at > ?", date).paginate(page: page, per_page: 450)
    csv_string = CSV.generate do |csv|
      csv << ["id", "email", "firstname", "lastname", "idea_title", "idea_state", "idea_count", "comment_count", "idea_comment_count", "idea_vote_count", "idea_vote_for_count", "idea_vote_against_count", "idea_vote_proportion", "idea_vote_proportion_away_mid", "comments_on_ideas", "votes_on_ideas", "earliest_idea_date", "idea_date_last_1", "idea_date_last_2", "idea_date_last_3", "idea_date_last_4", "idea_date_last_5"]
      ideas.each do |idea|
        author = idea.author
        idea_dates = author.ideas.order("created_at ASC").map {|idea| idea.created_at}
        ideas = idea_dates.reverse[0,5]
        earliest_idea_date = idea_dates[0] || ""
        idea_count = author.ideas.count
        comments_on_ideas = author.ideas.inject(0){|sum, idea| sum + idea.comments.count}
        votes_on_ideas = author.ideas.inject(0){|sum, idea| vc = idea.vote_counts; sum + (vc[0]||0) + (vc[1]||0)}
        comment_count = author.comments.count
        csv << [author.id, author.email, author.first_name, author.last_name, idea.title, idea.state, idea_count, comment_count, idea.comment_count, idea.vote_count, idea.vote_for_count, idea.vote_against_count, idea.vote_proportion, idea.vote_proportion_away_mid, comments_on_ideas, votes_on_ideas, earliest_idea_date, *ideas]
      end
    end
    csv_string
  end

  private
  
  after_initialize do |citizen|
    citizen.build_profile unless citizen.profile
  end
end
