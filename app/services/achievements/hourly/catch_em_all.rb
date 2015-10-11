require_relative '../achievement'

class CatchEmAll < Achievement

    def initialize
        super "Gotta catch 'em all!", 'catch_em_all', 'You wanna be the very best? Catch all the hours (log at least once for every hour)', 'Hardcore', 200
    end

    def achieved? user
        entries = HourEntry.with_user(user).group(:hour)
        return false if entries.nil?
        return entries.count(:hour).values.count == 24
    end

end