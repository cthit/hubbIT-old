class UsersTotalTime < ActiveRecord::Base
  self.table_name = "users_total_time"
  belongs_to :user

  def ranking
    UsersTotalTime.where('total_time > ?', self.total_time).count + 1
  end
end
