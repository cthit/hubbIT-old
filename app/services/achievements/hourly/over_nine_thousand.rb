require_relative '../achievement'

class OverNineThousand < Achievement

    def initialize
        super 'Over 9000', 'over_nine_thousand', 'Log over 9000 hours in the Hubb [youtube.com/watch?v=SiMHTK15Pik](https://www.youtube.com/watch?v=SiMHTK15Pik)', 'Insane', 1337
    end

    def achieved? user
        return false if user.users_total_time.nil?
        return (user.users_total_time.total_time / 3600) > 9000
    end

end
