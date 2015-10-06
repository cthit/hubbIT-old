require_relative '../achievement'

class TwelveConsecetiveHours < Achievement

    THRESHOLD = 12

    def initialize
        super 'Extreme study day', 'study_day', 'Spend 12 consecutive hours in the Hub', 'Hardcore', 50
    end

    def achieved? user
        passed_new_day = (Time.now - THRESHOLD.hours).to_date != Time.now.to_date
        entries = HourEntry.with_user(user).order(:id)
        if passed_new_day
            entries = entries.where('(date = ? AND hour >= ?) OR date = ?', 
                                                    Time.now.yesterday.to_date, 
                                                    (Time.now - THRESHOLD.hours).hour, 
                                                    Time.now.to_date)
        else
             entries = entries.where('(date = ? AND hour >= ?)', 
                                                    Time.now.to_date,
                                                    (Time.now - THRESHOLD.hours).hour)
        end
        return false unless entries.any?

        max_number_of_consecetive_hours = self.max_number_of_consecetive_hours entries

        max_number_of_consecetive_hours >= THRESHOLD
    end


    def max_number_of_consecetive_hours entries
        return 0 unless entries.any?

        result = entries.drop(1).reduce [entries.first.hour, 1,1] do |acc, curr|
            hour=acc[0]
            count=acc[1]
            max=acc[2]

            next_hour = (hour+1)%24
            hour = curr.hour

            if hour == next_hour
                max = count if count > max
                [hour, count+1, max]
            else
                max = count if count > max
                [hour, 1, max]                                     
            end
        end

        return result[2]
    end
end