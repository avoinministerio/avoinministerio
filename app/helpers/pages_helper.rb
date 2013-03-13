#encoding: UTF-8

module PagesHelper
	def collecting_days_left(end_date)
    days_left = end_date - Date.today
    days_left <= 0 ? "" : "#{days_left.round(0)} #{t('.days_left')}"
  end
end
