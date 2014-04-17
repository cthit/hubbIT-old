# == Schema Information
#
# Table name: mac_addresses
#
#  address    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class MacAddress < ActiveRecord::Base
  belongs_to :user

  self.primary_key = "address"

  validates_presence_of :address
end
