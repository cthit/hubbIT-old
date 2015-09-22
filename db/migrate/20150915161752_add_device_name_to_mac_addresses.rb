class AddDeviceNameToMacAddresses < ActiveRecord::Migration
  def change
    add_column :mac_addresses, :device_name, :string
  end
end
