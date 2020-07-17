class UserSession < ActiveRecord::Base
  scope :with_user, -> (user) { where(user_id: user.cid) }
  scope :active, -> { where("end_time > ?", DateTime.now) }
  scope :time_between, -> (from='2010-01-01', to='2099-01-01') {
    
    where('start_time >= ? and end_time <= ?', from, to)
      .select('user_id, SUM(TIMESTAMPDIFF(SECOND, START_TIME, END_TIME)) as total_time')
      .group(:user_id)
      .order('total_time DESC')
  }
  scope :with_longest_session, -> {select('user_id, MAX(TIMESTAMPDIFF(SECOND, START_TIME, END_TIME)) as longest_session')}

  def user
    @user ||= User.find self.user_id
  end
end
