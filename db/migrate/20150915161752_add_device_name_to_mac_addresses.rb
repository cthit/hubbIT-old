class AddDeviceNameToMacAddresses < ActiveRecord::Migration[5.1]
  def change
    add_column :mac_addresses, :device_name, :string
  end
end
