class Citizen < ActiveRecord::Base
  include Concerns::Indexing
  include Tanker
  
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
    :first_names,
    :first_name,
    :last_name,
    :name,
    :image
  ].each { |attribute| delegate attribute, to: :profile }

  tankit index_name do
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
  after_save Concerns::IndexingWrapper.new
  after_destroy Concerns::IndexingWrapper.new

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

  private
  
  after_initialize do |citizen|
    citizen.build_profile unless citizen.profile
  end
end
