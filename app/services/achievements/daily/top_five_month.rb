require_relative '../achievement'

class TopFiveMonth < Achievement

    def initialize
        super 'Top 5 month', 'top_five_month', 'Place yourself top 5 for a month', 'Hardcore', 40
    end

    def achieved? user
    	from = Date.today.last_month.beginning_of_month
    	to = Date.today.last_month.end_of_month
		UserSession.includes(:user).time_between(from, to).take(5).map(&:user).include?(user)
    end

end