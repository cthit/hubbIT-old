# == Schema Information
#
# Table name: users
#
#  cid        :string(255)      primary key
#  total_time :integer
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
	has_many :devices, class_name: MacAddress
	has_many :sessions
	has_many :hour_entries, foreign_key: :cid
	has_many :user_sessions

	self.primary_key = :cid

	accepts_nested_attributes_for :devices, allow_destroy: true
end
