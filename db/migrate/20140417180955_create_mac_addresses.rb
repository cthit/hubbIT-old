class CreateMacAddresses < ActiveRecord::Migration
  def change
    create_table :mac_addresses, primary_key: :address, id: false do |t|
      t.string :address
      t.references :user, index: true

      t.timestamps
    end
  end
end
