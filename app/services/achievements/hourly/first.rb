require_relative '../achievement'

class First < Achievement

    def initialize
        super 'First', 'first', 'Place yourself first', 'No life', 500
        p 'init first'
    end

    def achieved? user
        return false if user.users_total_time.nil?
        user.ranking <= 1
    end

end
