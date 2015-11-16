require_relative '../achievement'

class FirstWeek < Achievement

    def initialize
        super 'Weekly win', 'first_week', 'Place yourself first for a week', 'Hardcore', 25
    end

    def achieved? user
    	from = Date.today.last_week.beginning_of_week
    	to = Date.today.last_week.end_of_week
		first = UserSession.includes(:user).time_between(from, to).first
		first.user == user
    end

end