module StatsHelper

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

    def seconds_today
      seconds = 0
        @user_sessions.where("created_at >= ?", Time.now.beginning_of_day).each do |s|
          seconds += (s.end_time - s.start_time)
        end

        seconds
    end

    def human_time_today
      secs = seconds_today
      return seconds_to_precise_words(secs) if secs > 0
      "Not seen today"
    end

    def time_for_group(group)
        users_in_group = @sessions_within_timeframe.select { |s| s.user.groups.include? group}
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
       ['Daily stats', :day],
       ['Weekly stats',    :week],
       ['Monthly stats',   :month],
      ]
    end

    def row_classes user
      classes = []
      classes << 'active' if user_active?(user)
      classes << 'me' if user.id == current_user.id
      classes.join ' '
    end


    def change_page nbr
      case @timeframe
        when 'year'
          [@from + nbr.year, @to + nbr.year]
        when 'month'
          [@from + nbr.month, @to + nbr.month]
        when 'week'
          [@from + nbr.weeks, @to + nbr.weeks]
        when 'day'
          [@from + nbr.day, @to + nbr.day]
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
      if @sessions_within_timeframe.nil? || @timeframe.nil?
        return nil
      end

      index = @sessions_within_timeframe.index { |s| s.user.cid == user }
      old_index = if @old_sessions_within_timeframe.present? 
        @old_sessions_within_timeframe.index { |s| s.user.cid == user } || 9999
      else
        9999
      end

      if index < old_index
        return image_tag 'up-arrow.svg' 
      elsif index > old_index
        return image_tag 'down-arrow.svg'
      else
        return nil
      end
    end
end
