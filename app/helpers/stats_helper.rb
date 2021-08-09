module StatsHelper

    @@study_years = [
        [Time.new(2015,8,18), Time.new(2016,8,15)],
        [Time.new(2016,8,16), Time.new(2017,8,15)],
        [Time.new(2017,8,16), Time.new(2018,8,15)],
        [Time.new(2018,8,16), Time.new(2019,8,15)],
        [Time.new(2019,8,16), Time.new(2020,8,15)],
        [Time.new(2020,8,16), Time.new(2021,8,15)],
    ]

    @@study_period = [
        [Time.new(2015,8,31), Time.new(2015,11,1)],
        [Time.new(2015,11,2), Time.new(2016,1,17)],
        [Time.new(2016,1,18), Time.new(2016,3,20)],
        [Time.new(2016,3,21), Time.new(2016,6,4)],

        [Time.new(2016,6,5), Time.new(2016,8,28)],  #sommar läsperiod... vi orkar inte hantera detta edgecaset på något annat sätt

        [Time.new(2016,8,29), Time.new(2016,10,29)],
        [Time.new(2016,10,30), Time.new(2017,1,14)],
        [Time.new(2017,1,15), Time.new(2017,3,18)],
        [Time.new(2017,3,19), Time.new(2017,6,9)],

        [Time.new(2017,6,10), Time.new(2017,8,27)], # Summer break

        [Time.new(2017,8,28), Time.new(2017,10,29)],
        [Time.new(2017,10,30), Time.new(2018,1,14)],
        [Time.new(2018,1,15), Time.new(2018,3,18)],
        [Time.new(2018,3,19), Time.new(2018,6,5)],

        [Time.new(2018,6,6), Time.new(2018,9,2)], # Summer break
        
        [Time.new(2018,9,3), Time.new(2018,11,4)], #LP1
        [Time.new(2018,11,5), Time.new(2019,1,20)], #LP2
        [Time.new(2019,1,21), Time.new(2019,3,24)], #LP3
        [Time.new(2019,3,25), Time.new(2019,6,8)], #LP4
        
        [Time.new(2019,6,9), Time.new(2019,9,3)], # Summer break

        [Time.new(2019,9,3), Time.new(2019,11,4)], #LP1
        [Time.new(2019,11,5), Time.new(2020,1,20)], #LP2
        [Time.new(2020,1,21), Time.new(2020,3,24)], #LP3
        [Time.new(2020,3,25), Time.new(2020,6,8)], #LP4
        
        [Time.new(2020,6,9), Time.new(2020,8,30)], # Summer break

        [Time.new(2020,8,31), Time.new(2020,11,1)], #LP1
        [Time.new(2020,11,2), Time.new(2021,1,17)], #LP2
        [Time.new(2021,1,18), Time.new(2021,3,21)], #LP3
        [Time.new(2021,3,22), Time.new(2021,6,6)], #LP4
        
        [Time.new(2021,6,7), Time.new(2021,8,29)], # Summer break
        
        [Time.new(2021,8,30), Time.new(2021,01,15)], #LP1
        [Time.new(2021,11,1), Time.new(2022,1,16)],  #LP2
        [Time.new(2022,1,17), Time.new(2022,3,20)],  #LP3
        [Time.new(2022,3,21), Time.new(2022,6,5)],   #LP4
    ]

    def get_current_study_year_index()
        @@study_years.each_with_index do |study_year, index|
            if study_year[0].beginning_of_day <= Time.now && Time.now <= study_year[1].end_of_day
              return index
            end
        end
    end

    def get_current_study_period_index()
        @@study_period.each_with_index do |study_period, index|
            if study_period[0] <= Time.now && Time.now <= study_period[1]
                return index
            end
        end
    end

    def get_study_year(index)
        new_index = [0, index].max
        new_index = [new_index, @@study_years.length-1].min
        @@study_years[new_index]
    end

    def get_study_period(index)
        new_index = [0, index].max
        new_index = [new_index, @@study_period.length-1].min
        @@study_period[new_index]
    end

    def seconds_to_words(seconds)
        distance_of_time_in_words Time.at(0).utc, Time.at(seconds).utc
    end

    def seconds_to_precise_words(seconds)
        d = Duration.new(seconds)
        wf = "%ww "
        df = "%dd "
        hf = "%hh "
        mf = "%mm "
        format = ""
        format += wf if d.weeks > 0
        format += df if d.days > 0
        format += hf if d.hours > 0
        format += mf if d.minutes > 0
        format += "%ss"
        d.format(format)
    end


    def seconds_to_units(secs)
        mm, ss = secs.divmod(60)
        hh, mm = mm.divmod(60)
        [hh, mm, ss].map { |n| n < 10 ? "0#{n}" : n }.join(':')
    end

    def seconds_to_score(seconds)
        seconds / 60
    end

    def info_box(title, &block)
        render 'info_box', title: title, block: block
    end

    def user_active?(user)
        @active_users.include? user
    end

    def current_session
        Time.zone.now - @session.start_time
    end

    def seconds_today
      seconds = 0
        @user_sessions.where("created_at >= ?", Time.now.beginning_of_day).each do |s|
          seconds += (s.end_time - s.start_time)
        end

        if @session.present? && @session.end_time > Time.zone.now
          seconds - (@session.end_time - Time.zone.now)
        else
          seconds
        end
    end

    def human_time_today
      secs = seconds_today
      return seconds_to_precise_words(secs) if secs > 0
      "Not seen today"
    end

    def time_for_group(group)
        users_in_group = @sessions_within_timeframe.select { |s| s.user.groups.name.include? group}
        users_in_group.map { |s| s.total_time }.sum
    end

    def get_sorted_groups_with_time()
        Hash[User::ALLOWED_GROUPS.map { |g| [g, (time_for_group g.to_s)] } ]
        .sort_by{ |_k, v| v}.reverse
    end

    def link_title from
      "Show stats from #{from}"
    end

    def timeframe_links
      # List of the anchor links to show on /stats
      [ # Name             Link
       ['All Time',    :all_time],
       ['Study Year',    :study_year],
       ['Study Period',    :study_period],
       ['Monthly stats',   :month],
       ['Weekly stats',    :week],
       ['Daily stats', :day],
      ]
    end

    def row_classes user
      classes = []
      classes << 'active' if user_active?(user)
      classes << 'me' if user.cid == current_user.cid
      classes.join ' '
    end

    def all_time?
        @timeframe == 'all_time'
    end

    def change_page nbr
      case @timeframe
        when 'year'
          [(@from + nbr.year).beginning_of_year, (@to + nbr.year).end_of_year]
        when 'study_year'
          from, to = get_study_year(get_current_study_year_index+nbr)
          [(from).beginning_of_day, (to).end_of_day]
        when 'study_period'
          from, to = get_study_period(get_current_study_period_index+nbr)
          [(from).beginning_of_day, (to).end_of_day]
        when 'month'
          [(@from + nbr.month).beginning_of_month, (@to + nbr.month).end_of_month]
        when 'week'
          [(@from + nbr.weeks).beginning_of_week, (@to + nbr.weeks).end_of_week]
        when 'day'
          [(@from + nbr.day).beginning_of_day, (@to + nbr.day).end_of_day]
        else
          [@from, @to]
      end
    end

    def selected_timeframe frame
      'selected' if @timeframe == frame.to_s
    end

    def format_to_on_frame frame
      if frame.to_s == 'day'
        (@to + 1.seconds).to_date
      else
        @to.to_date
      end
    end

    def display_arrow user
      no_session_number = 9999

      if @sessions_within_timeframe.nil? || @timeframe.nil?
        return nil
      end

      index = @sessions_within_timeframe.find_index { |s| s.user.cid == user }
      old_index = if @old_sessions_within_timeframe.present?
        @old_sessions_within_timeframe.find_index { |s| s.user.cid == user } || 9999
      else
        no_session_number
      end

      if index < old_index
        from = old_index == no_session_number ? "You weren't here!" : "Up from " + (old_index + 1).to_s
        return image_tag 'up-arrow.svg', title: from
      elsif index > old_index
        return image_tag 'down-arrow.svg', title: "Down from " + old_index.to_s
      else
        return nil
      end
    end
end
