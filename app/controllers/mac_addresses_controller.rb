class MacAddressesController < ApplicationController
	before_action :set_user
	before_action :set_mac_address, only: [:edit, :update, :destroy]

	def new
		@mac_address = MacAddress.new
	end

	def create
		@mac_address = @user.devices.build(mac_address_params)
		if @mac_address.save
			redirect_to @user, notice: "Added MacAddress"
		else
			render action: 'new'
		end
	end

	def destroy
		
	end

	def edit
		
	end

	def update
		
	end

	private
		def set_user
			@user = User.find(params[:user_id])
		end

		def set_mac_address
			@mac_address = MacAddress.find(params[:id])
		end

		def mac_address_params
			params.require(:mac_address).permit(:address)
		end
end
