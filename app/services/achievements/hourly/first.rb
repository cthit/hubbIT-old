require_relative '../achievement'

class First < Achievement

    def initialize
        super 'First!!!11eleven', 'first', 'Place yourself first', 'No life', 500
    end

    def achieved? user
        return false if user.users_total_time.nil?
        user.ranking == 1
    end

end
