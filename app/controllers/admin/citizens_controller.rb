class Admin::CitizensController < Admin::AdminController
  respond_to :html
  
  before_filter :build_resource, except: [ :index ]
  
  def index
    respond_to do |wants|
        wants.html do
          @citizens = Citizen.paginate(page: params[:page])
        end
        wants.csv do
          @citizens = Citizen.all
          csv_string = CSV.generate do |csv|
            csv << ["email", "firstname", "lastname", "idea_count", "comment_count", "comments_on_ideas", "votes_on_ideas", "earliest_idea_date", "idea_date_last_1", "idea_date_last_2", "idea_date_last_3", "idea_date_last_4", "idea_date_last_5"]
            @citizens.each do |citizen|
              idea_dates = citizen.ideas.map {|idea| idea.created_at}
              ideas = idea_dates.reverse[0,5]
              earliest_idea_date = idea_dates[0] || ""
              idea_count = citizen.ideas.count
              comments_on_ideas = citizen.ideas.inject(0){|sum, idea| p idea.comments.count; sum + idea.comments.count}
              votes_on_ideas = citizen.ideas.inject(0){|sum, idea| vc = idea.vote_counts; p vc; sum + (vc[0]||0) + (vc[1]||0)}
              comment_count = citizen.comments.count
              csv << [citizen.email, citizen.first_name, citizen.last_name, idea_count, comment_count, comments_on_ideas, votes_on_ideas, earliest_idea_date, *ideas]
            end
          end
          send_data csv_string, 
            type: 'text/csv; charset=ISO-8859-1; header=present',
            disposition: "attachment; filename=citizens-#{Date.today.to_s}.csv"
        end
    end
  end
  
  def show
    respond_with @citizen
  end
  
  def lock
    @citizen.lock!
    redirect_to :back
  end
  
  def unlock
    @citizen.unlock!
    redirect_to :back
  end
  
  private
  
  def build_resource
    @citizen = Citizen.find(params[:id])
  end
end