require_relative '../achievement'

class First < Achievement

    def initialize
<<<<<<< Updated upstream
        super 'First', 'first', 'Place yourself first', 'No life', 500
        p 'init first'
=======
        super 'First!!!11eleven', 'first', 'Place yourself first', 'No life', 500
>>>>>>> Stashed changes
    end

    def achieved? user
        return false if user.users_total_time.nil?
        user.ranking == 1
    end

end
