require_relative '../achievement'

class TopTwentyWeek < Achievement

    def initialize
        super 'Top 20 week', 'top_twenty_month', 'Place yourself top 20 for a week', 'Noob', 5
    end

    def achieved? user
    	from = Date.today.last_week.beginning_of_week
    	to = Date.today.last_week.end_of_week

		UserSession.includes(:user).time_between(from, to).take(20).map(&:user).include?(user)
    end

end