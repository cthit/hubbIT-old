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
  scope :with_mac, -> (mac) { where(mac_address: mac) }
  scope :active, -> { where("end_time > ?", DateTime.now) }
  belongs_to :user, inverse_of: :sessions
  belongs_to :device, foreign_key: :mac_address
end
