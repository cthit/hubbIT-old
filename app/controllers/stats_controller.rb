class StatsController < ApplicationController
  
  def index
  	user_sessions = UserSession.where( "user_id = ? ", "johandf")
  	start_time = user_sessions.first.start_time
  	end_time = user_sessions.first.end_time
  	@result1 = (end_time - start_time)

  	@result2 = UserSession.where( "user_id = ? ", "johandf").sum(end_time - start_time)

  	

  end

  def show
  end
end
