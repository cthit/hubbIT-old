# == Schema Information
#
# Table name: user_sessions
#
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
end
