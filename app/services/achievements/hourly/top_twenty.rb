require_relative '../achievement'

class TopTwenty < Achievement

    def initialize
        super 'Top 20', 'top_twenty', '', 'Place yourself top 20 overall', 'Hardcore', 50
    end

    def achieved? user
        return false if user.users_total_time.nil?
        user.ranking <= 20
    end

end
