module PagesHelper
	def collecting_days_left(end_date)
    days_left = end_date - Date.today
    days_left <= 0 ? "Collecting ended" : "#{days_left.round(0)} days left"
  end
end
