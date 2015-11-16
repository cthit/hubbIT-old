require_relative '../achievement'

class TopTenMonth < Achievement

    def initialize
        super 'Top 10 month', 'top_ten_month', 'Place yourself top 10 for a month', 'Hardcore', 25
    end

    def achieved? user
    	from = Date.today.last_month.beginning_of_month
    	to = Date.today.last_month.end_of_month
		UserSession.includes(:user).time_between(from, to).take(10).map(&:user).include?(user)
    end

end