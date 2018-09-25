class ChangeUserIdTypeToString < ActiveRecord::Migration[5.1]
  def up
    change_column :mac_addresses, :user_id, :string
  end

  def down
    change_column :mac_addresses, :user_id, :integer
  end
end
