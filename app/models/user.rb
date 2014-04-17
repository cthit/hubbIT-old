# == Schema Information
#
# Table name: users
#
#  cid        :string(255)
#  total_time :integer
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
	has_many :devices, class_name: MACAddress
end
