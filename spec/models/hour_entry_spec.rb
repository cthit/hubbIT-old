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

require 'spec_helper'

describe HourEntry do
  pending "add some examples to (or delete) #{__FILE__}"
end
