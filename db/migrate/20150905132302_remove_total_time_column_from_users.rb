class RemoveTotalTimeColumnFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :total_time
  end

  def down
    add_column :users, :total_time, :integer
  end
end
