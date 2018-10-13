class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :show, :update]
  before_action :restrict_user, only: [:show, :edit, :update]

  def index
    @users = User.all.sort_by(&:nick)
  end

  def show
  end

  def edit
  end

  def update
    update_params = user_params[:devices]
    update_params.delete_if do |device|
      device[:address].empty? && device[:device_name].empty?
    end
    if update_devices(update_params)
      redirect_to @user, notice: 'User updated successfully'
    else
      render action: 'edit'
    end
  end


  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(devices: [:address, :_destroy, :device_name])
    end

    def map_to_mac_adresses(devices) 
      devices.map do |device| 
        MacAddress.where(address: device[:address], user_id: @user.id).first_or_create do |m|
          m.device_name = device[:device_name]
        end
      end
    end

    def update_devices(input)
      trash_device_addresses = input.select { |device| device[:_destroy] == '1' }.map { |d| d[:address] }
      good_devices = map_to_mac_adresses input.reject { |device| device[:_destroy] == '1' }

      successful_delete = MacAddress.where(address: trash_device_addresses).destroy_all
      successful_save = good_devices.map { |d| d.save }.all?

      @user.devices = good_devices
      successful_save && successful_delete
    end

    def restrict_user
      unless @user == current_user
        redirect_to users_path, alert: 'You don\'t have access to this page'
      end
    end
end
