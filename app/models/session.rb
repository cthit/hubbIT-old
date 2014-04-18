# == Schema Information
#
# Table name: sessions
#
#  id          :integer          not null, primary key
#  start_time  :datetime
#  end_time    :datetime
#  mac_address :string(255)
#  user_id     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Session < ActiveRecord::Base
  belongs_to :user
end
