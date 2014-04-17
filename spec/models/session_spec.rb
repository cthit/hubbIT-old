# == Schema Information
#
# Table name: sessions
#
#  id          :integer          not null, primary key
#  start_time  :datetime
#  end_time    :datetime
#  mac_address :string(255)
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Session do
  pending "add some examples to (or delete) #{__FILE__}"
end
