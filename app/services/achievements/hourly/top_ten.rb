require_relative '../achievement'

class TopTen < Achievement

    def initialize
        super 'Top 10', 'top_ten', 'Place yourself top 10 overall', 'Hardcore', 100
    end

    def achieved? user
        return false if user.users_total_time.nil?
        user.ranking <= 10
    end

end
