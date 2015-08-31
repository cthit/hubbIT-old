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
  belongs_to :user

  def self.total_time
  	@@total_time ||= Rails.cache.fetch "users/total_time", expires_in: 5.minutes do
  		sessions = UserSession.group(:user_id)
    	sessions.select('id','user_id','sum(TIMESTAMPDIFF(SECOND, `start_time`, `end_time`)) as total_time').order("total_time DESC")
  	end
  end
end
