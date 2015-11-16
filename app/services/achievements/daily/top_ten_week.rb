require_relative '../achievement'

class TopTenWeek < Achievement

    def initialize
        super 'Top 10 week', 'top_ten_month', 'Place yourself top 10 for a week', 'Casual', 10
    end

    def achieved? user
    	from = Date.today.last_week.beginning_of_week
    	to = Date.today.last_week.end_of_week

		UserSession.includes(:user).time_between(from, to).take(10).map(&:user).include?(user)
    end

end