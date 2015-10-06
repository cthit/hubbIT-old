require_relative '../achievement'

class TopFive < Achievement

    def initialize
        super 'Top 5', 'top_five', 'Place yourself top 5 overall', 'No life', 150
    end

    def achieved? user
        return false if user.users_total_time.nil?
        user.ranking <= 5
    end

end
