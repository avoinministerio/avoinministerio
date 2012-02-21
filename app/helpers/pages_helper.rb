module PagesHelper
	def finnishTime(time)
		sprintf("%d.%d.%d %02d:%02d", time.mday, time.month, time.year, time.hour, time.min)
	end
end
