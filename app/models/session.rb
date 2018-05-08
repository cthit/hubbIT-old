class Session < ActiveRecord::Base
  scope :with_user, -> (user) { where(user_id: user.id) }
  scope :with_mac, -> (mac) { where(mac_address: mac) }
  scope :active, -> { where("end_time > ?", DateTime.now) }
  belongs_to :device, class_name: 'MacAddress', foreign_key: :mac_address

  def user
    @user ||= User.find self.user_id
  end
end
