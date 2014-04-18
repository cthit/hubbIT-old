# == Schema Information
#
# Table name: hour_entries
#
#  id         :integer          not null, primary key
#  cid        :string(255)
#  date       :date
#  hour       :integer
#  created_at :datetime
#  updated_at :datetime
#

class HourEntry < ActiveRecord::Base
  scope :with_user, -> (user) { where(cid: user) }

  belongs_to :user, foreign_key: :cid
end
