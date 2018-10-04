class CreateUserSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :user_sessions do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :user_id

      t.timestamps
    end
    add_index :user_sessions, :user_id
  end
end
