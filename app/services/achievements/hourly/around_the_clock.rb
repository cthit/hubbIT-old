require_relative '../achievement'

class AroundTheClock < Achievement

    HOURS_IN_DAY = 24

    def initialize
        super 'Around the clock', 'around_the_clock', 'Spend 24 consecutive hours in the Hubb', 'No life', 100
    end

    def achieved? user
        entries = HourEntry.with_user(user).where('(date = ? AND hour > ?) OR date = ?', 
                                                    Time.now.yesterday.to_date, 
                                                    Time.now.hour, 
                                                    Time.now.to_date)
        return false if entries.nil?
        entries.count >= HOURS_IN_DAY
    end

end