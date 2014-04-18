class MacAddressesController < ApplicationController
	before_action :set_user
	before_action :set_mac_address, only: [:edit, :update, :destroy]

	def new
		@mac_address = @user.devices.build
	end

	def create
		@mac_address = @user.devices.build(mac_address_params)
		if @mac_address.save
			redirect_to @user, notice: 'Added MacAddress'
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

		# Use callbacks to share common setup or constraints between actions.
		def set_mac_address
			@mac_address = MacAddress.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def mac_address_params
			params.require(:mac_address).permit(:address, :user_id)
		end
end
