require_relative '../achievement'

class TwoHundredHours < Achievement

    def initialize
        super '200th hour', 'two_hundred_hours', 'Spend 200 hours in the Hub in total', 'Hardcore', 100
    end

    def achieved? user
        return false if user.users_total_time.nil?
        return (user.users_total_time.total_time / 3600) > 200
    end

end
