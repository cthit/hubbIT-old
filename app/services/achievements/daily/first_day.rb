require_relative '../achievement'

class FirstDay < Achievement

    def initialize
        super 'Daily win', 'first_day', 'Place yourself first for a day', 'Casual', 10
    end

    def achieved? user
    	from = Date.yesterday.beginning_of_day
    	to = Date.yesterday.end_of_day
		first = UserSession.includes(:user).time_between(from, to).first
		first.user == user
    end

end