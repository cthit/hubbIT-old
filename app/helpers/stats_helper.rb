module StatsHelper

	def seconds_to_words(seconds)
		distance_of_time_in_words Time.at(0).utc, Time.at(seconds).utc
	end

	def seconds_to_units(seconds)
		day = 1.day.to_i
		array = []
		unit = 'minutes'
		if seconds > day
			days = seconds / day
			hours = (seconds % day) / 3600
			array = [days, hours]
			unit = 'days'
		elsif seconds > 3600
			hours = (seconds % day) / 3600
			array = [hours]
			unit = 'hours'
		end
		array += [seconds / 60 % 60, seconds % 60]
		array.map { |t| t.to_i.to_s.rjust(2, '0') }.join(':') + " #{unit}"
	end
end
