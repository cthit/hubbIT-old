class MacAddress < ActiveRecord::Base
  has_many :sessions, foreign_key: :mac_address

  before_validation :format_mac

  self.primary_key = :address

  validates :address, presence: true, uniqueness: true, format: { with: /\A([0-9A-F]{2}[:-]?){5}([0-9A-F]{2})\z/ }

  def user
    @user = User.find self.user_id
  end

  def user=(user)
    @user = user
    self.update_attribute(:user_id, user.id)
  end

  private
    def format_mac
      if address.present?
        self.address = address.strip.upcase.gsub(/[-:]/, '').scan(/.{2}/).join ':'
      end
    end
end
