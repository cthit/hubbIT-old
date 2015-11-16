require_relative '../achievement'

class TopTwentyMonth < Achievement

    def initialize
        super 'Top 20 month', 'top_twenty_month', 'Place yourself top 20 for a month', 'Casual', 10
    end

    def achieved? user
    	from = Date.today.last_month.beginning_of_month
    	to = Date.today.last_month.end_of_month
		UserSession.includes(:user).time_between(from, to).take(20).map(&:user).include?(user)
    end

end