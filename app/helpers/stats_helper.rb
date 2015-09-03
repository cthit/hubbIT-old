module StatsHelper

	def seconds_to_words(seconds)
		distance_of_time_in_words Time.at(0).utc, Time.at(seconds).utc
	end

	def seconds_to_units(secs)
		mm, ss = secs.divmod(60)
		hh, mm = mm.divmod(60)
		[hh, mm, ss].map { |n| n < 10 ? "0#{n}" : n }.join(':')
	end

	def seconds_to_score(seconds)
		seconds / 60
	end

	def info_box(title, &block)
		render 'info_box', title: title, block: block
	end

	def user_active?(user_session)
		@active_users.any? { |user| user_session.user_id == user.id }
	end
end
