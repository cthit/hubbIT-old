# == Schema Information
#
# Table name: mac_addresses
#
#  address    :string(255)      primary key
#  user_id    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class MacAddress < ActiveRecord::Base
  belongs_to :user

  self.primary_key = :address

  validates :address, presence: true, length: { minimum: 2 }
end
