class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, primary_key: :cid, id: false do |t|
      t.string :cid
      t.integer :total_time

      t.timestamps
    end
  end
end
