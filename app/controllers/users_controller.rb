class UsersController < ApplicationController
	before_action :set_user, only: [:edit, :show, :update]

	def index
		@users = User.all
	end

	def show
	end

	def edit
	end

	def update
		if @user.update(user_params)
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
			params.require(:user).permit(devices_attributes: [:address, :id])
		end
end
