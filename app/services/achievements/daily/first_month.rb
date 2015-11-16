require_relative '../achievement'

class FirstMonth < Achievement

    def initialize
        super 'Monthly master', 'first_month', 'Place yourself first for a month', 'Hardcore', 50
    end

    def achieved? user
    	from = Date.today.last_month.beginning_of_month
    	to = Date.today.last_month.end_of_month
		first = UserSession.includes(:user).time_between(from, to).first
		first.user == user
    end

end