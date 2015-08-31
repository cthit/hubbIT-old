class UsersController < ApplicationController
    before_action :set_user, only: [:edit, :show, :update]
    before_action :restrict_user, only: [:show, :edit, :update]

    def index
        @users = User.all.sort_by(&:nick)
    end

    def show
    end

    def edit
        @user.devices.build
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
            params.require(:user).permit(devices_attributes: [:address, :id, :_destroy])
        end

        def restrict_user
            unless @user == current_user
                redirect_to users_path, alert: 'You don\'t have access to this page'
            end
        end
end
