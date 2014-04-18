class SessionsController < ApplicationController

  before_action :set_session, only: [:show, :edit]

  def index
    @sessions = Session.all
  end

  def create
  end

  def update
  end

  def show
  end

  private
    def session_params
      params.require(:session).permit(:mac_address, :user_id)
    end

    def set_session
      @session = Session.find(params[:id])
    end
end
