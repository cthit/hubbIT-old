require_relative '../achievement'

class OneHundredHours < Achievement

    def initialize
        super '100th hour', 'one_hundred_hours', '', 'Spend 100 hours in the Hub in total', 'Casual', 50
    end

    def achieved? user
        return false if user.users_total_time.nil?
        return (user.users_total_time / 3600) > 100
    end

end
