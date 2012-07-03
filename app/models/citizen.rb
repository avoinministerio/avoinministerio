class Citizen < ActiveRecord::Base

  include Concerns::FileStorage

  def self.fog_directory_name
    "citizen-export"
  end

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

  include Tanker
  tankit 'BasicData' do
    conditions do
      published_something?
    end
    indexes :first_name
    indexes :last_name
    indexes :name
    indexes :type do "citizen" end

    category :type do
      "citizen"
    end
  end

  after_save :update_tank_indexes
  after_destroy :delete_tank_indexes

  def published_something?
    ideas.count > 0 || comments.count > 0
#    Idea.where("author_id = ?", author.id).count > 0 ||
#      Article.where("author_id = ?", author.id).count > 0 ||
#      Comment.where("author_id = ?", author.id).count > 0
  end

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
                      profile: Profile.new(first_names: info[:first_name],
                                           first_name: info[:first_name],
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

  def self.to_csv(start_from = "2012-01-01", page = 1, per_page = 450)
    _date = Date.parse(start_from) rescue Date.parse("2012-01-01")
    _citizens = Citizen.where("created_at > ?", _date).includes(:profile).paginate(page: page, per_page: per_page)
    CSV.generate do |csv|
      csv << header_field_names_for_csv
      _citizens.each do |_citizen|
        csv << _citizen.fields_for_csv
      end
    end
  end

  def self.export(start_from = "2012-01-01")
    _date = Date.parse(start_from) rescue Date.parse("2012-01-01")
    csv_string = to_csv(start_from, 1, 900000)
    store_file(export_csv_file_name, csv_string, 1.hour.from_now, true)
  end

  def self.export_csv_file_name
    "citizens-#{Time.now.strftime("%Y-%m-%d")}.csv"
  end

  def self.export_file_url
    get_file(export_csv_file_name)
  end

  def idea_dates
    ideas.order("created_at ASC").select(:created_at).map {|idea| idea.created_at}
  end

  def number_of_comments_on_citizens_ideas
    Comment.where(commentable_type: 'Idea', commentable_id: [ideas.map(&:id)]).count(:id)
  end

  def number_of_votes_on_citizens_ideas
    Vote.where(idea_id: [ideas.map(&:id)]).count(:id)
  end

  def number_of_comments
    comments.count(:id)
  end

  def number_of_ideas
    ideas.count(:id)
  end

  def fields_for_csv
    [ id, email, first_name, last_name, number_of_ideas,
      number_of_comments, number_of_comments_on_citizens_ideas,
      number_of_votes_on_citizens_ideas, idea_dates.first || "", *idea_dates.reverse[0,5]]
  end

  private

  def self.header_field_names_for_csv
    ["id", "email", "firstname", "lastname", "idea_count", "comment_count", "comments_on_ideas", "votes_on_ideas", "earliest_idea_date", "idea_date_last_1", "idea_date_last_2", "idea_date_last_3", "idea_date_last_4", "idea_date_last_5"]
  end

  after_initialize do |citizen|
    citizen.build_profile unless citizen.profile
  end
end
