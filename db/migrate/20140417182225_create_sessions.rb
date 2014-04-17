class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.timestamp :start_time
      t.timestamp :end_time
      t.string :mac_address, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
