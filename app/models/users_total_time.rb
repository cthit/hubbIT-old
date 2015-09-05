class UsersTotalTime < ActiveRecord::Base
  self.table_name = "users_total_time"
  belongs_to :user
end
