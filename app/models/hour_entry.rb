class HourEntry < ActiveRecord::Base
  scope :with_user, -> (user) { where(cid: user) }

  def user
    @user ||= User.find self.cid
  end
end
