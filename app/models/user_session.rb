# == Schema Information
#
# Table name: user_sessions
#
#  id         :integer          not null, primary key
#  start_time :datetime
#  end_time   :datetime
#  user_id    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class UserSession < ActiveRecord::Base
  scope :with_user, -> (user) { where(user_id: user) }
  scope :active, -> { where("end_time > ?", DateTime.now) }
  scope :time_between, -> (from='2010-01-01', to='2099-01-01') {
    
    where('start_time >= ? and end_time <= ?', from, to)
      .select('user_id, SUM(TIMESTAMPDIFF(SECOND, START_TIME, END_TIME)) as total_time')
      .group(:user_id)
      .order('total_time DESC')
  }
  scope :with_longest_session, -> {select('user_id, MAX(TIMESTAMPDIFF(SECOND, START_TIME, END_TIME)) as longest_session')}
  
  scope :time_between, -> (from='2010-01-01', to='2099-01-01') {
    
    where('start_time >= ? and end_time <= ?', from, to)
      .select('user_id, SUM(TIMESTAMPDIFF(SECOND, START_TIME, END_TIME)) as average_hours')
      .group(:user_id)
      .order('average_hours DESC')
  }
  belongs_to :user
end
