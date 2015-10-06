require_relative '../achievement'

class OneDay < Achievement

    def initialize
        super 'A day well spent', 'one_day', 'Spend 24 hours in the Hub in total', 'Noob', 10
    end

    def achieved? user
        return false if user.users_total_time.nil?
        return (user.users_total_time.total_time / 3600) > 24
    end

end
