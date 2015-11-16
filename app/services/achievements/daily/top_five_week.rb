require_relative '../achievement'

class TopFiveWeek < Achievement

    def initialize
        super 'Top 5 week', 'top_five_week', 'Place yourself top 5 for a week', 'Hardcore', 20
    end

    def achieved? user
    	from = Date.today.last_week.beginning_of_week
    	to = Date.today.last_week.end_of_week

		UserSession.includes(:user).time_between(from, to).take(5).map(&:user).include?(user)
    end

end