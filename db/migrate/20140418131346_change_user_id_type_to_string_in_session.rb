class ChangeUserIdTypeToStringInSession < ActiveRecord::Migration[5.1]
  def up
    change_column :sessions, :user_id, :string
  end
  def down
    change_column :sessions, :user_id, :integer
  end
end
