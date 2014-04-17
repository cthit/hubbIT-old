class MacAddressesController < ApplicationController
	

	def new
		@user = User.find(params[:user_id])
		@mac_address = @user.devices.build
	end

	def create
		
	end

	def destroy
		
	end

	def edit
		@mac_address = MacAddress.find(params[:id])
	end

	def update
		
	end
end
